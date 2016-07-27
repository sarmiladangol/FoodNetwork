//
//  FoodNetworkDetailsViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/18/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "FoodNetworkDetailsViewController.h"
//@import GoogleMaps;

#import "CheckInViewController.h"
@import Firebase;
@import FirebaseDatabase;
//@import FirebaseStorage;
@interface FoodNetworkDetailsViewController ()

@end

@implementation FoodNetworkDetailsViewController{
//    GMSMapView *mapView;
}
//GMSMarker *marker;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentRestaurantNameLabel.text = _currentRestaurant.restaurantName;
    _currentRestaurantAddressLabel.text = _currentRestaurant.restaurantAddress;
    _currentRestaurantPhoneNumberLabel.text = _currentRestaurant.restaurantPhoneNumber;
    _currentRestaurantWebsiteLabel.text = _currentRestaurant.restaurantWebsite;
    _currentRestaurantRatingLabel.text = [NSString stringWithFormat:@"Ratings: %@", _currentRestaurant.restaurantRating];
    _currentRestaurantTypesLabel.text = _currentRestaurant.restaurantTypes;
    
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
    NSString *websiteString = _currentRestaurant.restaurantWebsite;
    websiteString = [NSString stringWithFormat:@"site:%@", websiteString];
    NSURL *websiteUrl = [NSURL URLWithString:websiteString];
    [[UIApplication sharedApplication] openURL:websiteUrl];
}

- (IBAction)openGoogleMaps:(id)sender {
    NSLog(@"************ Open Google maps ***********");
    
    
  //  NSString *latlong = _currentRestaurant.restaurantLocation;
//    
//    NSString *mapUrl = [NSString stringWithFormat:@"http:/maps.google.com/maps?ll=%@", [latlong stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
//    NSString *mapUrl = [NSString stringWithFormat:@"%@", [latlong stringByAddingPercentEncodingWithAllowedCharacters:NSUTF8StringEncoding]];
//   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mapUrl]];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{

    if ([[segue identifier] isEqualToString:@"locationForMapSegue"]){
        
        MapViewController *vc = [segue destinationViewController];
        vc.mapLatitude = [NSString stringWithFormat:@"%f", _currentRestaurant.location.latitude];
        vc.mapLongitude = [NSString stringWithFormat:@"%f", _currentRestaurant.location.longitude];
        vc.rating = _currentRestaurant.restaurantRating;
        vc.name = _currentRestaurant.restaurantName;
    }
    
    if ([[segue identifier] isEqualToString:@"checkinSegue"]) {
        CheckInViewController *vc = [segue destinationViewController];
        vc.checkinRestaurant = _currentRestaurant;
        NSLog(@"VVVVCCCCCC************* %@", vc.checkinRestaurant.description);
        
    }
    
    
}

- (IBAction)checkinBtnPressed:(id)sender {
    NSLog(@"Checkin Btn pressed");
    [self performSegueWithIdentifier:@"checkinSegue" sender:self];
}

@end
