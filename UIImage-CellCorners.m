//
//  UIImage-RoundedCorners.m
//  iTouch Typer
//
//  Created by Fabian Kreiser on 22.03.09.
//  Copyright 2009 Fabian Kreiser. All rights reserved.
//

#import "UIImage-CellCorners.h"

static CGFloat _cornerRadius_ = 10;

@implementation UIImage (CellCorners)

+ (CGFloat) roundedCornerRadius {
	return _cornerRadius_;
}

+ (void) setRoundedCornerRadius:(CGFloat)radius {
	_cornerRadius_ = radius;
}

+ (UIImage *) roundedCornersImageNamed:(NSString *)name atPosition:(UITableViewCellPosition)position {
	UIImage *source = [UIImage imageNamed:name];
	
	if (position == UITableViewCellPositionMiddle) // No rounded corners needed
		return source;
	
	CGRect rect = CGRectMake(0, 0, source.size.width, source.size.height);
	CGFloat radius = [UIImage roundedCornerRadius];
	CGFloat factorWidth = rect.size.width / radius;
	CGFloat factorHeight = rect.size.height / radius;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, rect.size.width, rect.size.height, 8, 4 * rect.size.width, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGContextSaveGState(context);
	CGContextScaleCTM (context, radius, radius);
	
	switch (position) {
		case UITableViewCellPositionSingle:
			CGContextMoveToPoint(context, factorWidth, factorHeight/2);  // Start at lower right corner
			CGContextAddArcToPoint(context, factorWidth, factorHeight, factorWidth/2, factorHeight, 1);  // Top right corner
			CGContextAddArcToPoint(context, 0, factorHeight, 0, factorHeight/2, 1); // Top left corner
			CGContextAddArcToPoint(context, 0, 0, factorWidth/2, 0, 1); // Lower left corner
			CGContextAddArcToPoint(context, factorWidth, 0, factorWidth, factorHeight/2, 1); // Back to lower right
			break;
		case UITableViewCellPositionTop:
			CGContextMoveToPoint(context, factorWidth, factorHeight/2);  // Start at lower right corner
			CGContextAddArcToPoint(context, factorWidth, factorHeight, factorWidth/2, factorHeight, 1);  // Top right corner
			CGContextAddArcToPoint(context, 0, factorHeight, 0, factorHeight/2, 1); // Top left corner
			CGContextAddLineToPoint(context, 0, 0); // Lower left corner
			CGContextAddLineToPoint(context, factorWidth, 0); // Back to lower right
			break;
		case  UITableViewCellPositionBottom:
			CGContextMoveToPoint(context, factorWidth, factorHeight/2);  // Start at lower right corner
			CGContextAddLineToPoint(context, factorWidth, factorHeight);  // Top right corner
			CGContextAddLineToPoint(context, 0, factorHeight); // Top left corner
			CGContextAddArcToPoint(context, 0, 0, factorWidth/2, 0, 1); // Lower left corner
			CGContextAddArcToPoint(context, factorWidth, 0, factorWidth, factorHeight/2, 1); // Back to lower right
			break;
		default: // Shouldn't get called
			return source;
	}
	
	CGContextClosePath(context);
	CGContextRestoreGState(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, rect, source.CGImage);
	CGImageRef imageMasked = CGBitmapContextCreateImage(context);
	
	CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
	
	return [UIImage imageWithCGImage:imageMasked];    
}

+ (UIImage *) roundedCornersImageNamed:(NSString *)name {
	return [UIImage roundedCornersImageNamed:name atPosition:UITableViewCellPositionSingle];
}

@end