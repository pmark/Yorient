//
//  SearchResultMarkerView.m
//  SM3DARViewer
//
//  Created by P. Mark Anderson on 12/1/09.
//  Copyright 2009 Bordertown Labs, LLC. All rights reserved.
//

#import "SearchResultMarkerView.h"


@implementation SearchResultMarkerView

- (void)buildView {
	UIImage *img = [UIImage imageNamed:@"bubble.png"];
	self.icon = [[UIImageView alloc] initWithImage:img];

	self.frame = CGRectMake(0, 0, img.size.width, img.size.height);
	//self.backgroundColor = [SM3DARBtlUtilities randomColor];
	
	[self scaleToRange];
	[self addSubview:icon];
}

@end
