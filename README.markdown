# Glossy Button

This is a drop in replacement for the built in UIButton class that allows the user to specify and RGB colour, corner radius and shadow offset for the button. This will then be rendered in a similar style to the buttons seen on the default apple dialogue boxes.

## ARC Support

Curently ARC is not supported so manual memory management (MMM) must be used. Automatic detection and usage of ARC will be addded to a future release.

## Usage

Create the buttons as normal UI objects then use the colour & corner radius methods to adjust the button appearance:
 
    GlossyButton *greenButton = [[GlossyButton alloc] init];
    GlossyButton *greenButton = [[GlossyButton alloc] init];
    GlossyButton *greenButton = [[GlossyButton alloc] init];

    ...

    [greenButton setColorHTMLCode:@"00FF00"];
    [greenButton setCornerRadius:10.0f];
    [blueButton setColorRed:0.0f withGreen:0.0 andBlue:1.0f alphaValue:1.0f];
    [redButton setShadowOffset:CGSizeMake(1.5, 1.5)];

*Note: RGBA values should be specified int the range of 0.0f - 1.0f* 

## License

See the 'License.txt' file for details
