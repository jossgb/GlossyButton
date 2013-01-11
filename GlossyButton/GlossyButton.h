//
//  GlossyButton.h
//  GlossyButton
//
//  Created by Joss Giffard on 11/01/2013
//
//  Copyright (c) 2013 Joss Giffard
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
//  documentation files (the "Software"), to deal in the Software without restriction, including without limitation
//  the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and
//  to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or substantial portions
//  of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
//  THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
//  CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//
// This is intended to be a drop in replacement for the UIButton class
// that allows us to specifiy an RGB value for the button & will render
// a glossy button similar to those that are seen on the default apple 
// dialog boxes. Note: The RGBA values are in the range of 0.0f - 1.0f
// to convert you'll need to devide the standard RGBA value by 255.0f

#import <UIKit/UIKit.h>

#define RGB_TO_CGFLOAT(x) (x/255.0f) 

typedef enum {
    GLOSSY_BUTTON_STYLE_DEFAULT = 0,
    GLOSSY_BUTTON_STYLE_LEFT,
    GLOSSY_BUTTON_STYLE_RIGHT,
    GLOSSY_BUTTON_STYLE_ACTION,
} GlossyButtonStyle;

@interface GlossyButton : UIButton

-(void) setColor:(UIColor *)color;
-(void) setColorHTMLCode:(NSString *)colourCode; //RGB -> e.g. FF0000 is RD
-(void) setColorRed:(CGFloat)red withGreen:(CGFloat)green andBlue:(CGFloat)blue alphaValue:(CGFloat) alpha;
-(void) setTextColour:(UIColor *)textColour withShadowColour:(UIColor *)shadowColour;
-(void) setShadowOffset:(CGSize) offset;
-(void) setCornerRadius:(CGFloat)radius;

@property (nonatomic) GlossyButtonStyle buttonStyle;
@property (nonatomic) CGFloat red;
@property (nonatomic) CGFloat green;
@property (nonatomic) CGFloat blue;
@property (nonatomic) CGFloat alpha;
@property (nonatomic, retain) UIColor *borderColour;

@end
