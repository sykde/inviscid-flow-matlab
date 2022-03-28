# inviscid-flow-matlab
MATLAB code to calculate inviscid flow around an object.

## Implementation


### main.m
The main program. Calculates the airflow around an object. By default the object is a NACA 4-digit airflow, but by editing the source code to use the getairfoilgeometry.m function instead of createairfoilgeometry.m, the user can import any geometry from a list of points in a properly formatted file, like the ones contained in the git repository (n2412.dat, n0012.dat).
    
### getairfoilgeometry.m
Reads a list of points from a file and assigns them to a variable. The variable contains an array of size [2, N], where N is the count of points in the file. By default this function is unused. However, should the user desire to calculate the airflow around an object other than a NACA 4-digit airfoil, they should use this function instead of the default one.

### createairfoilgeometry.m
Returns 2 vectors with the coordinates of the desired amount of points that comprise the boundary of a NACA 4-digit airfoil. The coordinates of the points on the X-axis follow a cosine spacing for better accuracy of the calculations near the leading and trailing edges of the airfoil. By default the NACA 3313 airfoil is created. Users may change the input arguments of this function at will.

    Usage: To create a NACA 2412 airfoil with a chord length of 1 which is described by 50 points on each side, 
    the command should be used as following:

    [x,y] = createairfoilgeometry(2,4,12,1,50)

    And the general syntax is:

    [x,y] = createairfoilgeometry(M, P, XX, chord length, # of points per side)
    
### invokepanels.m
Returns a vector that contains objects of class Panel. These panels are created between each point of the airfoil, so the user should be aware that the program will be more computationally-intensive when the points that describe the geometry are dense.

### Panel.m
Contains the class definition of a source-type singularity that is linearly distributed between 2 points (a Panel) and its constructor (Panel()).

### FreeStream.m
Contains the class definition of the free stream, its constructor (streamfunction()) and various functions that interact with some of the FreeStream class' properties (setscalarpotential(), getstreamfunction(), getscalarpotential()). Note that not all of those functions are necessary for the main programme.

### setsourcecontribution.m
Returns a square matrix that contains the contribution of every source to the flow

### setvortexcontribution.m
Returns a square matrix that contains the contribution of the vortex to the flow

### getintegraloverpanel.m
Returns a Float which describes the contribution of the panel's source to the overall flow.

### createsingularitymatrix.m
Returns the left-hand-side matrix of the system arising from source and vortex contributions (the A in A*X = b, where X is a vector that contains the intensity of the source in every panel and the intensity of the vortex).

### setkuttacondition.m
Returns a vector that contains the Kutta condition of the flow, which will be integrated in the "Singularity matrix" described above.

### setfreestreamconditions.m
Returns the right-hand-side matrix of the system arising from the free stream condition (the b in A*X = b, where X is a vector that contains the intensity of the source in every panel and the intensity of the vortex).
    
### settangentialvelocity.m
Sets the vt property (tangential velocity on the boundary) of an object of class Panel, because at the time of construction of this object its value is unknown.

### setpressurecoefficient.m
Sets the cp property (pressure coefficient on the boundary) of an object of class Panel, because at the time of construction of this object its value is unknown.

### getvelocityfield.m
Computes the velocity field of the area (expressed as a grid of points) that surrounds the object.
