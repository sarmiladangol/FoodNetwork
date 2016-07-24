//
//  MapViewController.m
//  FoodNetwork
//
//  Created by Sarmila on 7/21/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController{
    GMSMapView *mapView;
}
GMSMarker *marker;

- (void)viewDidLoad {
    [super viewDidLoad];
    _mapLocation.latitude = [_mapLatitude doubleValue];
    _mapLocation.longitude = [_mapLongitude doubleValue];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:_mapLocation.latitude
                                                            longitude:_mapLocation.longitude
                                                                 zoom:6];

    mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    
    
    // Creates a marker in the center of the map.
    marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(_mapLocation.latitude, _mapLocation.longitude);
    marker.title =_name;
    marker.snippet = [NSString stringWithFormat:@"Rating: %@", _rating];
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
