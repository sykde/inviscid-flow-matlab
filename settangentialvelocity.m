function [panels] = settangentialvelocity(panels, freeStream, sourceContributionMatrix, vortexContributionMatrix)
    %SETTANGENTIALVELOCITY Computes the panels' tangential surface
    % velocity.
    %
    %   Arguments
    %   ----------
    %   panels: 1D array of Panel objects
    %       List of panels used to describe the airfoil. Source and vortex
    %       strengths must have been calculated beforehand.
    %   freeStream: FreeStream object
    %       Properties of the free stream.
    %   sourceContributionMatrix: 1D array of floats
    %       Source contribution matrix for the velocity normal to the
    %       planes.
    %   vortexContributionMatrix: 1D array of floats
    %       Vortex contribution matrix for the velocity normal to the
    %       planes.
    % 
    %   Returns
    %   -------
    %   panels: 1D array of Panel objects
    %       Inserts the tangential velocity property in every panel from
    %       input.

    arguments
        panels {mustBeNonempty}
        freeStream {mustBeNonempty}
        sourceContributionMatrix {mustBeFloat}
        vortexContributionMatrix {mustBeFloat}
    end
    
    % matrix of source contribution on tangential velocity
    % is the same than
    % matrix of vortex contribution on normal velocity
    A = vortexContributionMatrix;
    % matrix of vortex contribution on tangential velocity
    % is the opposite of
    % matrix of source contribution on normal velocity
    A = [A, (-1) * sum(sourceContributionMatrix, 2)];
    % freestream contribution
    b = zeros([1, length(panels)+1]);
    for iPanel = 1:length(panels)
        b(iPanel) = freeStream.Uinf * sin(deg2rad(freeStream.alpha - panels(iPanel).beta));
    end
    b(end) = 0;
    
    strengths = zeros([1, length(panels) + 1]);
    for iPanel = 1:length(panels)
        strengths(1,iPanel) = panels(iPanel).sigma;
    end
    strengths(1,end) = panels(end).gamma;
    
    tangentialVelocity = zeros([length(panels), 1]);
    for iA = 1:height(A)
        tangentialVelocity(iA,1) = dot(A(iA,:), strengths) + b(iA);
    end
    
    for iPanel = 1:length(panels)
        panels(iPanel).vt = tangentialVelocity(iPanel);
    end
end