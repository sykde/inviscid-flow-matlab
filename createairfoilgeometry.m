function [xAirfoilCoords, yAirfoilCoords] = createairfoilgeometry(maxCamber, maxCamberPosition, maxThickness, chord, nPointsPerSide)
    %CREATEAIRFOILGEOMETRY Creates a list of points describing the boundary
    % of a NACA 4-digit airfoil.
    %
    %   Arguments
    %   ----------
    %   maxCamber: Integer
    %       Maximum camber of airfoil divided by 100, as percentage of the
    %       chord's length. Must be a single digit integer between 0 and 9.
    %   maxCamberPosition: Integer
    %       Position of the maximum camber divided by 10, as percentage of
    %       the chord's length. Must be a single digit integer between 0
    %       and 9.
    %   maxThickness: Integer
    %       Thickness of the airfoil divided by 100 as a percentage of the
    %       chord's length. Must be an integer between 01 and 40.
    %   chord: Float
    %       Length of the airfoil's chord.
    %   nPointsPerSide: Integer
    %       Number of points on one side of the airfoil (upper/lower).
    %
    %   Returns
    %   -------
    %   xAirfoilCoords: 1D array of floats
    %       x-Coordinates of the airfoil.
    %   yAirfoilCoords: 1D array of floats
    %       y-Coordinates of the airfoil.

    arguments
        maxCamber {mustBeInteger, mustBeInRange(maxCamber, 0, 9)}
        maxCamberPosition {mustBeInteger, mustBeInRange(maxCamberPosition, 0, 9)}
        maxThickness {mustBeInteger, mustBeInRange(maxThickness, 1, 40)}
        chord {mustBeFloat, mustBeNonzero}
        nPointsPerSide {mustBeInteger, mustBeNonzero}
    end

    if xor(maxCamber ~= 0, maxCamberPosition ~= 0)
        error('maxCamber and maxCamberPosition must be both 0 or both integers between 1 and 9')
    end

    maxCamber = maxCamber / 100;
    maxCamberPosition = maxCamberPosition / 10;
    maxThickness = maxThickness / 100;

    % Definition: p = maxCamberPosition * chord;
    
    if and(maxCamber ~= 0, maxCamberPosition ~= 0)
        %for 0 <= x <= p:
        yc1 = @(t) (maxCamber / maxCamberPosition^2) * ...
               (2 * maxCamberPosition * t - t.^2);
        %for p < x <= chord:
        yc2 = @(t) (maxCamber/ (1 - maxCamberPosition)^2 ) * ...
               ((1 - 2 * maxCamberPosition) + 2 * maxCamberPosition * t ...
               - t.^2);
        
        angleRange = linspace(0, pi, nPointsPerSide);
        x = (1 - cos(angleRange)) ./ 2;
        whereIsP = maxCamberPosition * chord;
        betaOfP = acos(1 - 2 * whereIsP);
        tiny = pi/(2*nPointsPerSide);
        whereIsP = and(angleRange > betaOfP - tiny, angleRange < betaOfP + tiny);
        whereIsP = find(whereIsP == 1);
        yc = [yc1(x(1:whereIsP)), yc2(x(whereIsP+1:end))];

        % derivative of yc: (dy/dx)
        dyc1dx = @(t) (maxCamber / maxCamberPosition^2) * ...
            (2 * maxCamberPosition - 2 * t);
        dyc2dx = @(t) (maxCamber/ (1 - maxCamberPosition)^2 ) * ...
            (2 * maxCamberPosition - 2 * t);

        theta = [atan(dyc1dx(x(1:whereIsP))), ...
                 atan(dyc2dx(x(whereIsP+1:end)))];

    elseif and(maxCamber == 0, maxCamberPosition == 0)
        angleRange = linspace(0, pi, nPointsPerSide);
        x = (1 - cos(angleRange)) ./ 2;

    end

    yt = 5 * maxThickness * chord * ( ...
            0.2969 * sqrt(x/chord) - ...
            0.1260 * (x/chord) - ...
            0.3516 * (x/chord).^2 + ...
            0.2843 * (x/chord).^3 - ...
            0.1036 * (x/chord).^4 ... % 0.1015 for non-closed trailing edge
            );

    % upper surface:
    if and(maxCamber == 0, maxCamberPosition == 0)
        xU = x;
        yU =  yt;
        xL = x;
        yL = -yt; 
    elseif and(maxCamber ~= 0, maxCamberPosition ~= 0)
        xU =  x - yt .* sin(theta);
        yU = yc + yt .* cos(theta);
        xL =  x + yt .* sin(theta);
        yL = yc - yt .* cos(theta);
    end

    xAirfoilCoords = [flip(xU), xL(2:end)];
    yAirfoilCoords = [flip(yU), yL(2:end)];

end