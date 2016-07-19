//
//  FoodNetworkDetailsViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/18/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Restaurant.h"
@import GoogleMaps;
#import "FoodNetworkListTableViewController.h"


@interface FoodNetworkDetailsViewController : UIViewController
@property (strong, nonatomic) Restaurant *currentRestaurant;


@property (weak, nonatomic) IBOutlet UILabel *currentRestaurantNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRestaurantAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRestaurantPhoneNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRestaurantWebsiteLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentRestaurantRatingLabel;

@end
