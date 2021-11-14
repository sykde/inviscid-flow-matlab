% ------------------------------------------------------------------------
% FILENAME: main.m
% DEPENDENCIES: createsingularitymatrix.m
%               FreeStream.m
%               getairfoilgeometry.m
%               getintegraloverpanel.m
%               invokepanels.m
%               Panel.m
%               setfreestreamconditions.m
%               setkuttacondition.m
%               setpressurecoefficient.m
%               setsourcecontribution.m
%               settangentialvelocity.m
%               setvortexcontribution.m
% AUTHOR: desyk
% DATE: 20211101
% ------------------------------------------------------------------------
% MAIN Calculates the flow of an inviscous, incompressible fluid around an
% object defined by a list of points. 

clear A accuracy AoA b c cdcp cL clcp coords formatSpec freeStream ...
      iPanel listOfUpperPanelxCCoords listOfUpperPanelcpValues ...
      listOfLowerPanelxCCoords listOfLowerPanelcpValues M N panels ...
      sourceMatrix strengthsArray Uinf vortexMatrix xAirfoil yC ...
      yCoordsOfPanels;
close all;

%[coords] = getairfoilgeometry('n2412.dat'); [xAirfoil] = coords(1,:); [yAirfoil] = coords(2,:);

% For NACA 4-digit airfoils: (NACA MPXX)
% [xCoords, yCoords] = createairfoilgeometry(M,P,XX,chord length,# of panels per side)
[xAirfoil, yAirfoil] = createairfoilgeometry(3,3,13,1,50);

[panels] = invokepanels(xAirfoil, yAirfoil);

Uinf = 1.0; AoA = 0.0; % AoA = angle of attack in degrees
freeStream = FreeStream(Uinf, AoA);

figure(1)
nexttile
hold on; axis equal; grid on;
plot(xAirfoil, yAirfoil, Color=[0, 0, 0], LineStyle="-", LineWidth=2)

[xCoordsOfPanels] = zeros(size(panels));
[yCoordsOfPanels] = zeros(size(panels));
[xC] = zeros(size(panels)); % x-coordinates of the centers of the panels
[yC] = zeros(size(panels)); % y-coodrinates ...
[M] = zeros([length(panels), 2]);

for iPanel = 1:length(panels)
    xCoordsOfPanels(iPanel) = panels(iPanel).xA;
    yCoordsOfPanels(iPanel) = panels(iPanel).yA;
    xC(iPanel) = panels(iPanel).xC;
    yC(iPanel) = panels(iPanel).yC;
    M(iPanel,1) = cos(deg2rad(panels(iPanel).beta));
    M(iPanel,2) = sin(deg2rad(panels(iPanel).beta));
end
xCoordsOfPanels(end+1) = panels(end).xB;
yCoordsOfPanels(end+1) = panels(end).yB;

plot(xCoordsOfPanels, yCoordsOfPanels, Color='red', LineStyle=':', LineWidth=1)
plot(xC, yC, LineStyle='none', Marker='o', MarkerSize=4, Color='blue')
quiver(xC, yC, M(:,1)', M(:,2)')
title('Airfoil with visible panels')

xlim([-0.1, 1.1])
ylim([-0.3, 0.3])

% sourceMatrix is the source contribution matrix for the normal velocity
[sourceMatrix] = setsourcecontribution(panels);
[vortexMatrix] = setvortexcontribution(panels);

% A is the array with the contribution of the source, vortex and the Kutta
% condition. By solving the system A * X = b, where b is the array with the
% freestream contribution, the strength of the sources (panels) and the
% strength of the vortex will be known.
[A] = createsingularitymatrix(sourceMatrix, vortexMatrix);
[b] = setfreestreamconditions(panels, freeStream);

% Let X be strengthsArray
[strengthsArray] = A\b;

for iPanel = 1:(length(strengthsArray)-1)
    panels(iPanel).sigma = strengthsArray(iPanel);
    panels(iPanel).gamma = strengthsArray(end);
end

[panels] = settangentialvelocity(panels, freeStream, sourceMatrix, vortexMatrix);
[panels] = setpressurecoefficient(panels, freeStream);

nexttile
hold on; grid on;
xlim([0, 1])
ylim([-4.0, 1.2]); axis ij; %reverse Y-axis direction
xlabel("X",FontSize=16)
ylabel("C_p", FontSize=16)
title("C_p / xC graph")

listOfUpperPanelxCCoords = []; listOfUpperPanelcpValues = [];
listOfLowerPanelxCCoords = []; listOfLowerPanelcpValues = [];

for iPanel = 1:length(panels)
    if panels(iPanel).location == "Upper"
        listOfUpperPanelxCCoords = [listOfUpperPanelxCCoords, panels(iPanel).xC]; %#ok<AGROW>
        listOfUpperPanelcpValues = [listOfUpperPanelcpValues, panels(iPanel).cp]; %#ok<AGROW> 
    elseif panels(iPanel).location == "Lower"
        listOfLowerPanelxCCoords = [listOfLowerPanelxCCoords, panels(iPanel).xC]; %#ok<AGROW>
        listOfLowerPanelcpValues = [listOfLowerPanelcpValues, panels(iPanel).cp]; %#ok<AGROW>
    end
end

plot(listOfUpperPanelxCCoords, listOfUpperPanelcpValues, ...
     color='r', LineStyle='-', LineWidth=2, Marker='o', MarkerSize=1)

plot(listOfLowerPanelxCCoords, listOfLowerPanelcpValues, ...
    color='b', LineStyle='-', LineWidth=2, Marker='o', MarkerSize=1)
title('C_p(x) diagram')

% Calculate the chord
c = abs(max(xCoordsOfPanels) - min(xCoordsOfPanels));

% Calculate the accuracy and lift coefficient
accuracy = 0; cL = 0;
for iPanel = 1:length(panels)
    accuracy = accuracy + (panels(iPanel).sigma * panels(iPanel).length);
    cL = cL + (panels(1).gamma * (panels(iPanel).length) / ...
               0.5 * freeStream.Uinf * c );
end
formatSpec = 'Sum of singularity lengths: %f\n';
fprintf(formatSpec, accuracy)
formatSpec = 'Lift Coefficient (C_L): %f\n';
fprintf(formatSpec,cL)

clcp = 0; cdcp = 0;
for iPanel = 1:length(panels)
    clcp = clcp + (-1) * panels(iPanel).cp * sin(deg2rad(panels(iPanel).beta)) * panels(iPanel).length;
    cdcp = cdcp + (-1) * panels(iPanel).cp * cos(deg2rad(panels(iPanel).beta)) * panels(iPanel).length;
end
formatSpec = 'CLcp = %f, CDcp = %f\n';
fprintf(formatSpec,clcp, cdcp)

xGridRange = linspace(-0.5,1.5,50);
yGridRange = linspace(-0.5,0.5,50);
[xGrid, yGrid] = meshgrid(xGridRange, yGridRange);

[uu, vv] = getvelocityfield(panels, freeStream, xGrid, yGrid);
fluidVelocityMagnitude = sqrt(uu.^2 + vv.^2);

nexttile
hold on; grid on;
xlim([-0.5, 1.5])
ylim([-0.5, 0.5])
[MM1, c1] = contour(xGrid, yGrid, fluidVelocityMagnitude, 20);
c1.LineWidth = 2;
fill(xAirfoil, yAirfoil, [0, 0, 0])
title("Contour of fluid velocity")

cp = 1.0 - (uu.^2 + vv.^2) ./ freeStream.Uinf^2;

nexttile
hold on; grid on;
xlim([-0.5, 1.5])
ylim([-0.5, 0.5])
[MM2, c2] = contour(xGrid, yGrid, cp, 20);
c2.LineWidth = 2;
fill(xAirfoil, yAirfoil, [0, 0, 0])
title("Contour of fluid pressure")