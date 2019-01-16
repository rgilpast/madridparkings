//
//  MPEntityViewModel.m
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 11/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import "MPEntityViewModel.h"

@implementation MPEntityViewModel

- (id)initWithEntity:(id<MPEntityProtocol>)entity {
    
    if (self = [super init]) {
        
        _entityName = entity.title;
        
        //build the address as street, locality - postalcode
        NSMutableString *address = [NSMutableString new];
        NSString *nextSeparator = @"";
        if ([entity.streetAddress length]) {
            [address appendString: entity.streetAddress];
            nextSeparator = @", ";
        }
        if ([entity.locality length]) {
            [address appendString:nextSeparator];
            [address appendString: entity.locality];
            nextSeparator = @" - ";
        }
        if ([entity.postalCode length]) {
            [address appendString:nextSeparator];
            [address appendString: entity.postalCode];
        }
        _entityAddress = address;
    }
    return self;
}

@end
