
//
// Stdmath.h
// Copyright 1997 Josh Aller
// All Rights Reserved
// 

#ifndef __STDMATH_INCLUDE__
#define __STDMATH_INCLUDE__

#include <math.h>


#define SQR(A)				((A)*(A))

#ifndef ABS
	#define ABS(A)          ((A) > 0 ? (A) : -(A))
#endif
#ifndef MIN
	#define MIN(A,B)        ((A) > (B) ? (B) : (A))
#endif

#ifndef MAX
	#define MAX(A,B)		((A) > (B) ? (A) : (B))
#endif

#define DEG2RAD(A)			((A) * 0.01745329278)
#define RAD2DEG(A)			((A) * 57.2957786667)

#define PI		3.1415927

#define Float		double
#define FABS(A)		fabs(A) 

#endif

