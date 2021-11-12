function [singularityMatrix] = createsingularitymatrix(sourceContribution,vortexContribution)
    %CREATESINGULARITYMATRIX Builds the left-hand-side matrix of the system
    % arising from source and vortex contributions.
    %
    %   Arguments
    %   ---------
    %   sourceContribution: 2D array of floats
    %       Source contribution matrix for the velocity normal to
    %       the panels.
    %   vortexContribution: 2D array of floats
    %       Vortex contribution matrix for the velocity normal to
    %       the panels.
    %
    %   Returns
    %   -------
    %   singularityMatrix: type = 2D array of floats
    %       The left-hand-side matrix of the system arising from source and
    %       vortex contributions.
    
    arguments
        sourceContribution {mustBeFloat}
        vortexContribution {mustBeFloat}
    end

    kuttaCondition = setkuttacondition(sourceContribution, vortexContribution);
    vortexContribution = sum(vortexContribution,2); % Sum of every row
    singularityMatrix = zeros(size(sourceContribution)+1);

    singularityMatrix(1:(end-1), 1:(end-1)) = sourceContribution;
    singularityMatrix(1:(end-1), end) = vortexContribution;
    singularityMatrix(end, :) = kuttaCondition;
end