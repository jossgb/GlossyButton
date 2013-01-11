//
//  GlossyButton.m
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

#import "GlossyButton.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h> 

#define BUTTON_RADIUS 3.0

@interface GlossyButton() 
    
-(void) commonInit;
-(void) hesitateUpdate;

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius, GlossyButtonStyle drawingStyle);
void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor); 
void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor);

@property (nonatomic, assign) CGFloat radius;

@end

@implementation GlossyButton

@synthesize red = _red;
@synthesize green = _green;
@synthesize blue = _blue;
@synthesize alpha = _alpha;
@synthesize buttonStyle = _buttonStyle;
@synthesize borderColour = _borderColour;
@synthesize radius = _radius;

#pragma mark Init methods

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    self.buttonStyle = GLOSSY_BUTTON_STYLE_DEFAULT;
    
    [self setTextColour:[UIColor whiteColor] withShadowColour:[UIColor blackColor]];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    _red = RGB_TO_CGFLOAT(5);
    _green = RGB_TO_CGFLOAT(147);
    _blue = RGB_TO_CGFLOAT(255);
    _alpha = RGB_TO_CGFLOAT(255);
    self.borderColour = [UIColor blackColor];
    self.radius = BUTTON_RADIUS;
}

-(void) dealloc {
    [_borderColour release];
    [super dealloc];
}

#pragma mark Custom setters

-(void) setColor:(UIColor *)color {
    [color getRed:&_red green:&_green blue:&_blue alpha:&_alpha];
    [self setNeedsDisplay];
}

-(void) setColorHTMLCode:(NSString *)colourCode {
    NSString *colourString = [colourCode stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange range;
    unsigned int redVal;
    unsigned int greenVal;
    unsigned int blueVal;
    
    if([colourString length] < 6) {
        NSLog(@"GlossyButton error: Unable to set colour code [%@] due to incorrect length", colourCode);
        return;
    }
    
    if([colourString length] == 8) { //0x or 0X prefix on 8
        if([colourString hasPrefix:@"0X"] || [colourString hasPrefix:@"0x"]) {
            colourString = [colourString substringFromIndex:2];
        } else {
            NSLog(@"GlossyButton error: Unable to set colour code [%@] length is 8 but prefix is not 0x or 0X", colourString);
            return;
        }
    } else if ([colourString length] == 7) { //# prefix on 7
        if([colourString hasPrefix:@"#"]) {
            colourString = [colourString substringFromIndex:1];
        } else {
            NSLog(@"GlossyButton error: Unable to set colour code [%@] length is 7 but prefix is not #", colourString);
            return;
        }
    }
    
    if([colourString length] != 6) {
        NSLog(@"GlossyButton error: Unable to set colour code [%@] after stripping due to incorrect length", colourString);
        return;
    }
    
    range.length = 2;
    range.location = 0;
    
    NSString *rstring = [colourString substringWithRange:range];
    
    range.location = 2;
    NSString *gstring = [colourString substringWithRange:range];
    
    range.location = 4;
    NSString *bstring = [colourString substringWithRange:range];
    
    [[NSScanner scannerWithString:rstring] scanHexInt:&redVal];
    [[NSScanner scannerWithString:gstring] scanHexInt:&greenVal];
    [[NSScanner scannerWithString:bstring] scanHexInt:&blueVal];
    
    [self setColorRed:RGB_TO_CGFLOAT(redVal) withGreen:RGB_TO_CGFLOAT(greenVal) andBlue:RGB_TO_CGFLOAT(blueVal) alphaValue:1.0f];
}

- (void) setRed:(CGFloat)red {
    _red = red;
    [self setNeedsDisplay];
}

- (void) setGreen:(CGFloat)green {
    _green = green;
    [self setNeedsDisplay];
}

- (void) setBlue:(CGFloat)blue {
    _blue = blue;
    [self setNeedsDisplay];
}

- (void) setAlpha:(CGFloat)alpha {
    _alpha = alpha;
    [self setNeedsDisplay];
}

-(void) setColorRed:(CGFloat)red withGreen:(CGFloat)green andBlue:(CGFloat)blue alphaValue:(CGFloat) alpha {
    _red = red;
    _green = green;
    _blue = blue;
    _alpha = alpha;
    [self setNeedsDisplay];
}

-(void) setTextColour:(UIColor *)textColour withShadowColour:(UIColor *)shadowColour {
    [self setTitleColor:textColour forState:UIControlStateNormal];
    [self setTitleShadowColor:shadowColour forState:UIControlStateNormal];
}

-(void) setShadowOffset:(CGSize)offset {
    self.titleLabel.shadowOffset = offset;
}

#pragma mark Custom Drawing code



- (void)drawRect:(CGRect)rect {
    UIColor *buttonColour = [UIColor colorWithRed:_red green:_green blue:_blue alpha:_alpha];
    CGFloat buttonHue;
    CGFloat buttonSaturation;
    CGFloat buttonValue;
    CGFloat buttonAlpha;
    
    [buttonColour getHue:&buttonHue saturation:&buttonSaturation brightness:&buttonValue alpha:&buttonAlpha];
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat actualBrightness = buttonValue;
    if (self.state == UIControlStateHighlighted) {
        actualBrightness -= 0.10;
    }   
    
    CGColorRef blackColor = _borderColour.CGColor;
    CGColorRef highlightStart = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.4].CGColor;
    CGColorRef highlightStop = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    CGColorRef outerTop = [UIColor colorWithHue:buttonHue saturation:buttonSaturation brightness:1.0*actualBrightness alpha:buttonAlpha].CGColor;
    CGColorRef outerBottom = [UIColor colorWithHue:buttonHue saturation:buttonSaturation brightness:0.80*actualBrightness alpha:buttonAlpha].CGColor;
    CGColorRef innerTop = [UIColor colorWithHue:buttonHue saturation:buttonSaturation brightness:0.90*actualBrightness alpha:buttonAlpha].CGColor;
    CGColorRef innerBottom = [UIColor colorWithHue:buttonHue saturation:buttonSaturation brightness:0.70*actualBrightness alpha:buttonAlpha].CGColor;
    
    CGFloat outerMargin = 0.5f;
    CGRect outerRect = CGRectInset(self.bounds, outerMargin, outerMargin);            
    CGMutablePathRef outerPath = createRoundedRectForRect(outerRect, self.radius, self.buttonStyle);
    
    CGFloat innerMargin = 1.0f;
    CGRect innerRect = CGRectInset(outerRect, innerMargin, innerMargin);
    CGMutablePathRef innerPath = createRoundedRectForRect(innerRect, self.radius, self.buttonStyle);
    
    CGFloat highlightMargin = 1.0f;
    CGRect highlightRect = CGRectInset(outerRect, highlightMargin, highlightMargin);
    CGMutablePathRef highlightPath = createRoundedRectForRect(highlightRect, self.radius, self.buttonStyle);
    
    
    
    if(!(_red == 1.0f && _green == 1.0f && _blue == 1.0f)) { //Don't draw graident for white

#ifdef SHADOW_ENABLED
        // Draw shadow
        if (self.state != UIControlStateHighlighted) {
            CGColorRef shadowColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5].CGColor;
            CGContextSaveGState(context);
            CGContextSetFillColorWithColor(context, outerTop);
            CGContextSetShadowWithColor(context, CGSizeMake(0, 2), 3.0, shadowColor);
            CGContextAddPath(context, outerPath);
            CGContextFillPath(context);
            CGContextRestoreGState(context);
        }
#endif       
        // Draw gradient for outer path
        CGContextSaveGState(context);
        CGContextAddPath(context, outerPath);
        CGContextClip(context);
        drawGlossAndGradient(context, outerRect, outerTop, outerBottom);
        CGContextRestoreGState(context);
        
        // Draw gradient for inner path
        CGContextSaveGState(context);
        CGContextAddPath(context, innerPath);
        CGContextClip(context);
        drawGlossAndGradient(context, innerRect, innerTop, innerBottom);
        CGContextRestoreGState(context);      
    }
    if ([self backgroundImageForState:UIControlStateNormal]) {
        [[self backgroundImageForState:UIControlStateNormal] drawInRect:rect];
    }
    
    if (self.state != UIControlStateHighlighted) {
        CGContextSaveGState(context);
        CGContextSetLineWidth(context, 4.0);
        CGContextAddPath(context, outerPath);
        CGContextAddPath(context, highlightPath);
        CGContextEOClip(context);
        drawLinearGradient(context, outerRect, highlightStart, highlightStop);
        CGContextRestoreGState(context);
    }
    
    CGContextSaveGState(context);
    CGContextSetLineWidth(context, 1.0);
    CGContextSetStrokeColorWithColor(context, blackColor);
    CGContextAddPath(context, outerPath);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
    
    CFRelease(outerPath);
    CFRelease(innerPath);
    CFRelease(highlightPath);
}

CGMutablePathRef createRoundedRectForRect(CGRect rect, CGFloat radius, GlossyButtonStyle drawingStyle) {    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGFloat xOffset = 1.4f * CGRectGetMidX(rect);
    
    switch(drawingStyle) {
        case GLOSSY_BUTTON_STYLE_ACTION:
            
            CGPathAddLineToPoint(path, NULL, xOffset, CGRectGetMinY(rect));
            CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMidY(rect));
            CGPathAddLineToPoint(path, NULL, xOffset, CGRectGetMaxY(rect));
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
            break;
        case GLOSSY_BUTTON_STYLE_LEFT:
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect) + 0.5f, CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect) + 0.5f, CGRectGetMaxY(rect), 0);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect) + 0.5f, CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect), CGRectGetMaxY(rect), 0);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect) + 0.5f, CGRectGetMinY(rect), radius);
            break;
            
        case GLOSSY_BUTTON_STYLE_RIGHT:
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect) - 0.5f, CGRectGetMaxY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect)  - 0.5f, CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect) - 0.5f, CGRectGetMinY(rect), 0);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect) - 0.5f, CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect), CGRectGetMinY(rect), 0);
            break;
            
        case GLOSSY_BUTTON_STYLE_DEFAULT:
        default:
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect), CGRectGetMaxY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMaxX(rect), CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect), CGRectGetMaxY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMaxY(rect), 
                                CGRectGetMinX(rect), CGRectGetMinY(rect), radius);
            
            CGPathAddArcToPoint(path, NULL, CGRectGetMinX(rect), CGRectGetMinY(rect), 
                                CGRectGetMaxX(rect), CGRectGetMinY(rect), radius);
            break;
    }
    
    CGPathCloseSubpath(path);
    
    return(path);        
}

void drawGlossAndGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef endColor) {
    
    drawLinearGradient(context, rect, startColor, endColor);
    
    CGColorRef glossColor1 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.35].CGColor;
    CGColorRef glossColor2 = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.1].CGColor;
    
    CGRect topHalf = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height/2);
    
    drawLinearGradient(context, topHalf, glossColor1, glossColor2);
    
}

void drawLinearGradient(CGContextRef context, CGRect rect, CGColorRef startColor, CGColorRef  endColor) {
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}

-(void) setCornerRadius:(CGFloat)radius {
    self.radius = radius;
}
#pragma mark View update methods

- (void)hesitateUpdate {
    [self setNeedsDisplay];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesMoved:touches withEvent:event];
    [self setNeedsDisplay];
    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesCancelled:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self setNeedsDisplay];
    [self performSelector:@selector(hesitateUpdate) withObject:nil afterDelay:0.1];
}


@end
