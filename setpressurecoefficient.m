function [panels] = setpressurecoefficient(panels,freeStream)
    %SETPRESSURECOEFFICIENT Computes the surface pressure coefficients.
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
    %   panels: 1D array of Panel objects
    %       Inserts the pressure coefficient property in every panel from
    %       input.

    arguments
        panels {mustBeNonempty}
        freeStream {mustBeNonempty}
    end

    for iPanel = 1:length(panels)
        panels(iPanel).cp = 1.0 - (panels(iPanel).vt / freeStream.Uinf)^2;
    end
end