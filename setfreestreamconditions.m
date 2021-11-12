function [freeStreamConditionMatrix] = setfreestreamconditions(panels, freeStream)
    %SETFREESTREAMCONDITIONS Builds the right-hand side of the system 
    %arising from the freestream contribution.
    %
    %   Arguments
    %   ----------
    %   panels: 1D array of Panel objects
    %       List of the panels used to describe the airfoil.
    %   freeStream: FreeStream object
    %       Properties of the free stream.
    %
    %   Returns
    %   -------
    %   freeStreamConditionMatrix: 1D array of float
    %       List of the free stream conditions. The last element of the
    %       array is the vortex condition.

    arguments
        panels {mustBeNonempty}
        freeStream {mustBeNonempty}
    end

    freeStreamConditionMatrix = zeros([length(panels)+1, 1]);

    % Contribution of free stream on panel "iPanel"
    for iPanel = 1:length(panels)
        freeStreamConditionMatrix(iPanel, 1) = (-1) * freeStream.Uinf * ...
            cos(deg2rad(freeStream.alpha - panels(iPanel).beta));
    end
    freeStreamConditionMatrix(end, 1) = (-1) * freeStream.Uinf * ...
        (sin(deg2rad(freeStream.alpha - panels(1).beta)) + ...
        sin(deg2rad(freeStream.alpha - panels(end).beta)));
end