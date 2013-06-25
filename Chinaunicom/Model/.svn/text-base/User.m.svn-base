//
//  User.m
//  Chinaunicom
//
//  Created by LITK on 13-5-15.
//  Copyright (c) 2013年 Chinaunicom. All rights reserved.
//

#import "User.h"

@implementation User
@synthesize userId,account,name,icon;
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.account forKey:@"account"];
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.icon forKey:@"icon"];
}
- (id)initWithCoder:(NSCoder *)decoder
{
    if(self = [super init])
    {
        self.userId  = [decoder decodeObjectForKey:@"userId"];
        self.account  = [decoder decodeObjectForKey:@"account"];
        self.name  = [decoder decodeObjectForKey:@"name"];
          self.icon  = [decoder decodeObjectForKey:@"icon"];
    }
    return  self;
}
@end
