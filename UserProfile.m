//
//  UserProfile.m
//  FoodNetwork
//
//  Created by Sarmila on 7/12/16.
//  Copyright © 2016 SarmilaDangol. All rights reserved.
//

#import "UserProfile.h"

@implementation UserProfile
-(instancetype)initUserProfileWithEmail:(NSString *)email username:(NSString *)username password:(NSString *)password uid:(NSString *)uid{
    self = [super init];
    if(self){
        _email = email;
        _username = username;
        _password = password;
        _uid = uid;
    }
    return self;
}

@end
