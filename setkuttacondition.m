function [kuttaArray] = setkuttacondition(sourceContribution,vortexContribution)
    %SETKUTTACONDITION Builds the Kutta condition array.
    %
    %   Arguments
    %   ----------
    %   sourceContribution: 2D array of floats
    %       Source contribution matrix for the velocity normal to the
    %       planes.
    %   vortexContribution: 2D array of floats
    %       Vortex contribution matrix for the velocity normal to the
    %       planes.
    %
    %   Returns
    %   -------
    %   kuttaArray: 1D array of floats
    %       The left-hand side of the Kutta-condition equation.

    arguments
        sourceContribution {mustBeFloat}
        vortexContribution {mustBeFloat}
    end
    
    kuttaArray = vortexContribution(1,:) + ...
                 vortexContribution(end,:);
    kuttaArray(end+1) = (-1) * sum(sourceContribution(1,:) + ...
                                     sourceContribution(end,:));
end

