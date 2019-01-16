//
//  MPMainViewProtocol.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 03/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#ifndef MPMainViewProtocol_h
#define MPMainViewProtocol_h

@protocol MPMainPresenterProtocol;

@protocol MPMainViewProtocol

@required
@property (nonatomic, weak) id<MPMainPresenterProtocol> presenter;

@required
-(UINavigationController *)getNavigationView;

@optional
-(void)showLoadingIndicator;

@optional
-(void)hideLoadingIndicator;

@optional
-(void)showEntities:(NSArray *)entites;

@end


#endif /* MPMainViewProtocol_h */
