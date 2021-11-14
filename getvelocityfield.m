function [u, v] = getvelocityfield(panels, freeStream, X, Y)
%GETVELOCITYFIELD Computes the velocity field on a given 2D mesh.
%
%   Arguments
%   ---------
%   panels: 1D array of Panel objects
%       The source panels.
%   freeStream: Freestream object.
%       The freestream conditions.
%   X: 2D array of floats
%       x-Coordinates of the mesh points.
%   Y: 2D array of floats
%       y-Coordinates of the mesh points.
%
%   Returns
%   -------
%   u: 2D array of floats
%       x-Component of the velocity vector field.
%   v: 2D array of floats
%       y-Component of the velocity vector field.

    arguments
        panels {mustBeNonempty}
        freeStream {mustBeNonempty}
        X {mustBeFloat}
        Y {mustBeFloat}
    end

    % Free stream contribution
    u = freeStream.Uinf * cos(freeStream.alpha) * ones(size(X));
    v = freeStream.Uinf * sin(freeStream.alpha) * ones(size(X));

    % Add the contribution from each panel's source
    
    for ii = 1:height(X)
        for jj = 1:length(X)
            for i = 1:length(panels)
                u(ii,jj) = u(ii,jj) + panels(i).sigma / (2.0 * pi) * getintegraloverpanel(X(ii,jj),Y(ii,jj), panels(i), 1.0, 0.0);
                v(ii,jj) = v(ii,jj) + panels(i).sigma / (2.0 * pi) * getintegraloverpanel(X(ii,jj),Y(ii,jj), panels(i), 0.0, 1.0);
            end %i
        end %jj
    end %ii

end

