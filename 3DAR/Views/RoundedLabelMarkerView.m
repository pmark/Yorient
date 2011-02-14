//
//  RoundedLabelMarkerView.m
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "RoundedLabelMarkerView.h"
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES1/gl.h>

@implementation RoundedLabelMarkerView

@synthesize label;
@synthesize markerTitle;
@synthesize markerSubtitle;

- (void) dealloc
{
    [label release];
    [markerTitle release];
    [markerSubtitle release];
    [super dealloc];
}

- (id) initWithTitle:(NSString *)_title subtitle:(NSString *)_subtitle
{
    if (self = [super initWithFrame:CGRectMake(0, 0, 100, 100)])
    {
        self.markerTitle = _title;
        self.markerSubtitle = _subtitle;
        
        NSString *distance = nil;
        
        if (self.poi)
        {
            distance = [self.poi formattedDistanceInMilesFromCurrentLocation];
        }
        
        NSInteger fontSize = 18;
        self.label = [[[UILabel alloc] init] autorelease];
        label.font = [UIFont boldSystemFontOfSize:fontSize];
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor blackColor];
        label.textAlignment = UITextAlignmentCenter;
        
        CGFloat h;
        
        NSString *line1 = self.markerTitle;
        
        if (!line1)
            line1 = @"";
        
        if (distance && [self.markerSubtitle isEqualToString:@"distance"])
        {
            h = (4*fontSize);
            label.text = [NSString stringWithFormat:@"%@\n%@ mi", line1, distance];
            label.numberOfLines = 2;
        }
        else
        {
            h = (2*fontSize);
            label.text = line1;
            label.numberOfLines = 1;
        }
        
        CGFloat padding = (3*fontSize);
        CGFloat w = ([line1 length] * fontSize) + padding;
        label.frame = self.frame = CGRectMake(0, 0, w, h);
        
        NSLog(@"adding label: %@ (%.0f, %.0f)", label.text, w, h);
        
        [self addSubview:label];
        
        CALayer *l = [self layer];
        [l setMasksToBounds:YES];
        [l setCornerRadius:7.0];
        [l setBorderWidth:2.0];
        [l setBorderColor:[[UIColor whiteColor] CGColor]];
    }
    
    return self;
}

#pragma mark -

- (NSString*) title 
{
    if ([markerTitle length] == 0) 
    {
        if (self.poi)
            return self.poi.title;
    } 
    else 
    {
        return markerTitle;
    }
    
    return nil;
}

- (NSString*) markerSubtitle 
{
    if ([markerSubtitle length] == 0) 
    {
        if (self.poi)
            return self.poi.subtitle;
    } 
    else 
    {
        return markerSubtitle;
    }
    
    return nil;
}

static float rlLineVertex[2][3] =
{
    // x y z 
    { 0, 0, 0 },
    { 0, 0, -500 }
};

static unsigned short rlLineIndex[2] = 
{
    0, 1
};


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
    
    // Line
    
    glLineWidth(2.0);
    glColor4f(0, 0, 1, 0.33);
    glVertexPointer(3, GL_FLOAT, sizeof(float) * 3, rlLineVertex);
    glDrawElements(GL_LINES, 2, GL_UNSIGNED_SHORT, rlLineIndex);
}

- (CGAffineTransform) pointTransform 
{
    return CGAffineTransformIdentity;
}

@end
