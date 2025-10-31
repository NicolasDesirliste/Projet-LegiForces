// DepartmentDetector.js - Détection des départements cliqués sur la carte SVG
.pragma library

// Parse SVG path data to get polygon points
function parseSvgPath(pathData) {
    var points = [];
    var commands = pathData.match(/[MmLlHhVvCcSsQqTtAaZz][^MmLlHhVvCcSsQqTtAaZz]*/g);

    if (!commands) return points;

    var currentX = 0;
    var currentY = 0;
    var startX = 0;
    var startY = 0;

    for (var i = 0; i < commands.length; i++) {
        var cmd = commands[i][0];
        var values = commands[i].slice(1).trim().split(/[\s,]+/).filter(function(v) { return v !== ''; });
        values = values.map(function(v) { return parseFloat(v); });

        switch(cmd) {
            case 'M': // moveto absolute
                if (values.length >= 2) {
                    currentX = values[0];
                    currentY = values[1];
                    startX = currentX;
                    startY = currentY;
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'm': // moveto relative
                if (values.length >= 2) {
                    currentX += values[0];
                    currentY += values[1];
                    startX = currentX;
                    startY = currentY;
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'L': // lineto absolute
                for (var j = 0; j < values.length; j += 2) {
                    if (j + 1 < values.length) {
                        currentX = values[j];
                        currentY = values[j + 1];
                        points.push({x: currentX, y: currentY});
                    }
                }
                break;
            case 'l': // lineto relative
                for (var j = 0; j < values.length; j += 2) {
                    if (j + 1 < values.length) {
                        currentX += values[j];
                        currentY += values[j + 1];
                        points.push({x: currentX, y: currentY});
                    }
                }
                break;
            case 'H': // horizontal lineto absolute
                for (var j = 0; j < values.length; j++) {
                    currentX = values[j];
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'h': // horizontal lineto relative
                for (var j = 0; j < values.length; j++) {
                    currentX += values[j];
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'V': // vertical lineto absolute
                for (var j = 0; j < values.length; j++) {
                    currentY = values[j];
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'v': // vertical lineto relative
                for (var j = 0; j < values.length; j++) {
                    currentY += values[j];
                    points.push({x: currentX, y: currentY});
                }
                break;
            case 'Z':
            case 'z': // closepath
                points.push({x: startX, y: startY});
                break;
            // Pour simplicité, on ignore les courbes (C, c, S, s, Q, q, T, t, A, a)
            // Les points de ligne suffisent pour la détection
        }
    }

    return points;
}

// Point-in-polygon algorithm (ray casting)
function isPointInPolygon(point, polygon) {
    var x = point.x;
    var y = point.y;
    var inside = false;

    for (var i = 0, j = polygon.length - 1; i < polygon.length; j = i++) {
        var xi = polygon[i].x;
        var yi = polygon[i].y;
        var xj = polygon[j].x;
        var yj = polygon[j].y;

        var intersect = ((yi > y) !== (yj > y))
            && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }

    return inside;
}

// Load and parse SVG department data
function loadDepartmentData() {
    // Cette fonction sera appelée pour charger les données du SVG
    // Pour l'instant, retourne un tableau vide - sera rempli au chargement
    return [];
}

// Find which department contains the clicked point
function findDepartmentAtPoint(svgX, svgY, departmentData) {
    var point = {x: svgX, y: svgY};

    for (var i = 0; i < departmentData.length; i++) {
        var dept = departmentData[i];
        if (isPointInPolygon(point, dept.polygon)) {
            return dept;
        }
    }

    return null;
}

// Convert mouse coordinates to SVG viewBox coordinates
function mouseToSvgCoordinates(mouseX, mouseY, imageWidth, imageHeight, viewBox) {
    // viewBox: {x: 105, y: 18, width: 568, height: 567}

    // Calculate the scale factor
    var scaleX = viewBox.width / imageWidth;
    var scaleY = viewBox.height / imageHeight;

    // Convert to SVG coordinates
    var svgX = (mouseX * scaleX) + viewBox.x;
    var svgY = (mouseY * scaleY) + viewBox.y;

    return {x: svgX, y: svgY};
}
