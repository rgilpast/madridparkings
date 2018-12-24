//
//  AppDelegate.h
//  MadridParkings
//
//  Created by Rafael Gil Pastor on 24/12/2018.
//  Copyright © 2018 Rafael Gil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

