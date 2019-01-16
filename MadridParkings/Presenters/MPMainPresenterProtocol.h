//
//  MPMainPresenterProtocol.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#ifndef MPMainPresenterProtocol_h
#define MPMainPresenterProtocol_h

@protocol MPMainViewProtocol;

@protocol MPMainPresenterProtocol

@required
@property (nonatomic, strong) id<MPMainViewProtocol> view;

@required
@property (nonatomic, strong) id<MPMainInteractorProtocol> interactor;

@optional
-(void)viewLoaded;

@end

#endif /* MPMainPresenterProtocol_h */
