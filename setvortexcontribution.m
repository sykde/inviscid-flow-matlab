function [vortexContributionMatrix] = setvortexcontribution(panels)
    %SETVORTEXCONTRIBUTIONNORMAL Builds the vortex contribution matrix for 
    % the normal velocity.
    %
    %   Arguments
    %   ----------
    %   panels: Panel object
    %       List of panels.
    %
    %   Returns
    %   -------
    %   vortexContributionMatrix: 1D array of floats.
    %       Contribution of vortex to the flow.

    arguments
        panels {mustBeNonempty}
    end
    
    vortexContributionMatrix = zeros([1,length(panels)]);

    for iPanel = 1:length(panels)
        for jPanel = 1:length(panels)
            if iPanel ~= jPanel
                vortexContributionMatrix(iPanel, jPanel) = ... 
                    -(0.5 / pi) * getintegraloverpanel( ...
                                    panels(iPanel).xC, panels(iPanel).yC, ...
                                    panels(jPanel), ...
                                    sin(deg2rad(panels(iPanel).beta)), ...
                               (-1)*cos(deg2rad(panels(iPanel).beta)) );
            end %if
        end %for jPanel
    end %for iPanel
end

