//
//  FoodNetworkDetailsViewController.h
//  FoodNetwork
//
//  Created by Sarmila on 7/12/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "ViewController.h"
#import "Restaurant.h"
#import "FoodNetworkListViewController.h"


@interface FoodNetworkDetailsViewController : ViewController
@property (strong, nonatomic) Restaurant *currentRestaurant;

@property(nonatomic, strong) NSString *restaurantNameLabel;
@property(nonatomic, strong) NSString *restaurantAddressLabel;
@property(nonatomic, strong) NSString *restaurantPhoneNumberLabel;
@property(nonatomic, strong) NSURL *restaurantWebsiteLabel;

@end
