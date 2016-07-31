//
//  History.h
//  FoodNetwork
//
//  Created by Sarmila on 7/27/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface History : NSObject

@property (strong, nonatomic) NSString *uid;
@property(nonatomic, strong) NSString *checkinRestaurantName;
@property(nonatomic, strong) NSString *checkinRestaurantAddress;
@property(nonatomic, strong) NSString *checkinRestaurantPhone;
@property(nonatomic, strong) NSString *checkinRestaurantWebsite;
@property (nonatomic, strong) NSString *checkinRestaurantAmountSpend;
@property (nonatomic, strong) NSString *checkinUserId;
@end
