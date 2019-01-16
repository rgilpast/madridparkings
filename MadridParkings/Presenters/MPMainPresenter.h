//
//  MPMainPresenter.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMainPresenterProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol MPMainViewProtocol;

@interface MPMainPresenter : NSObject<MPMainPresenterProtocol>

@property (nonatomic, strong) id<MPMainViewProtocol> view;
@property (nonatomic, strong) id<MPMainInteractorProtocol> interactor;

-(void)viewLoaded;

@end

NS_ASSUME_NONNULL_END
