//
//  ThemesViewControllerDelegate.h
//  Messenger
//
//  Created by Bogdan Belogurov on 13/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ThemesViewController;

@protocol ThemesViewControllerDelegate <NSObject>

- (void)themesViewController: (ThemesViewController *)controller didSelectTheme:(UIColor *)selectedTheme;

@end

