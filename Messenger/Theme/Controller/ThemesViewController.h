//
//  ThemesViewController.h
//  Messenger
//
//  Created by Bogdan Belogurov on 13/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Themes.h"
#import "ThemesViewControllerDelegate.h"

@interface ThemesViewController : UIViewController {
    id<ThemesViewControllerDelegate> _delegate;
    Themes *_model;
}

@property (nonatomic, assign) id<ThemesViewControllerDelegate> delegate;
@property (nonatomic, retain) Themes *model;

- (IBAction)themeChangeButton:(UIButton *)sender;
- (IBAction)backToPreviousVC:(id)sender;
- (id<ThemesViewControllerDelegate>)delegate;
- (void)setDelegate:(id<ThemesViewControllerDelegate>)delegate;
- (Themes *)model;
- (void)setModel:(Themes *)model;
- (void)dealloc;

@end
