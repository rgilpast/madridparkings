//
//  MPEntityViewModelProtocol.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 11/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPEntityViewModelProtocol <NSObject>

@required
@property (nonatomic, strong) NSString *entityName;
@required
@property (nonatomic, strong) NSString *entityAddress;

@end

NS_ASSUME_NONNULL_END
