//
//  Themes.m
//  Messenger
//
//  Created by Bogdan Belogurov on 13/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Themes.h"

@implementation Themes

@synthesize theme1 = _theme1;
@synthesize theme2 = _theme2;
@synthesize theme3 = _theme3;

- (id)init {
    printf("init\n");
    [super init];
    
    _theme1 = [UIColor whiteColor];
    _theme2 = [UIColor darkGrayColor];
    _theme3 = [UIColor greenColor];
    
    return self;
}

- (void)dealloc {
    [_theme1 release];
    [_theme2 release];
    [_theme3 release];
    [super dealloc];
}

- (void)setTheme1:(UIColor *)theme1 {
    [_theme1 release];
    _theme1 = [theme1 retain];
}

- (void)setTheme2:(UIColor *)theme2{
    [_theme2 release];
    _theme2 = [theme2 retain];
}

- (void)setTheme3:(UIColor *)theme3{
    [_theme3 release];
    _theme3 = [theme3 retain];
}

- (UIColor *)theme1{
    return _theme1;
}

- (UIColor *)theme2{
    return _theme2;
}

- (UIColor *)theme3{
    return _theme3;
}

@end
