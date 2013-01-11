//
//  ViewController.m
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

#import "ViewController.h"

@interface ViewController ()

- (IBAction)raidusSliderChanged:(UISlider *)sender;
- (IBAction)shadowSliderChanged:(UISlider *)sender;

@end

@implementation ViewController

@synthesize redButton = _redButton;
@synthesize greenButton = _greenButton;
@synthesize blueButton = _blueButton;
@synthesize radiusSliderLabel = _radiusSliderLabel;
@synthesize shadowSliderLabel = _shadowSliderLabel;

- (void)viewDidLoad {
    [super viewDidLoad];
	[self.redButton setColor:[UIColor redColor]];
    
    [self.greenButton setColorHTMLCode:@"00FF00"];
    [self.greenButton setCornerRadius:10.0f];
    [self.blueButton setColorRed:0.0f withGreen:0.0 andBlue:1.0f alphaValue:1.0f];
    [self.redButton setShadowOffset:CGSizeMake(1.5, 1.5)];
}


- (IBAction)raidusSliderChanged:(UISlider *)sender {
    self.radiusSliderLabel.text = [NSString stringWithFormat:@"%0.f", sender.value];
    [self.greenButton setCornerRadius:sender.value];
    [self.greenButton setNeedsDisplay];
}

- (IBAction)shadowSliderChanged:(UISlider *)sender {
    self.shadowSliderLabel.text = [NSString stringWithFormat:@"%2.f", sender.value];
    [self.redButton setShadowOffset:CGSizeMake(sender.value, sender.value)];
    [self.redButton setNeedsDisplay];
}

- (void)dealloc {
    [_redButton release];
    [_greenButton release];
    [_blueButton release];
    [_radiusSliderLabel release];
    [_shadowSliderLabel release];
    [super dealloc];
}
@end
