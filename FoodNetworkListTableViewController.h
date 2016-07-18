//
//  FoodNetworkListTableViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/14/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
@import GoogleMaps;

@interface FoodNetworkListTableViewController : UIViewController <UITableViewDataSource, UITabBarDelegate>
@property (nonatomic) CLLocationCoordinate2D currentLocation;
@property (strong, nonatomic) CLLocationManager *locationManager;

@end
