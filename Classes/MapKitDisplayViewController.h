//
//  MapKitDisplayViewController.h
//  MapKitDisplay
//
//  Created by Chakra on 12/07/10.
//  Copyright Chakra Interactive Pvt Ltd 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class DisplayMap;

@interface MapKitDisplayViewController : UIViewController <MKMapViewDelegate> {
	
    IBOutlet UITextField *BusNum;
    NSArray *theQuiz;
}
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (nonatomic, retain) IBOutlet UITextField *BusNum;


-(IBAction)CenterMapToUser;
-(IBAction)FindBus;


@end

