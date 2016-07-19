//
//  FoodNetworkDetailsViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/18/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "FoodNetworkDetailsViewController.h"

@interface FoodNetworkDetailsViewController ()

@end

@implementation FoodNetworkDetailsViewController{
   // GMSMapView *mapView_;
}
//GMSMarker *marker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
       _currentRestaurantNameLabel.text = _currentRestaurant.restaurantName;
    _currentRestaurantAddressLabel.text = _currentRestaurant.restaurantAddress;
    _currentRestaurantPhoneNumberLabel.text = _currentRestaurant.restaurantPhoneNumber;
    
    _currentRestaurantWebsiteLabel.text = _currentRestaurant.restaurantWebsite.absoluteString;
    NSLog(@"************#######!!!!!!!!NAME=%@, ADDRESS=%@, PHONE=%@, WEBSITE=%@",_currentRestaurantNameLabel.text, _currentRestaurantAddressLabel.text, _currentRestaurantPhoneNumberLabel.text, _currentRestaurantWebsiteLabel.text);
   

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
