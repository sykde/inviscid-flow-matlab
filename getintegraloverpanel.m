function integralValue = getintegraloverpanel(x, y, panel, dxdz, dydz)
    %GETINTEGRALOVERPANEL Evaluates the contribution to the flow of a panel
    % at the target point.
    %
    %   Arguments
    %   ----------
    %   x: Float
    %       x-coordinate of the target point.
    %   y: Float
    %       y-coordinate of the target point.
    %   dxdz: Float
    %       Derivative of `x` on the z axis.
    %   dydz: Float
    %       Derivative of `y` on the z axis.
    %
    %   Returns
    %   -------
    %   integralValue: Float
    %       Contribution to flow of a panel at the target point.

    arguments
        x {mustBeFloat}
        y {mustBeFloat}
        panel {mustBeNonempty}
        dxdz {mustBeFloat}
        dydz {mustBeFloat}
    end

    betaInRads = deg2rad(panel.beta);
    
    integrand = @(s) (((x - (panel.xA - sin(betaInRads) .* s)) .* dxdz + ...
                       (y - (panel.yA + cos(betaInRads) .* s)) .* dydz) ./ ...
                      ((x - (panel.xA - sin(betaInRads) .* s)).^2 + ...
                       (y - (panel.yA + cos(betaInRads) .* s)).^2) );
   
    integralValue = integral(integrand, 0.0, panel.length);
end

