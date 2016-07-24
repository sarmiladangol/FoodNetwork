//
//  MapViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/21/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <MapKit/MapKit.h>
@import GoogleMaps;
#import "FoodNetworkDetailsViewController.h"
#import "FoodNetworkListTableViewController.h"
#import "Restaurant.h"

@interface MapViewController : UIViewController
//@property (nonatomic) CLLocationCoordinate2D currentLocation;
//@property (strong, nonatomic) CLLocationManager *locationManager;

@property (nonatomic, strong) NSString *mapLongitude;
@property (nonatomic, strong) NSString *mapLatitude;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *name;
@property (nonatomic) CLLocationCoordinate2D mapLocation;
@property (nonatomic, strong) CLLocationManager *mapLocationManager;
@end
