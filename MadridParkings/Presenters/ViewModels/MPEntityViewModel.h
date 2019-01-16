//
//  MPEntityViewModel.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 11/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPEntityViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface MPEntityViewModel : NSObject<MPEntityViewModelProtocol>

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *entityAddress;

- (id)initWithEntity:(id<MPEntityProtocol>)entity;

@end

NS_ASSUME_NONNULL_END
