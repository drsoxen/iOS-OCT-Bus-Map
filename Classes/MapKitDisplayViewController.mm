//
//  MapKitDisplayViewController.m
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import "MapKitDisplayViewController.h"
#import "DisplayMap.h"

@implementation MapKitDisplayViewController

@synthesize mapView;
@synthesize BusNum;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/

-(void)loadCSV
{
	NSBundle *bundle = [NSBundle mainBundle];
	NSString *textFilePath = [bundle pathForResource:@"stops" ofType:@"txt"];
	NSString *fileContents = [NSString stringWithContentsOfFile:textFilePath];
	NSArray *quizArray = [[NSArray alloc] initWithArray:[fileContents componentsSeparatedByString:@","]];
	self->theQuiz = quizArray;
	//[quizArray release];
    

}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
    [self loadCSV];
    
//    for(NSString *s in theQuiz)
//        NSLog(s);
    
    mapView.showsUserLocation = YES;
    
	[mapView setMapType:MKMapTypeHybrid];
	[mapView setZoomEnabled:YES];
	[mapView setScrollEnabled:YES];
	MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
    
    
    NSLog(@"%f, %f", mapView.userLocation.location.coordinate.latitude,
          mapView.userLocation.location.coordinate.longitude);
    
    
	region.center.latitude = mapView.userLocation.coordinate.latitude;
	region.center.longitude = mapView.userLocation.coordinate.longitude;
    
    if(region.center.latitude == 0 && region.center.longitude == 0)
    {
        region.center.latitude = 45.42153;
        region.center.longitude = -75.697193;
    }
    
	region.span.longitudeDelta = 0.01f;
	region.span.latitudeDelta = 0.01f;
	[mapView setRegion:region animated:YES]; 
	
	[mapView setDelegate:self];
	
    
    
    for(int i =12; i < [theQuiz count]; i +=11)
    {        
        DisplayMap *ann = [[DisplayMap alloc] init];
        
        ann.subtitle = [theQuiz objectAtIndex:i]; 
        //NSLog(@"%@",ann.subtitle);
        
        ann.title = [theQuiz objectAtIndex:i+1];
                
        MKCoordinateRegion temp;
        temp.center.latitude = [[theQuiz objectAtIndex:i+3] doubleValue];
        //NSLog(@"%f",temp.center.latitude);
        temp.center.longitude = [[theQuiz objectAtIndex:i+4] doubleValue];
        //NSLog(@"%f",temp.center.longitude);
        ann.coordinate = temp.center; 
        
        [mapView addAnnotation:ann];
    }
}

-(IBAction)FindBus
{
    [BusNum resignFirstResponder];
}

-(IBAction)CenterMapToUser
{
    
    MKCoordinateRegion region = { {0.0, 0.0 }, { 0.0, 0.0 } }; 
    region.center.latitude = mapView.userLocation.coordinate.latitude;
	region.center.longitude = mapView.userLocation.coordinate.longitude;
	region.span.longitudeDelta = 0.01f;
	region.span.latitudeDelta = 0.01f;
	[mapView setRegion:region animated:YES]; 
}

-(MKAnnotationView *)mapView:(MKMapView *)mV viewForAnnotation:
 (id <MKAnnotation>)annotation {
	MKPinAnnotationView *pinView = nil; 
	if(annotation != mapView.userLocation) 
	{
		static NSString *defaultPinID = @"com.invasivecode.pin";
		pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:defaultPinID];
		if ( pinView == nil ) pinView = [[[MKPinAnnotationView alloc]
										  initWithAnnotation:annotation reuseIdentifier:defaultPinID] autorelease];

		pinView.pinColor = MKPinAnnotationColorRed; 
		pinView.canShowCallout = YES;
		pinView.animatesDrop = YES;
		} 
	else {
		[mapView.userLocation setTitle:@"I am here"];
	}
	return pinView;
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[mapView release];
    [super dealloc];
}

@end
