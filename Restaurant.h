//
//  Restaurant.h
//  FoodNetwork
//
//  Created by Sarmila on 7/12/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <Foundation/Foundation.h>
@import GoogleMaps;

@interface Restaurant : NSObject
@property (strong, nonatomic) NSString *uid;
@property(nonatomic, strong) NSString *restaurantName;
@property (nonatomic) CLLocationCoordinate2D location;
@property(nonatomic, strong) NSString *restaurantAddress;
@property(nonatomic, strong) NSString *restaurantPhoneNumber;
@property(nonatomic, strong) NSString *restaurantWebsite;
@property (nonatomic, strong) NSString *restaurantTypes;
//@property float *restaurantRating;
@property (nonatomic, strong) NSString *restaurantRating;
@property (strong, nonatomic) NSString *restaurantLocation;

//@property(nonatomic, strong) NSMutableArray *restaurantArray;

@property (nonatomic, strong) NSString *restaurantLatitude;
@property (nonatomic, strong) NSString *restaurantLongitude;

@property (strong, nonatomic) NSString *loggedinuUserId;
@end
