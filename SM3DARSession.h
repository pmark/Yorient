//
//  SM3DARSession.h
//  SM3DARLibary
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface SM3DARSession : NSObject {
	CLLocation *currentLocation;
	CGFloat nearClipMeters;
	CGFloat farClipMeters;
}

@property (nonatomic, retain) CLLocation *currentLocation;
@property (nonatomic, assign) CGFloat nearClipMeters;
@property (nonatomic, assign) CGFloat farClipMeters;

+ (SM3DARSession*)sharedSM3DARSession;

@end
