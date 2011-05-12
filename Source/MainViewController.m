//
//  MainViewController.m
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "NSArray+BSJSONAdditions.h"
//#import "RoundedLabelMarkerView.h"
#import "Constants.h"

#define SG_CONSUMER_KEY @"cxu7vcXRsfSaBZGm4EZffVGRq662YCNJ"
#define SG_CONSUMER_SECRET @"fTGANz54NXzMVQ6gwgnJcKEua4m2MLSs"


@implementation MainViewController

@synthesize searchQuery;
@synthesize search;
@synthesize mapView;
@synthesize simplegeo;

- (void)dealloc 
{
	[searchQuery release];
    [search release];
    
    [mapView release];
    mapView = nil;
    
    [hudView release];
    hudView = nil;
    
    [spinner release];
    spinner = nil;
    
    [simplegeo release];
    
	[super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil 
{
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) 
    {      
        self.simplegeo = [SimpleGeo clientWithDelegate:self
                                    consumerKey:SG_CONSUMER_KEY
                                 consumerSecret:SG_CONSUMER_SECRET];
        
        [simplegeo setDelegate:self];
    }
    
    return self;
}

- (void) viewDidAppear:(BOOL)animated 
{
	[super viewDidAppear:animated];
    
    [mapView startCamera];
}

- (void) viewDidLoad 
{
	[super viewDidLoad];
    
    [self initSound];
    self.view.backgroundColor = [UIColor blackColor];
    
    mapView.sm3dar.hudView = hudView;
    

    // Search screen
    
    self.search = [[[YahooLocalSearch alloc] init] autorelease];
    search.delegate = self;
    
}

- (void)runLocalSearch:(NSString*)query 
{
    [spinner startAnimating];

    [mapView removeAnnotations:mapView.annotations];
    //[mapView addBackground];
    
	self.searchQuery = query;
    search.location = mapView.sm3dar.userLocation;
    [search execute:searchQuery];    
}

- (void)didReceiveMemoryWarning 
{
    NSLog(@"\n\ndidReceiveMemoryWarning\n\n");
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload 
{
    NSLog(@"viewDidUnload");
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark Data loading

- (void) sm3darLoadPoints:(SM3DAR_Controller *)sm3dar
{
    // 3DAR initialization is complete
    
//    [self addDirectionBillboardsWithFixtures];    
    
//    [self runLocalSearch:@"bar"];

    [self fetchSimpleGeoPlaces];
    
}

- (void) sm3dar:(SM3DAR_Controller *)sm3dar didChangeFocusToPOI:(SM3DAR_Point *)newPOI fromPOI:(SM3DAR_Point *)oldPOI
{
	[self playFocusSound];
}

- (void) sm3dar:(SM3DAR_Controller *)sm3dar didChangeSelectionToPOI:(SM3DAR_Point *)newPOI fromPOI:(SM3DAR_Point *)oldPOI
{
	//NSLog(@"POI was selected: %@", [newPOI title]);
}

#pragma mark Sound
- (void) initSound 
{
	CFBundleRef mainBundle = CFBundleGetMainBundle();
	CFURLRef soundFileURLRef = CFBundleCopyResourceURL(mainBundle, CFSTR ("focus2"), CFSTR ("aif"), NULL) ;
	AudioServicesCreateSystemSoundID(soundFileURLRef, &focusSound);
}

- (void) playFocusSound 
{
	AudioServicesPlaySystemSound(focusSound);
} 

#pragma mark -

- (void) locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation 
{
}

#pragma mark -

/*
- (SM3DAR_Fixture*) addFixtureWithView:(SM3DAR_PointView*)pointView
{
    SM3DAR_Fixture *point = [[SM3DAR_Fixture alloc] init];
    
    point.view = pointView;  
    
    pointView.point = point;
    
    return [point autorelease];
}

- (SM3DAR_Fixture*) addLabelFixture:(NSString*)title subtitle:(NSString*)subtitle coord:(Coord3D)coord
{
    RoundedLabelMarkerView *v = [[RoundedLabelMarkerView alloc] initWithTitle:title subtitle:subtitle];

    SM3DAR_Fixture *fixture = [self addFixtureWithView:v];
    [v release];    
    
    fixture.worldPoint = coord;
    
    [SM3DAR addPoint:fixture];

    return fixture;
}

- (void) addDirectionBillboardsWithFixtures
{
    Coord3D origin = {
        0, 0, DIRECTION_BILLBOARD_ALTITUDE_METERS
    };    
    
    Coord3D north, south, east, west;
    
    north = south = east = west = origin;
    
    CGFloat range = 5000.0;    
    
    north.y += range;
    south.y -= range;
    east.x += range;
    west.x -= range;
    
    [self addLabelFixture:@"N" subtitle:@"" coord:north];
    [self addLabelFixture:@"S" subtitle:@"" coord:south];
    [self addLabelFixture:@"E" subtitle:@"" coord:east];
    [self addLabelFixture:@"W" subtitle:@"" coord:west];
}
*/

- (void) searchDidFinishWithEmptyResults
{
    [spinner stopAnimating];
}

- (void) searchDidFinishWithResults:(NSArray*)results;
{    
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:[results count]];
    
    for (NSDictionary *data in results)
    {
		SM3DAR_PointOfInterest *poi = [[SM3DAR_PointOfInterest alloc] initWithLocation:[data objectForKey:@"location"]
                                                                                 title:[data objectForKey:@"title"] 
                                                                              subtitle:[data objectForKey:@"subtitle"] 
                                                                                   url:nil];
        
        //[mapView addAnnotation:poi];
        [points addObject:poi];
        [poi release];
    }
    
    [mapView addAnnotations:points];
    [spinner stopAnimating];

//    [mapView performSelectorOnMainThread:@selector(zoomMapToFit) withObject:nil waitUntilDone:YES];
//    [mapView addBackground];
    [mapView zoomMapToFit];
}

- (void) sm3darDidShowMap:(SM3DAR_Controller *)sm3dar
{
    hudView.hidden = YES;
}

- (void) sm3darDidHideMap:(SM3DAR_Controller *)sm3dar
{
    hudView.hidden = NO;
}

#pragma mark SimpleGeoDelegate methods

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"SimpleGeo Request failed: %@: %i", [request responseStatusMessage], [request responseStatusCode]);
}

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    NSLog(@"SimpleGeo Request finished: %@", [request responseString]);
}

- (void) fetchSimpleGeoPlaces
{
    SGPoint *here = [SGPoint pointWithLatitude:mapView.sm3dar.userLocation.coordinate.latitude
                                     longitude:mapView.sm3dar.userLocation.coordinate.longitude];
    
    [simplegeo getPlacesNear:here 
                    matching:nil 
                  inCategory:@"Bars & Pubs" 
                      within:15.0 
                       count:220];
}

- (void)didLoadPlaces:(SGFeatureCollection *)places
             forQuery:(NSDictionary *)query
{
    
    NSMutableArray *annotations = [NSMutableArray arrayWithCapacity:[places count]];
    
    for (SGFeature *place in [places features]) 
    {
        SGPoint *point = (SGPoint *)[place geometry];
        NSString *name = [[place properties] objectForKey:@"name"];
        NSString *category = @"";
        
        if ([[[place properties] objectForKey:@"classifiers"] count] > 0) 
        {
            NSDictionary *classifiers = [[[place properties] objectForKey:@"classifiers"] objectAtIndex:0];
            
            category = [classifiers objectForKey:@"category"];
            
            //NSLog(@"place cat: %@", category);
            
            NSString *subcategory = (NSString *)[classifiers objectForKey:@"subcategory"];
            if (subcategory && ! ([subcategory isEqual:@""] ||
                                  [subcategory isEqual:[NSNull null]])) {
                category = [NSString stringWithFormat:@"%@ : %@", category, subcategory];
            }
        }
        
        MKPointAnnotation *annotation = [[[MKPointAnnotation alloc] init] autorelease];
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = point.latitude;
        coordinate.longitude = point.longitude;
        
        annotation.coordinate = coordinate;
        annotation.title = name;
        annotation.subtitle = category;
        
        [annotations addObject:annotation];
    }
    
    [self.mapView addAnnotations:annotations];

    [mapView zoomMapToFit];
    [spinner stopAnimating];
}

#pragma mark -


@end
