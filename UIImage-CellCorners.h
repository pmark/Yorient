//
//  UIImage-RoundedCorners.h
//  iTouch Typer
//
//  Created by Fabian Kreiser on 22.03.09.
//  Copyright 2009 Fabian Kreiser. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum UITableViewCellPosition {
	UITableViewCellPositionSingle,
	UITableViewCellPositionTop,
	UITableViewCellPositionMiddle,
	UITableViewCellPositionBottom,
} UITableViewCellPosition;

@interface UIImage (CellCorners)

+ (CGFloat) roundedCornerRadius;
+ (void) setRoundedCornerRadius:(CGFloat)radius;
+ (UIImage *) roundedCornersImageNamed:(NSString *)name atPosition:(UITableViewCellPosition)position;
+ (UIImage *) roundedCornersImageNamed:(NSString *)name;

@end
