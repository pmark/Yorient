//
//  MainViewController.m
//  Yorient
//
//  Created by P. Mark Anderson on 11/10/09.
//  Copyright Spot Metrix, Inc 2009. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MainViewController.h"
#import "Constants.h"

#define SG_CONSUMER_KEY @"cxu7vcXRsfSaBZGm4EZffVGRq662YCNJ"
#define SG_CONSUMER_SECRET @"fTGANz54NXzMVQ6gwgnJcKEua4m2MLSs"

@interface MainViewController (Private)
- (void) addBirdseyeView;
@end

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
    [birdseyeView release];
    
    [toggleMapButton release];
    
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
    
    toggleMapButton.hidden = [((NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"3darMapMode"]) isEqualToString:@"auto"];
    
    [mapView startCamera];
}

- (void) viewDidLoad 
{
	[super viewDidLoad];
    
    [self initSound];
    self.view.backgroundColor = [UIColor blackColor];
    
    hudView = nil;////////////////
    
    if (hudView)
    {
        mapView.sm3dar.hudView = hudView;
        hudView.hidden = YES;
    }    
    
    [self addBirdseyeView];

    
    // Search screen
    
    self.search = [[[YahooLocalSearch alloc] init] autorelease];
    search.delegate = self;
 
//    mapView.sm3dar.focusView = mapView.calloutView;
}

- (void)runLocalSearch:(NSString*)query 
{
    [spinner startAnimating];

    [mapView removeAnnotations:mapView.annotations];
    
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

- (void) sm3darLoadPoints:(SM3DARController *)sm3dar
{
    // 3DAR initialization is complete
    
//    [self addDirectionBillboardsWithFixtures];    
    
//    [self runLocalSearch:@"bar"];
    
    self.searchQuery = nil;

    [self fetchSimpleGeoPlaces];
    
}

- (void) sm3dar:(SM3DARController *)sm3dar didChangeFocusToPOI:(SM3DARPoint *)newPOI fromPOI:(SM3DARPoint *)oldPOI
{
	[self playFocusSound];
}

- (void) sm3dar:(SM3DARController *)sm3dar didChangeSelectionToPOI:(SM3DARPoint *)newPOI fromPOI:(SM3DARPoint *)oldPOI
{
	NSLog(@"POI was selected: %@", [newPOI title]);
    
    SM3DARPointOfInterest *poi = (SM3DARPointOfInterest *)newPOI;
    
    mapView.calloutView.hidden = NO;
    mapView.calloutView.titleLabel.text = newPOI.title;
    mapView.calloutView.distanceLabel.text = [poi formattedDistanceFromCurrentLocationWithUnits];
    
    [newPOI.view addSubview:mapView.calloutView];

    CGPoint center = mapView.calloutView.center;
    mapView.calloutView.center = CGPointMake((center.x), // - mapView.calloutView.bounds.size.width/2), 
                                             center.y -(mapView.calloutView.bounds.size.height + 4));

//    CGRect f = mapView.calloutView.frame;
//    f.origin.y = newPOI.view.frame.origin.y - 100;
//    mapView.calloutView.frame = f;
    
    
}


- (void) mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"callout tapped");
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
    birdseyeView.centerLocation = newLocation;
}

#pragma mark -

/*
- (SM3DARFixture*) addFixtureWithView:(SM3DARPointView*)pointView
{
    SM3DARFixture *point = [[SM3DARFixture alloc] init];
    
    point.view = pointView;  
    
    pointView.point = point;
    
    return [point autorelease];
}

- (SM3DARFixture*) addLabelFixture:(NSString*)title subtitle:(NSString*)subtitle coord:(Coord3D)coord
{
    RoundedLabelMarkerView *v = [[RoundedLabelMarkerView alloc] initWithTitle:title subtitle:subtitle];

    SM3DARFixture *fixture = [self addFixtureWithView:v];
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
		SM3DARPointOfInterest *poi = [[SM3DARPointOfInterest alloc] initWithLocation:[data objectForKey:@"location"]
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

- (void) sm3darDidShowMap:(SM3DARController *)sm3dar
{
    hudView.hidden = YES;
}

- (void) sm3darDidHideMap:(SM3DARController *)sm3dar
{
    hudView.hidden = NO;
    [hudView addSubview:mapView.sm3dar.iconLogo];

}

#pragma mark SimpleGeoDelegate methods

- (void)requestDidFail:(ASIHTTPRequest *)request
{
    NSLog(@"SimpleGeo Request failed: %@: %i", [request responseStatusMessage], [request responseStatusCode]);
}

- (void)requestDidFinish:(ASIHTTPRequest *)request
{
    //NSLog(@"SimpleGeo Request finished: %@", [request responseString]);
}

- (void) fetchSimpleGeoPlaces
{
    SGPoint *here = [SGPoint pointWithLatitude:mapView.sm3dar.userLocation.coordinate.latitude
                                     longitude:mapView.sm3dar.userLocation.coordinate.longitude];
    
    [simplegeo getPlacesNear:here 
                    matching:self.searchQuery 
                  inCategory:nil
                      within:15.0 
                       count:50];
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
    
    NSLog(@"Adding annotations");
    [birdseyeView setLocations:annotations];
    [self.mapView addAnnotations:annotations];

    [mapView zoomMapToFit];
    [spinner stopAnimating];
}

#pragma mark -

- (void) add3dObjectNortheastOfUserLocation 
{
    SM3DARTexturedGeometryView *modelView = [[[SM3DARTexturedGeometryView alloc] initWithOBJ:@"star.obj" textureNamed:nil] autorelease];
    
    CLLocationDegrees latitude = mapView.sm3dar.userLocation.coordinate.latitude + 0.0001;
    CLLocationDegrees longitude = mapView.sm3dar.userLocation.coordinate.longitude + 0.0001;

    
    // Add a point with a 3D 
    
    SM3DARPoint *poi = [[mapView.sm3dar addPointAtLatitude:latitude
                                                 longitude:longitude
                                                  altitude:0 
                                                     title:nil 
                                                      view:modelView] autorelease];
    
    [mapView addAnnotation:(SM3DARPointOfInterest*)poi];  // 
}

- (IBAction) refreshButtonTapped
{
    [spinner startAnimating];
    
    [self.mapView removeAllAnnotations];
 
//    [self add3dObjectNortheastOfUserLocation];
    [self fetchSimpleGeoPlaces];    
}

- (void) addBirdseyeView
{
    CGFloat birdseyeViewRadius = 70.0;

    birdseyeView = [[BirdseyeView alloc] initWithLocations:nil
                                                    around:mapView.sm3dar.userLocation 
                                            radiusInPixels:birdseyeViewRadius];
    
    birdseyeView.center = CGPointMake(self.view.frame.size.width - (birdseyeViewRadius) - 10, 
                                      10 + (birdseyeViewRadius));
    
    [self.view addSubview:birdseyeView];
    
    mapView.sm3dar.compassView = birdseyeView;    
}

- (IBAction) toggleMapButtonTapped:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    if (sender.selected)
    {
        [mapView.sm3dar hideMap];
    }
    else
    {
        [mapView.sm3dar showMap];
    }
}

@end

