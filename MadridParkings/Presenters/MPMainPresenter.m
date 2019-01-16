//
//  MPMainPresenter.m
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import "MPMainPresenter.h"
#import "MPMainViewProtocol.h"
#import "MPEntityViewModel.h"

@implementation MPMainPresenter

-(void)viewLoaded {

    __weak typeof(self) weakSelf = self;
    [self.view showLoadingIndicator];
    [self.interactor getPublicParkingsOnCompletion:^(NSArray<id<MPEntityBaseProtocol>> * _Nullable items, NSError * _Nullable error) {
        
        if (!error) {
            NSLog(@"Total párkings: %ld", [items count]);
            NSMutableArray *entities = [NSMutableArray new];
            for (id<MPEntityProtocol> item in items) {
                [entities addObject:[[MPEntityViewModel alloc] initWithEntity:item]];
            }
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf.view showEntities:entities];
                [weakSelf.view hideLoadingIndicator];
            });
        } else {
            //TODO: show error
            dispatch_async(dispatch_get_main_queue(), ^(void){
                [weakSelf.view hideLoadingIndicator];
            });
        }
    }];
}

@end
