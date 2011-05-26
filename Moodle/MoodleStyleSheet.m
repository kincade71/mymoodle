//
//  MoodleButtonStyleSheet.m
//  Moodle
//
//  Created by Dongsheng Cai on 23/05/11.
//  Copyright 2011 Moodle. All rights reserved.
//

#import "MoodleStyleSheet.h"
#import "Constants.h"

@implementation MoodleStyleSheet
- (TTStyle*)notificationButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:UIColorFromRGB(0xFF9640)
                                               color2:UIColorFromRGB(0xFFB273) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:UIColorFromRGB(0xFFFFFF)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:0] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:UIColorFromRGB(0xFFB273)
                                               color2:UIColorFromRGB(0xFF9640) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

- (TTStyle*)MoodleLauncherButton:(UIControlState)state {
    return
    [TTPartStyle styleWithName:@"image" style:TTSTYLESTATE(launcherButtonImage:, state) next:
     [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:12] color:UIColorFromRGB(0xA64B00)
                minimumFontSize:11 shadowColor:UIColorFromRGB(0x000000)
                   shadowOffset:CGSizeZero next:nil]];
}

- (UIColor *) toolbarTintColor {
    return UIColorFromRGB(ColorNavigationBar);
}

@end