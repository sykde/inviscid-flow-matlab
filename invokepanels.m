function [panels] = invokepanels(X, Y)
%INVOKEPANELS: Creates panels between all the points a specific geometry
%   consists of.
%
%   Arguments
%   ----------
%   X: 1D array of floats
%       x-Coordinates of the geometry.
%   Y: 1D array of floats
%       y-Coordinates of the geometry.
%
%   Returns
%   -------
%   panels: 1D array of Panel objects.
%       The list of panels.

    arguments
        X {mustBeFloat}
        Y {mustBeFloat}
    end

    if (size(X) ~= size(Y))
        error('X and Y must be of the same size')
    end

    % preallocate array of panels
    panels = repmat(Panel(0,0,0,0), 1, length(X)-1);

    for i = 1:(length(X)-1)
        panels(i) = Panel(X(i), Y(i), X(i+1), Y(i+1));
    end
end