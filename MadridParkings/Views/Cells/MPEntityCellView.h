//
//  MPEntityCellView.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 11/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MPEntityViewModelProtocol;

@interface MPEntityCellView : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *entityNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *entityAddressLabel;

-(void)bindEntity:(id<MPEntityViewModelProtocol>)entity;

@end

NS_ASSUME_NONNULL_END
