function [sourceContributionMatrix] = setsourcecontribution(panels)
    %SETSOURCECONTRIBUTION Builds the source contribution matrix for
    % the normal velocity.
    %
    %   Arguments
    %   ----------
    %   panels: 1D array of Panel objects
    %       List of panels.
    %
    %   Returns
    %   -------
    %   sourceContributionMatrix: 2D array of floats
    %       Source contribution matrix.

    arguments
        panels {mustBeNonempty}
    end

    % Source contribution on a panel from itself
    diagonalElements = 0.5 * ones([1, length(panels)]);
    sourceContributionMatrix = diag(diagonalElements);

    % Source contribution on a panel from others
    for iPanel = 1:length(sourceContributionMatrix)
        for jPanel = 1:length(sourceContributionMatrix)
            if iPanel ~= jPanel
                sourceContributionMatrix(iPanel, jPanel) = ...
                    (0.5 / pi) * getintegraloverpanel( ...
                                    panels(iPanel).xC, panels(iPanel).yC, ...
                                    panels(jPanel), ...
                                    cos(deg2rad(panels(iPanel).beta)), ...
                                    sin(deg2rad(panels(iPanel).beta)) );
            end % if
        end % for jPanel
    end % for iPanel
end