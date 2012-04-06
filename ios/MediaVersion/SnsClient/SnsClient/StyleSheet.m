//
//  StyleSheet.m
//  SnsClient
//
//  Created by  on 11-9-17.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "StyleSheet.h"

@implementation StyleSheet
///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)textColor {
    return RGBCOLOR(35, 35, 35);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)highlightedTextColor {
    return RGBCOLOR(35, 35, 35);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableSubTextColor {
    return RGBCOLOR(35, 35, 35);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableRefreshHeaderLastUpdatedFont {
    return [UIFont systemFontOfSize:10.0f];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIFont*)tableRefreshHeaderStatusFont {
    return [UIFont boldSystemFontOfSize:12.0f];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderBackgroundColor {
    //return RGBCOLOR(80, 80, 80);
    return [[[UIColor alloc] initWithPatternImage:TTIMAGE(@"bundle://dragdown_bg.png")] autorelease];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderTextColor {
    return RGBCOLOR(255, 255, 255);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableRefreshHeaderTextShadowColor {
    return [[UIColor blackColor] colorWithAlphaComponent:0.9];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)tableRefreshHeaderTextShadowOffset {
    return CGSizeMake(0.0f, 1.0f);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIImage*)tableRefreshHeaderArrowImage {
    return TTIMAGE(@"bundle://fresharrow.png");
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableGroupedBackgroundColor {
    //return [[[UIColor alloc] initWithPatternImage:TTIMAGE(@"bundle://group_table_bg.png")] autorelease]; 
    //return RGBCOLOR(228, 230, 235); 
    return RGBCOLOR(228, 229, 222); //RGBCOLOR(204, 206, 193); 
}

/////////////////////////////////////////////////////////////////////////////////////////////////////
//- (UITableViewCellSelectionStyle)tableSelectionStyle {
//    return UITableViewCellSelectionStyleGray;//  UITableViewCellSelectionStyleBlue;
//}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tablePlainBackgroundColor {
    //return [[[UIColor alloc] initWithPatternImage:TTIMAGE(@"bundle://group_table_bg.png")] autorelease]; 
    return RGBCOLOR(228, 229, 222); 
}

#pragma mark Table Items


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)linkTextColor {
    return RGBCOLOR(87, 107, 149);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)timestampTextColor {
    return RGBCOLOR(36, 112, 216);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)moreLinkTextColor {
    return RGBCOLOR(36, 112, 216);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Table Headers


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTextColor {
    return [UIColor whiteColor];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderShadowColor {
    return RGBCOLOR(160, 160, 160);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGSize)tableHeaderShadowOffset {
    return CGSizeMake(0, 1);
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tableHeaderTintColor {
    return RGBCOLOR(168, 168, 168);
}


- (UIColor*)navigationBarTintColor { 
    return RGBCOLOR(30, 137, 194); 
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tabBarTintColor {
    return RGBCOLOR(204 ,206, 193);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)tabTintColor {
    return RGBCOLOR(228, 229, 222);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)toolbarTintColor {
    return RGBCOLOR(109, 132, 162);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)searchBarTintColor {
    return RGBCOLOR(165, 185, 198);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)redButtonStyle:(UIControlState)state{
    
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:10];
    UIColor* tintColor =  RGBCOLOR(180, 0, 0);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:[UIFont boldSystemFontOfSize:14]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)myButtonTintColor {
    return RGBCOLOR(30, 137, 194);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blueButtonStyle:(UIControlState)state{
    
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
    UIColor* tintColor =  TTSTYLEVAR(myButtonTintColor);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:[UIFont boldSystemFontOfSize:12]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blueColorBackButton:(UIControlState)state {
    TTShape* shape = [TTRoundedLeftArrowShape shapeWithRadius:4.5];
    UIColor* tintColor = TTSTYLEVAR(myButtonTintColor);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blackColorBackButton:(UIControlState)state {
    TTShape* shape = [TTRoundedLeftArrowShape shapeWithRadius:4.5];
    UIColor* tintColor = [UIColor blackColor];
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blueColorForwardButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRightArrowShape shapeWithRadius:4.5];
    UIColor* tintColor = TTSTYLEVAR(myButtonTintColor);
    return [TTSTYLESHEET toolbarButtonForState:state shape:shape tintColor:tintColor font:nil];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blueImgToolbarButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
    UIColor* tintColor = TTSTYLEVAR(myButtonTintColor);
    UIEdgeInsets padding = UIEdgeInsetsMake(2, 2, 2, 2);
    return [self toolbarButtonForState:state shape:shape tintColor:tintColor font:nil padding:padding];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)blueIconToolbarButton:(UIControlState)state {
    TTShape* shape = [TTRoundedRectangleShape shapeWithRadius:4.5];
    UIColor* tintColor = TTSTYLEVAR(myButtonTintColor);
    UIEdgeInsets padding = UIEdgeInsetsMake(2, 2, 2, 2);
    return [self toolbarButtonForState:state shape:shape tintColor:tintColor font:nil padding:padding];
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)SnSubTitleView:(UIControlState)state {
    UIColor* tintColor = TTSTYLEVAR(tabBarTintColor);
    UIColor* titleColor = RGBCOLOR(111, 112, 106);
    UIColor* borderColor = RGBCOLOR(119, 119, 116);
    
   return [TTSolidFillStyle styleWithColor:tintColor next:
           [TTFourBorderStyle styleWithTop:nil right:nil bottom:borderColor left:nil width:1 next:
            [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]
                                 color:titleColor shadowColor:[UIColor whiteColor]
                          shadowOffset:CGSizeMake(0, -1) next:nil]]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)newsTabBar {
    UIColor* border = [TTSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
    return
    [TTSolidFillStyle styleWithColor:TTSTYLEVAR(tabBarTintColor) next:
     [TTFourBorderStyle styleWithTop:nil right:nil bottom:border left:nil width:1 next:nil]];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)newsTab:(UIControlState)state {
    if (state == UIControlStateSelected) {
        UIColor* border = [TTSTYLEVAR(tabBarTintColor) multiplyHue:0 saturation:0 value:0.7];
    
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithTopLeft:0 topRight:0
                                                                   bottomRight:0 bottomLeft:0] next:
         
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(1, 1, 0, 1) next:
          [TTReflectiveFillStyle styleWithColor:TTSTYLEVAR(tabTintColor) next:
           [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-1, -1, 0, -1) next:
            [TTFourBorderStyle styleWithTop:border right:border bottom:nil left:border width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 6, 2, 6) next:
              [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:TTSTYLEVAR(textColor)
                         minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.8]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
        
    } else {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 1, 1, 1) next:
         [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(6, 6, 2,6) next:
          [TTTextStyle styleWithFont:[UIFont boldSystemFontOfSize:14]  color:TTSTYLEVAR(textColor)
                     minimumFontSize:8 shadowColor:[UIColor colorWithWhite:1 alpha:0.6]
                        shadowOffset:CGSizeMake(0, -1) next:nil]]];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)toolbarButtonTextColorForState:(UIControlState)state {
    if (state & UIControlStateDisabled) {
        return [UIColor colorWithWhite:1 alpha:0.4];
        
    } else {
        return [UIColor whiteColor];
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (UIColor*)toolbarButtonColorWithTintColor:(UIColor*)color forState:(UIControlState)state {
    if (state & UIControlStateHighlighted || state & UIControlStateSelected) {
        if (color.value < 0.2) {
            return [color addHue:0 saturation:0 value:0.2];
            
        } else if (color.saturation > 0.3) {
            return [color multiplyHue:1 saturation:1 value:0.4];
            
        } else {
            return [color multiplyHue:1 saturation:2.3 value:0.64];
        }
        
    } else {
        if (color.saturation < 0.5) {
            return [color multiplyHue:1 saturation:1.6 value:0.97];
            
        } else {
            return [color multiplyHue:1 saturation:1.25 value:0.75];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (TTStyle*)toolbarButtonForState:(UIControlState)state shape:(TTShape*)shape
                        tintColor:(UIColor*)tintColor font:(UIFont*)font padding:(UIEdgeInsets)padding
{
    UIColor* stateTintColor = [self toolbarButtonColorWithTintColor:tintColor forState:state];
    UIColor* stateTextColor = [self toolbarButtonTextColorForState:state];
    
    return
    [TTShapeStyle styleWithShape:shape next:
     [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 1, 0) next:
      [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.18) blur:0 offset:CGSizeMake(0, 1) next:
       [TTReflectiveFillStyle styleWithColor:stateTintColor next:
        [TTBevelBorderStyle styleWithHighlight:[stateTintColor multiplyHue:1 saturation:0.9 value:0.7]
                                        shadow:[stateTintColor multiplyHue:1 saturation:0.5 value:0.6]
                                         width:1 lightSource:270 next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, -1, 0, -1) next:
          [TTBevelBorderStyle styleWithHighlight:nil shadow:RGBACOLOR(0,0,0,0.15)
                                           width:1 lightSource:270 next:
           [TTBoxStyle styleWithPadding:padding next: //UIEdgeInsetsMake(8, 8, 8, 8) next:
            [TTImageStyle styleWithImageURL:nil defaultImage:nil
                                contentMode:UIViewContentModeScaleToFill size:CGSizeZero next:
             [TTTextStyle styleWithFont:font
                                  color:stateTextColor shadowColor:[UIColor colorWithWhite:0 alpha:0.4]
                           shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]]];
}

- (TTStyle*)embossedButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(255, 255, 255)
                                               color2:RGBCOLOR(216, 221, 231) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0, 0, 1, 0) next:
          [TTShadowStyle styleWithColor:RGBACOLOR(255,255,255,0.9) blur:1 offset:CGSizeMake(0, 1) next:
           [TTLinearGradientFillStyle styleWithColor1:RGBCOLOR(225, 225, 225)
                                               color2:RGBCOLOR(196, 201, 221) next:
            [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(10, 12, 9, 12) next:
              [TTTextStyle styleWithFont:nil color:[UIColor whiteColor]
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}

- (TTStyle*)dropButton:(UIControlState)state {
    if (state == UIControlStateNormal) {
        return
        [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
         [TTShadowStyle styleWithColor:RGBACOLOR(0,0,0,0.7) blur:3 offset:CGSizeMake(2, 2) next:
          [TTInsetStyle styleWithInset:UIEdgeInsetsMake(0.25, 0.25, 0.25, 0.25) next:
           [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(-0.25, -0.25, -0.25, -0.25) next:
             [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
              [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
               [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
                [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                               shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                              shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]]]];
    } else if (state == UIControlStateHighlighted) {
        return
        [TTInsetStyle styleWithInset:UIEdgeInsetsMake(3, 3, 0, 0) next:
         [TTShapeStyle styleWithShape:[TTRoundedRectangleShape shapeWithRadius:8] next:
          [TTSolidFillStyle styleWithColor:[UIColor whiteColor] next:
           [TTSolidBorderStyle styleWithColor:RGBCOLOR(161, 167, 178) width:1 next:
            [TTInsetStyle styleWithInset:UIEdgeInsetsMake(2, 0, 0, 0) next:
             [TTBoxStyle styleWithPadding:UIEdgeInsetsMake(11, 10, 9, 10) next:
              [TTTextStyle styleWithFont:nil color:TTSTYLEVAR(linkTextColor)
                             shadowColor:[UIColor colorWithWhite:255 alpha:0.4]
                            shadowOffset:CGSizeMake(0, -1) next:nil]]]]]]];
    } else {
        return nil;
    }
}
@end
