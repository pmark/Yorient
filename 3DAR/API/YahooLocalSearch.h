//
//  YahooLocalSearch.h
//
//  Created by P. Mark Anderson on 12/18/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDelegate
- (void) searchDidFinishWithResults;
- (void) searchDidFinishWithEmptyResults;
@end


@interface YahooLocalSearch : NSObject {
	NSMutableData *webData;
    NSString *query;
    id<SearchDelegate> delegate;
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *query;
@property (nonatomic, assign) id<SearchDelegate> delegate;

- (void)execute:(NSString*)searchQuery;

@end
