//
//  Star3DMarkerView.h
//  SM3DARViewer
//
//  Created by Josh Aller on 1/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "SM3DAR.h"

@interface Star3DMarkerView : SM3DAR_IconMarkerView {
  double zrot;
  UIColor * color;
}

@property (nonatomic) double zrot;
@property (nonatomic, retain) UIColor * color;

- (void) drawInGLContext;

@end
