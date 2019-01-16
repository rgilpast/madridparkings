//
//  MPMainFlowController.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPMainPresenterProtocol;

@interface MPMainFlowController : NSObject

+(id<MPMainPresenterProtocol>)instanceMainPresenter;

@end

NS_ASSUME_NONNULL_END
