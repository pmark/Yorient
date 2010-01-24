//
//  Star3DMarkerView.m
//  SM3DARViewer
//
//  Created by Josh Aller 1/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "Star3DMarkerView.h"
#import <OpenGLES/ES1/gl.h>

@implementation Star3DMarkerView

@synthesize zrot, color;


Geometry * geom = nil;
Texture * texture = nil;

char * textureName[] =
{
  "audacity-hdh-week-41.png",	
  "spheremap_norm.png",		
  "world.png",
  "ingiltere-bayragi.png",		
  "timezone.png"
};

int textureCount = sizeof(textureName) / sizeof (char*);
int currentTexture = 0;
int frameCount = 0;

- (void)buildView {
	
  //UIImage *img = [UIImage imageNamed:@"bubble1.png"];
	//self.icon = [[UIImageView alloc] initWithImage:img];
  self.icon = nil;
  self.zrot = 0.0;
  
  switch (rand() % 4)
  {
    case 0:
      self.color = [UIColor blueColor];
      break;
    case 1:
      self.color = [UIColor redColor];
      break;
    case 2:
      self.color = [UIColor greenColor];
      break;
    case 3:
      self.color = [UIColor yellowColor];
      break;
  }
  
	//self.frame = CGRectMake(0, 0, img.size.width, img.size.height);
	self.frame = CGRectMake(0,0,0,0);
  
	//[self scaleToRange];
	//[self addSubview:icon];
    
  if (geom == nil)
  {
    NSString* path = [[NSBundle mainBundle] pathForResource:@"sphere" ofType:@"obj"];
    geom = [Geometry newOBJFromResource:path];
  }
  
  if (texture == nil)
  {
    texture = [Texture newTextureFromResource:@"world.png"];
  }
}

- (void)didReceiveFocus {
}

- (void) drawInGLContext {
  
  extern void drawAxes(), draw3DStar();
  
  // Camera and object positioning transforms are already in the ModelView matrix
  
  if ([self.poi hasFocus])
  {
    self.zrot += 10;
  }
  glRotatef (self.zrot, 0,0,1);
  
  //if (self.poi.hasFocus)
  //  glScalef(2,2,2);
  glScalef (100,100,100);
  
  bool flipThruImages = true;
  
  if (flipThruImages)
  {
    // try replacing texture
    if (frameCount++ % 100 == 0)
      [texture replaceTextureFromResource:[NSString stringWithCString:textureName[currentTexture++ % textureCount]]];
  }
  
  //drawAxes();
  //draw3DStar(self.color);
  //[geom displayShaded];
  [geom displayFilledWithTexture:texture];
}

@end
