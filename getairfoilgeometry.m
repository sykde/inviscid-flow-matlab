function [airfoilBoundaryPoints] = getairfoilgeometry(fileName)
%GETAIRFOILGEOMETRY: Returns boundary points of a shape
%
%   Arguments
%   ---------
%   fileName: String
%       Name (or path) of the file that contains a list of points
%       in 2 columns that describe a shape. In column 1, x-coords
%       are expected and in column 2, y-coords.
%
%   Returns
%   -------
%   airfoilBoundaryPoints: 2D array of Floats
%       An array of size [2, N] that contains all the points from
%       file `fileName`

    arguments
        fileName {mustBeFile}
    end

    fileID = fopen(fileName, 'r');
    airfoilBoundaryPoints = fscanf(fileID, '%f %f', [2, Inf]);
end

