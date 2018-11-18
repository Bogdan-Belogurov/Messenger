//
//  ThemesViewController.m
//  Messenger
//
//  Created by Bogdan Belogurov on 13/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

#import "ThemesViewController.h"

@implementation ThemesViewController

- (IBAction)themeChangeButton:(UIButton*)sender {
    NSString *currentTitleOfButton = sender.titleLabel.text;
    
    
    if ([currentTitleOfButton isEqualToString:@"White"]) {
        UIColor *firstTheme = [[self model] theme1];
        [self.delegate themesViewController:self didSelectTheme:firstTheme];
        self.view.backgroundColor = firstTheme;
    }
    
    if ([currentTitleOfButton isEqualToString:@"Gray"]) {
        UIColor *secondTheme = [[self model] theme2];
        [self.delegate themesViewController:self didSelectTheme:secondTheme];
        self.view.backgroundColor = secondTheme;
    }
    
    if ([currentTitleOfButton isEqualToString:@"Green"]) {
        
        UIColor *thirdTheme = [[self model] theme3];
        [self.delegate themesViewController:self didSelectTheme:thirdTheme];
        self.view.backgroundColor = thirdTheme;
    }
    
}

- (IBAction)backToPreviousVC:(id)sender {
    [self dismissViewControllerAnimated: true completion: nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(id<ThemesViewControllerDelegate>)delegate{
    return _delegate;
}

- (void)setDelegate:(id<ThemesViewControllerDelegate>)delegate {
    if (_delegate != delegate)
        _delegate = delegate;
}

- (Themes *)model {
    return _model;
}

- (void)setModel:(Themes *)model {
        [_model release];
        _model = [model retain];
}

- (void)dealloc{
    [_model release];
    [super dealloc];
}

@end
