//
//  Created by P. Mark Anderson on 12/1/09.
//  Copyright 2009 Spot Metrix, Inc. All rights reserved.
//

#import "BubbleMarkerView.h"
#import <OpenGLES/ES1/gl.h>

#define MIN_SIZE_SCALAR 0.08
#define SCALE_REDUCTION 0.3
#define BMV_SHADOW_VERTEX_COUNT 30


@implementation BubbleMarkerView

static float bmvShadowVerts[BMV_SHADOW_VERTEX_COUNT][3];
static unsigned short bmvShadowIndexes[BMV_SHADOW_VERTEX_COUNT];

static float bmvLineVertex[2][3] =
{
    // x y z 
    { 0, 0, 0 },
    { 0, 0, -500 }
};

static unsigned short bmvLineIndex[2] = 
{
    0, 1
};

- (void) buildView {
	UIImage *img = [UIImage imageNamed:@"bubble1.png"];
	self.icon = [[UIImageView alloc] initWithImage:img];
    
	self.frame = CGRectMake(0, 0, img.size.width, img.size.height);
	
	[self addSubview:self.icon];
    
    // Shadow    
    
    CGFloat radius = 100;
	
	for (int i=0; i < BMV_SHADOW_VERTEX_COUNT; i++)
	{
		float theta = 2 * 3.1415927 * i / BMV_SHADOW_VERTEX_COUNT;
		
		bmvShadowVerts[i][0] = radius * cos(theta);
		bmvShadowVerts[i][1] = radius * sin(theta);
		bmvShadowVerts[i][2] = -500.0;
		
		bmvShadowIndexes[i] = i;
	}
}

- (void) didReceiveFocus {
}

- (void) didLoseFocus {
}

- (CGFloat)rangeScalar {
    
    if (!self.poi)
        return 1.0;
    
    CGFloat scalar;
	CGFloat poiDistance = [self.poi distanceInMetersFromCurrentLocation];
    
    SM3DAR_Controller *sm3dar = [SM3DAR_Controller sharedController];
	CGFloat minRange = sm3dar.nearClipMeters;
	CGFloat maxRange = sm3dar.farClipMeters;
    
	if (poiDistance > maxRange || poiDistance < minRange) {
		scalar = 0.001;
        
	} else {
		CGFloat scaleFactor = 1.0;
		CGFloat rangeU = (poiDistance - minRange) / (maxRange - minRange);
        
        scalar = 1.0 - (scaleFactor * rangeU);
        
        scalar *= SCALE_REDUCTION; // because I think they look better smaller
        
        if (scalar < MIN_SIZE_SCALAR)
            scalar = MIN_SIZE_SCALAR;
	}	
    
    return scalar;
}

#pragma mark -
- (void) drawInGLContext 
{
    glScalef (-1, 1, 1);
  	glRotatef(180.0, 0, 0, 1);
    
    glDepthMask(0);
    
    glDisable(GL_LIGHTING);
    glDisable(GL_BLEND);
    glEnable(GL_DEPTH_TEST);
    glDisable(GL_CULL_FACE);
    glDisable(GL_TEXTURE_2D);
    
    glEnableClientState(GL_VERTEX_ARRAY);
    glDisableClientState(GL_NORMAL_ARRAY);
    glDisableClientState(GL_TEXTURE_COORD_ARRAY);
    
    // Shadow
    
    glLineWidth(1.0);
    glColor4f(.1, .1, .1, 0.8);
	glVertexPointer(3, GL_FLOAT, 0, bmvShadowVerts);
	glDrawElements(GL_TRIANGLE_FAN, BMV_SHADOW_VERTEX_COUNT, GL_UNSIGNED_SHORT, bmvShadowIndexes);
    
    
    // Line
    
    glLineWidth(2.0);
    glColor4f(.3, .3, .3, 0.8);
    glVertexPointer(3, GL_FLOAT, sizeof(float) * 3, bmvLineVertex);
    glDrawElements(GL_LINES, 2, GL_UNSIGNED_SHORT, bmvLineIndex);
}

@end
