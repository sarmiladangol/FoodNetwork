//
//  FoodNetworkListViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/11/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "FoodNetworkListViewController.h"
@import GoogleMaps;
#import "Restaurant.h"

@interface FoodNetworkListViewController ()

@end

@implementation FoodNetworkListViewController{
    GMSMapView *mapView_;
    GMSPlacesClient *_placesClient;
    GMSPlacePicker *_placePicker;
}

- (void)viewDidLoad {
    /*below code is to put Marker on map */
    /*
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:6];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    marker.title = @"Sydney";
    marker.snippet = @"Australia";
    marker.map = mapView_;
    
    
    */
    [super viewDidLoad];
   // _placesClient = [GMSPlacesClient sharedClient];
    [self getCurrentInfo];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)getCurrentInfo{
    NSLog(@"*****************Get Current location *************");
    NSLog(@"_placesClient=%@", _placesClient.description);
    _placesClient = [GMSPlacesClient sharedClient];
    [_placesClient currentPlaceWithCallback:^(GMSPlaceLikelihoodList *placeLikelihoodList, NSError *error){
        NSLog(@"test");
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        else {NSLog(@"Error is nil");}
        
        self.nameLabel.text = @"No current place";
        NSLog(@"namelabel=%@",self.nameLabel.text);
        self.addressLabel.text = @"";
        NSLog(@"addresslabel=%@",self.addressLabel.text);
        
        if (placeLikelihoodList != nil) {
            GMSPlace *place = [[[placeLikelihoodList likelihoods] firstObject] place];
            if (place != nil) {
            }
            else{
                NSLog(@"Place is nil");
            }
        }
        else{NSLog(@"placeLikelihoodList is nil");
        }
    }];
}


// Add a UIButton in Interface Builder to call this function
- (IBAction)pickPlace:(UIButton *)sender {
//    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(_locationManager.location.coordinate.latitude, _locationManager.location.coordinate.longitude);
    CLLocationCoordinate2D center = CLLocationCoordinate2DMake(42.3649315,-83.0751159);
    CLLocationCoordinate2D northEast = CLLocationCoordinate2DMake(center.latitude + 0.001,
                                                                  center.longitude + 0.001);
    CLLocationCoordinate2D southWest = CLLocationCoordinate2DMake(center.latitude - 0.001,
                                                                  center.longitude - 0.001);
    GMSCoordinateBounds *viewport = [[GMSCoordinateBounds alloc] initWithCoordinate:northEast
                                                                         coordinate:southWest];
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:viewport];
    _placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    [_placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            Restaurant *newRestaurant = [[Restaurant alloc]init];
            newRestaurant.restaurantName = place.name;
            newRestaurant.restaurantAddress = [[place.formattedAddress componentsSeparatedByString:@" "] componentsJoinedByString:@"\n"];
            newRestaurant.restaurantPhoneNumber = place.phoneNumber;
            newRestaurant.restaurantWebsite = place.website;
            
            NSLog(@"\n NEW RESTAURANT NAME=%@\n NEW RESTAURANT PHONE NUMBER= %@\n NEW RESTAURANT WEBSITE= %@\n", newRestaurant.restaurantName, newRestaurant.restaurantPhoneNumber, newRestaurant.restaurantWebsite);
            NSLog(@"NEW RETAURANT ADDRESS=%@",newRestaurant.restaurantAddress);
            
            self.nameLabel.text = place.name;
            self.addressLabel.text = [[place.formattedAddress
                                       componentsSeparatedByString:@", "] componentsJoinedByString:@"\n"];
            self.phoneNumberLabel.text = place.phoneNumber;
            
   
            
          //   NSLog(@"PICK_NAME=%@\n PICK_PHONE=%@\n PICK_WEBSITE=%@\n",place.name, place.phoneNumber, place.website);
          // NSLog(@"ADDRESS_LABEL=%@",self.addressLabel.text);
            
        } else {
            self.nameLabel.text = @"No place selected";
            self.addressLabel.text = @"";
        }
    }];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
