//
//  MPMainViewController.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 24/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPMainViewProtocol.h"
#import "MPMainPresenterProtocol.h"

@interface MPMainViewController : UIViewController<MPMainViewProtocol>

@property (nonatomic, weak) id<MPMainPresenterProtocol> presenter;

@end

