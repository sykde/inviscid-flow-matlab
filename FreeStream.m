classdef FreeStream
    %FREESTREAM Freestream conditions
    %   Parameters
    %   ----------
    %   Uinf: Float
    %       Free stream velocity
    %   alpha: Float
    %       Angle of attack in degrees
    %   u: Float
    %       Free stream velocity X component
    %   v: Float
    %       Free stream velocity Y component
    %   psi: Float
    %       Stream function
    %   phi: Float
    %       Scalar potential

    properties
        Uinf
        alpha
        u
        v
        psi
        phi
    end
    
    methods
        function obj = FreeStream(Uinf, alpha)
            %FREESTREAM Construct an instance of FreeStream
            %
            %   Arguments
            %   ----------
            %   Uinf: Float
            %         Velocity of free stream.
            %   alpha: Float
            %          Angle of attack in degrees.
            %
            %   Returns
            %   -------
            %   obj: FreeStream object
            %       Object of type FreeStream.

            arguments
                Uinf {mustBeFloat, mustBeNonzero}
                alpha {mustBeFloat}
            end
            
            obj.Uinf = Uinf;
            obj.alpha = alpha;

            obj.u = Uinf * cos(deg2rad(obj.alpha));
            obj.v = Uinf * sin(deg2rad(obj.alpha));
        end
        
        function obj = setstreamfunction(obj, X, Y)
            %SETSTREAMFUNCTION Computes the stream function generated from 
            % freestream.
            %
            %   Arguments
            %   ----------
            %   obj: FreeStream object
            %        A free stream object.
            %   X: 2D Array of floats
            %       x-coordinate of the mesh points.
            %   Y: 2D Array of floats
            %       y-coordinate of the mesh points.
            %
            %   Returns
            %   -------
            %   obj.psi: 2D Array of floats
            %       Stream function.

            arguments
                obj {mustBeNonempty}
                X {mustBeFloat}
                Y {mustBeFloat}
            end

            obj.psi = obj.Uinf * ( (-1) * sin(deg2rad(obj.alpha)) * X + cos(deg2rad(obj.alpha)) * Y);
        end
        
        function obj = setscalarpotential(obj, X, Y)
            %SETSCALARPOTENTIAL Computes the scalar potential generated from 
            % freestream.
            %
            %   Arguments
            %   ----------
            %   obj: FreeStream object
            %       A free stream object.
            %   X: 2D Array of floats
            %       x-coordinate of the mesh points.
            %   Y: 2D Array of floats
            %       y-coordinate of the mesh points.
            %
            %   Returns
            %   -------
            %   obj.phi: 2D Array of floats
            %       Scalar potential.

            arguments
                obj {mustBeNonempty}
                X {mustBeFloat}
                Y {mustBeFloat}
            end

            obj.phi = obj.Uinf * (cos(deg2rad(obj.alpha)) * X + sin(deg2rad(obj.alpha)) * Y);
        end

        function [streamFunction] = getstreamfunction(obj, X, Y)
            %GETSTREAMFUNCTION Gets the stream function without changing 
            % the input object.
            %
            %   Arguments
            %   ----------
            %   obj: FreeStream object
            %       A free stream object.
            %   X: 2D Array of floats
            %       x-coordinate of the mesh points.
            %   Y: 2D Array of floats
            %       y-coordinate of the mesh points.
            %
            %   Returns
            %   -------
            %   streamFunction: 2D Array of floats
            %       Stream function.

            arguments
                obj {mustBeNonempty}
                X {mustBeFloat}
                Y {mustBeFloat}
            end

            streamFunction = obj.Uinf * ( (-1) * sin(deg2rad(obj.alpha)) * X + cos(deg2rad(obj.alpha)) * Y);
        end

        function [scalarPotential] = getscalarpotential(obj, X, Y)
            %GETSCALARPOTENTIAL Gets the scalar potential without changing 
            % the input object.
            %
            %   Arguments
            %   ----------
            %   obj: FreeStream object
            %       A free stream object.
            %   X: 2D Array of floats
            %       x-coordinate of the mesh points.
            %   Y: 2D Array of floats
            %       y-coordinate of the mesh points.
            %
            %   Returns
            %   -------
            %   scalarPotential: type = 2D Array of floats
            %       Scalar potential.

            arguments
                obj {mustBeNonempty}
                X {mustBeFloat}
                Y {mustBeFloat}
            end

            scalarPotential = obj.Uinf * (cos(deg2rad(obj.alpha)) * X + sin(deg2rad(obj.alpha)) * Y);
        end

    end
end