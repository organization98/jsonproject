//
//  Company.m
//  JSONProject
//
//  Created by Dmitriy Demchenko on 11/26/14.
//  Copyright (c) 2014 Home. All rights reserved.
//

#import "Company.h"
#import "User.h"
#import "CoreDataManager.h"


@implementation Company

@dynamic bs;
@dynamic catchPhrase;
@dynamic name;
@dynamic user;

+ (Company *)companyFromDictionary:(NSDictionary *)dictionary {
    
    // проверка : существует ли такой Company
    NSString *nameCompany = [dictionary objectForKey:@"Company"];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", nameCompany];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Company"
                                              inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    [request setEntity:entity];
    [request setPredicate:predicate];
    NSError *error;
    NSArray *result = [[[CoreDataManager sharedManager] managedObjectContext] executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    Company *company = nil;
    if ([result count]) {
        company = [result objectAtIndex:0];
    } else {
        company = [NSEntityDescription insertNewObjectForEntityForName:@"Company"
                                             inManagedObjectContext:[[CoreDataManager sharedManager] managedObjectContext]];
    }
    company.name = [dictionary objectForKey:@"name"];
    company.bs = [dictionary objectForKey:@"bs"];
    company.catchPhrase = [dictionary objectForKey:@"catchPhrase"];
    
    [[[CoreDataManager sharedManager] managedObjectContext] save:&error];
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    return company;
}

- (NSDictionary *)dictionaryFromCompany {
    
    NSDictionary *address =  @{
                               @"name"          : self.name,
                               @"catchPhrase"   : self.catchPhrase,
                               @"bs"            : self.bs
                               };
    return address;
}

@end
