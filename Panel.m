classdef Panel
    %PANEL: Describes a linear source of flow
    %   Parameters
    %   ----------
    %   xA: Float
    %       x-coordinate of the panel's first point.
    %   yA: Float
    %       y-coordinate of the panel's first point.
    %   xB: Float
    %       x-coordinate of the panel's second point.
    %   yB: Float
    %       y-coordinate of the panel's second point.
    %   xC: Float
    %       x-coordinate of the panel's midpoint.
    %   yC: Float
    %       y-coordinate of the panel's midpoint.
    %   length: Float
    %       Total length of the panel.
    %   beta: Float
    %       Angle of the panel in degrees, measured from the horizontal
    %       axis.
    %   location: String
    %       Location of the panel. (Upper or Lower).
    %   gamma: Float
    %       Vortex strength.
    %   sigma: Float
    %       Source strength.
    %   vt: Float
    %       Tangential velocity of flow.
    %   cp: Float
    %       Coefficient of pressure.
    
    properties
        xA          
        yA          
        xB          
        yB          
        xC          
        yC          
        length      
        beta        
        location    
        gamma       
        sigma       
        vt          
        cp          
    end
    
    methods
        function obj = Panel(xA, yA, xB, yB)
            %PANEL Construct an instance of Panel
            %
            %   Arguments
            %   ----------
            %   xA: Float
            %       x-coordinate of the panel's first point.
            %   yA: Float
            %       y-coordinate of the panel's first point.
            %   xB: Float
            %       x-coordinate of the panel's second point.
            %   yB: Float
            %       y-coordinate of the panel's second point.
            %
            %   Returns
            %   -------
            %   obj: Panel object
            %       An object of type Panel.

            arguments
                xA {mustBeFloat}
                yA {mustBeFloat}
                xB {mustBeFloat}
                yB {mustBeFloat}
            end
            
            obj.xA = xA;
            obj.yA = yA;
            obj.xB = xB;
            obj.yB = yB;

            obj.xC = (xA + xB)/2;
            obj.yC = (yA + yB)/2;

            obj.length = sqrt((xB - xA)^2 + (yB - yA)^2);

            % Orientation of panel (angle between x-axis and panel's normal)
            if (obj.xB - obj.xA <= 0.0)
                beta = acos((obj.yB - obj.yA) / obj.length);
            elseif (obj.xB - obj.xA > 0.0)
                beta = pi + acos(-(obj.yB - obj.yA) / obj.length);
            end
            obj.beta = rad2deg(beta);

            % Location of panel
            if beta <= pi
                obj.location = "Upper";
            else
                obj.location = "Lower";
            end

            obj.gamma = 0.0;
            obj.sigma = 0.0;
            obj.vt = 0.0;
            obj.cp = 0.0;
        end % function

    end % methods
end

