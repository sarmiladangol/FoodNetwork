//
//  Restaurant.h
//  FoodNetwork
//
//  Created by Sarmila on 7/12/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Restaurant : NSObject
@property (strong, nonatomic) NSString *uid;
@property(nonatomic, strong) NSString *restaurantName;
@property(nonatomic, strong) NSString *restaurantAddress;
@property(nonatomic, strong) NSString *restaurantPhoneNumber;
@property(nonatomic, strong) NSURL *restaurantWebsite;

@property(nonatomic, strong) NSMutableArray *restaurantArray;
@end