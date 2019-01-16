//
//  MPEntityCellView.m
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 11/01/2019.
//  Copyright © 2019 Rafael Gil. All rights reserved.
//

#import "MPEntityCellView.h"
#import "MPEntityViewModelProtocol.h"

@implementation MPEntityCellView

-(void)bindEntity:(id<MPEntityViewModelProtocol>)entity {
    
    self.entityNameLabel.text = entity.entityName;
    self.entityAddressLabel.text = entity.entityAddress;
}

@end
