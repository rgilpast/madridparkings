//
//  MPMainFlowController.m
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import "MPMainFlowController.h"
#import "MPMainViewProtocol.h"
#import "MPMainPresenter.h"

@implementation MPMainFlowController

+(id<MPMainPresenterProtocol>)instanceMainPresenter {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UINavigationController *navigationView =  (UINavigationController *)[storyboard instantiateInitialViewController];
    
    id<MPMainViewProtocol> view = navigationView.viewControllers[0];
    id<MPMainPresenterProtocol> presenter = [[MPMainPresenter alloc] init];
    id<MPOnlineDataManagerProtocol>onlineManager = [[MPWebServicesManager alloc] init];
    id<MPOfflineDataManagerProtocol>offlineManager = [[MPDatabaseManager alloc] init];
    id<MPMainInteractorProtocol>interactor = [[MPMainInteractor alloc] initWithOnlineManager:onlineManager withOfflineManager:offlineManager];
    presenter.interactor = interactor;
    presenter.view = view;
    view.presenter = presenter;
        
    return presenter;
}

@end
