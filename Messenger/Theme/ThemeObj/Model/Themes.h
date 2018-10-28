//
//  Themes.h
//  Messenger
//
//  Created by Bogdan Belogurov on 13/10/2018.
//  Copyright © 2018 Bogdan Belogurov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Themes : NSObject {
    UIColor *_theme1;
    UIColor *_theme2;
    UIColor *_theme3;
}


@property (nonatomic, retain) UIColor *theme1;
@property (nonatomic, retain) UIColor *theme2;
@property (nonatomic, retain) UIColor *theme3;
- (id)init;
- (void)dealloc;
- (void)setTheme1:(UIColor *)theme1;
- (void)setTheme2:(UIColor *)theme2;
- (void)setTheme3:(UIColor *)theme3;
- (UIColor *)theme1;
- (UIColor *)theme2;
- (UIColor *)theme3;
@end
