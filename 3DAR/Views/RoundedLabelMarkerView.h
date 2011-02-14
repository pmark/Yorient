//
//  RoundedLabelMarkerView.h
//
//  Created by P. Mark Anderson on 2/21/10.
//  Copyright 2010 Spot Metrix, Inc. All rights reserved.
//

#import "SM3DAR.h"


@interface RoundedLabelMarkerView : SM3DAR_MarkerView {
	UILabel *label;
    NSString *markerTitle;
    NSString *markerSubtitle;
}

- (id) initWithTitle:(NSString *)title subtitle:(NSString *)subtitle;

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NSString *markerTitle;
@property (nonatomic, retain) NSString *markerSubtitle;

@end
