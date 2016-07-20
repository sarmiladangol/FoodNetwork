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
    
    _currentRestaurantWebsiteLabel.text = _currentRestaurant.restaurantWebsite;
   // _currentRestaurantRatingLabel.text = _currentRestaurant.restaurantRating;
   
    NSLog(@"************#######!!!!!!!!NAME=%@, ADDRESS=%@, PHONE=%@, WEBSITE=%@",_currentRestaurantNameLabel.text, _currentRestaurantAddressLabel.text, _currentRestaurantPhoneNumberLabel.text, _currentRestaurantWebsiteLabel.text);
    
   
    
   
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 20, 20)];
    img.image=[UIImage imageNamed:@"icons.png"];
    [_currentRestaurantNameLabel addSubview:img];
    
    
    
    
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)makePhoneCall:(id)sender {
    NSLog(@"******************** call phone number");
    NSString *phoneNumberString = _currentRestaurant.restaurantPhoneNumber;
    phoneNumberString = [phoneNumberString stringByReplacingOccurrencesOfString:@" " withString:@""];
    phoneNumberString = [NSString stringWithFormat:@"tel:%@", phoneNumberString];
    NSURL *phoneNumberURL = [NSURL URLWithString:phoneNumberString];
    NSLog(@"PhoneNumberURL=%@", phoneNumberString);
    [[UIApplication sharedApplication] openURL:phoneNumberURL];
}




- (IBAction)gotoWebsite:(id)sender {
    NSLog(@"********* goto website **********");
//    NSURL *website = _currentRestaurant.restaurantWebsite;
//    NSLog(@"Website:%@", website);
//    [[UIApplication sharedApplication] openURL:website];
}

- (IBAction)openGoogleMaps:(id)sender {
    NSLog(@"************ Open Google maps ***********");
//    NSString *latlong = _currentRestaurant.restaurantLocation;
    
    
    
  //  NSString *mapUrl = [NSString stringWithFormat:@"http:/maps.google.com/maps?ll=%@", [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    
//    NSString *mapUrl = [NSString stringWithFormat:@"%@", [latlong stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding]];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapUrl]];
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
