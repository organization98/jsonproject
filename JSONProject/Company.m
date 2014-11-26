//
//  Company.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Company.h"
#import "User.h"


@implementation Company

@dynamic bs;
@dynamic catchPhrase;
@dynamic name;
@dynamic user;

- (NSDictionary *)dictionaryFromCompany {
    
    NSDictionary *address =  @{
                               @"name" : self.name,
                               @"catchPhrase" : self.catchPhrase,
                               @"bs": self.bs
                               };
    return address;
    
    
}

@end
