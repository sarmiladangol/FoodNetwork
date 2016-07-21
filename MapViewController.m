//
//  MapViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/21/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "MapViewController.h"
#import "FoodNetworkListTableViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView;
}
GMSMarker *marker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:42.366093
                                                            longitude:-83.0745931
                                                                 zoom:6];
    
    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(42.366093, -83.0745931);
    marker.title = @"Detroit";
    marker.snippet = @"Michigan";
    marker.map = mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
