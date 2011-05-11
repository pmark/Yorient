//
//  YahooLocalSearch.h
//
//  Created by P. Mark Anderson on 12/18/09.
//  Copyright 2009 Spot Metrix. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol SearchDelegate
- (void) searchDidFinishWithResults:(NSArray*)results;
- (void) searchDidFinishWithEmptyResults;
@end


@interface YahooLocalSearch : NSObject {
	NSMutableData *webData;
    NSString *query;
    id<SearchDelegate> delegate;
    CLLocation *location;
}

@property (nonatomic, retain) NSMutableData *webData;
@property (nonatomic, retain) NSString *query;
@property (nonatomic, assign) id<SearchDelegate> delegate;
@property (nonatomic, retain) CLLocation *location;

- (id) initAtLocation:(CLLocation *)searchLocation;
- (void) execute:(NSString*)searchQuery;
- (NSArray*) parseYahooMapSearchResults:(NSString*)json;

@end
