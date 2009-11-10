
// AR3D_API.h
// (c) 2009 Spot Metrix
// All Right Reserved.

#pragma once
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>


typedef struct
{
	CGFloat x, y, z;
} Coord3D;

typedef struct
{
	CGFloat yaw, pitch, roll;
} Orientation;


#ifdef __cplusplus
extern "C" {
#endif
	
	
	// Init creates the World coordinate system centered at given earth location,
// with X axis pointing East, Y axis pointing North, and Z axis pointing up.

void        AR3D_InitOrigin (CLLocation *loc) ;

// Transform a location into a point in the World coordinate system.

Coord3D     AR3D_WorldCoordinate (CLLocation * loc) ;

// Camera Matrix is constructed relative to World coordinate system.

void        AR3D_UpdateCamera (CLLocation * loc, Coord3D north, Coord3D down) ;

// Retrieve the camera matrix for use with OpenGL.
 
CATransform3D *    AR3D_CameraMatrix (void) ;

// Transform a Coord from World to Camera coordinates.

Coord3D     AR3D_CameraCoordinate (Coord3D worldPoint) ;

// Project a from Camera coordinates to Screen coordinates.
// distance is given in meters.

void        AR3D_SetProjection (CGRect viewport, float verticalFieldOfView, float nearClip, float farClip) ;
bool		AR3D_Project (Coord3D worldPoint, CGPoint * outPoint) ;
			
Coord3D     AR3D_North (CGFloat metres) ;
Coord3D     AR3D_South (CGFloat metres) ;
Coord3D     AR3D_East (CGFloat metres) ;
Coord3D     AR3D_West (CGFloat metres) ;
Coord3D     AR3D_Up (CGFloat metres) ;
Coord3D     AR3D_Down (CGFloat metres) ;
	
bool		AR3D_ConfidenceTest () ;
	
#ifdef __cplusplus
	}
#endif
		
