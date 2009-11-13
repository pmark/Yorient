//
//  BtlUtilities.h
//  Bubble
//
//  Created by P. Mark Anderson on 7/20/09.
//  Copyright 2009 Bordertown Labs. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SM3DARBtlUtilities : NSObject {
}

+(void)seedRandomNumberGenerator;
+(int)randomNumber:(int)max;
+(int)randomNumberInRange:(int)min maximum:(int)max;
+(int)randomPolarity;
+(UIColor*)randomVgaColor;
+(UIColor*)randomColor;
+(CGPoint)randomPointBetween:(NSInteger)x y:(NSInteger)y;
+(CGPoint)randomPoint;
+(BOOL)randomChanceOutOf:(int)max;

@end

#define VGA_COLORS [NSArray arrayWithObjects:[UIColor darkGrayColor],[UIColor whiteColor],[UIColor redColor],[UIColor blueColor],[UIColor cyanColor],[UIColor magentaColor],[UIColor orangeColor],[UIColor purpleColor],nil]
#define DEGREES_TO_RADIANS(__ANGLE__) ((__ANGLE__) / 180.0 * M_PI)
