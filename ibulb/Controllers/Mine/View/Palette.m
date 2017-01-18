//
//  Palette.m
//  调色板
//
//  Created by long on 13-6-18.
//  Copyright (c) 2013年 long. All rights reserved.
//

#import "Palette.h"
#import "HSV.h"
@implementation Palette
@synthesize image;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0 , 0, self.frame.size.width  , self.frame.size.height)];
        
        
        _handel = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        
        _handel.image = [UIImage imageNamed:@"移动按钮"];
        
        _handel.hidden = YES;
        
        [_imageView setImage:[UIImage imageNamed:@"中心圆-0"]];
        
        
        
        [self addSubview:_imageView];
        [self addSubview:_handel];
        
//        v = [[UIView alloc]initWithFrame:CGRectMake(-20, 0, 40, 40)];
//        
//        v.backgroundColor = [UIColor whiteColor];
//        
//        [self addSubview:v];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (void)logTouchInfo:(UITouch *)touch {
    CGPoint locInSelf = [touch locationInView:self];


    float distanceFromCenter = [self distanceFrom:CGPointMake(80, 80) To:locInSelf];
    
    if (distanceFromCenter > 80.f) {
        return;
    }
    
    CGPoint center = CGPointMake(80,80);
    double radius = 80;
    double dx = ABS(locInSelf.x - center.x);
    double dy = ABS(locInSelf.y - center.y);
    double angle = atan(dy / dx);
    if (isnan(angle))
        angle = 0.0;
    
    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
    double saturation = MIN(dist/radius, 1.0);
    
    if (dist < 10)
        saturation = 0; // snap to center
    
    if (locInSelf.x < center.x)
        angle = M_PI - angle;
    
    if (locInSelf.y > center.y)
        angle = 2.0 * M_PI - angle;
    
    //NSLog(@"on click h:%f s:%f", angle, saturation);
    
    HSVType currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);
    
    RGBType rgb = HSV_to_RGB(currentHSV);
    
 
    
    int red = rgb.r * 255;
    
    int green = rgb.g * 255;
    
    int blue = rgb.b * 255;
    
    
//    self.backgroundColor = [UIColor colorWithRed:rgb.r green:rgb.g blue:rgb.b alpha:1];
    
    NSString *hexRedValue =[NSString stringWithFormat:@"%x",red];
    if (hexRedValue.length ==1) hexRedValue = [NSString stringWithFormat:@"0%@",hexRedValue];
    
    NSString *hexGreenValue =[NSString stringWithFormat:@"%x",green];
    if (hexGreenValue.length ==1) hexGreenValue = [NSString stringWithFormat:@"0%@",hexGreenValue];
    
    NSString *hexBlueValue =[NSString stringWithFormat:@"%x",blue];
    if (hexBlueValue.length ==1) hexBlueValue = [NSString stringWithFormat:@"0%@",hexBlueValue];
    
    NSMutableArray *ary = [@[hexRedValue,hexGreenValue,hexBlueValue]mutableCopy];
    

    
    _handel.hidden = NO;
    
    _handel.center = locInSelf;
    
    [self.paletteDelegate changeColor:ary];

}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {

    for(UITouch *touch in event.allTouches) {
        
        
        
        [self logTouchInfo:touch];
    }
}

-(float) distanceFrom:(CGPoint) p1 To:(CGPoint) p2{
    CGFloat xDist = (p1.x - p2.x);
    CGFloat yDist = (p1.y - p2.y);
    float distance = sqrt((xDist * xDist) + (yDist * yDist));
    return distance;
}

- (NSMutableArray*) getPixelColorAtLocation:(CGPoint)point {
    
    self.image = [UIImage imageNamed:@"中心圆-0"];
    
    NSMutableArray *ary = [NSMutableArray array];
    
    CGImageRef inImage = self.image.CGImage;
    // Create off screen bitmap context to draw the image into. Format ARGB is 4 bytes for each pixel: Alpa, Red, Green, Blue
    CGContextRef cgctx = [self createARGBBitmapContextFromImage:inImage];
    if (cgctx == NULL) { return nil;  }
    
    size_t w = CGImageGetWidth(inImage);
    size_t h = CGImageGetHeight(inImage);
    CGRect rect = {{0,0},{w,h}};
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(cgctx, rect, inImage);
    
    // Now we can get a pointer to the image data associated with the bitmap
    // context.
    unsigned char* data = CGBitmapContextGetData (cgctx);
    if (data != NULL) {
        //offset locates the pixel in the data from x,y.
        //4 for 4 bytes of data per pixel, w is width of one row of data.
        @try {
            int offset = 4*((w*round(point.y))+round(point.x));
//            NSLog(@"offset: %d", offset);
//            int alpha =  data[offset];
            int red = data[offset+1];
            int green = data[offset+2];
            int blue = data[offset+3];
            
            self.backgroundColor = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1];
            
            NSString *hexRedValue =[NSString stringWithFormat:@"%x",red];
            if (hexRedValue.length ==1) hexRedValue = [NSString stringWithFormat:@"0%@",hexRedValue];
            
            NSString *hexGreenValue =[NSString stringWithFormat:@"%x",green];
            if (hexGreenValue.length ==1) hexGreenValue = [NSString stringWithFormat:@"0%@",hexGreenValue];
            
            NSString *hexBlueValue =[NSString stringWithFormat:@"%x",blue];
            if (hexBlueValue.length ==1) hexBlueValue = [NSString stringWithFormat:@"0%@",hexBlueValue];
            
            ary = [@[hexRedValue,hexGreenValue,hexBlueValue]mutableCopy];
            

            
//            NSLog(@"offset: %i colors: RGB A %i %i %i  %i",offset,red,green,blue,alpha);
//            color = [UIColor colorWithRed:(red/255.0f) green:(green/255.0f) blue:(blue/255.0f) alpha:(alpha/255.0f)];
        }
        @catch (NSException * e) {
            NSLog(@"%@",[e reason]);
        }
        @finally {
        }
        
    }
    // When finished, release the context
    CGContextRelease(cgctx);
    // Free image data memory for the context
    if (data) { free(data); }
    
    return ary;
}
- (CGContextRef) createARGBBitmapContextFromImage:(CGImageRef) inImage {
    
    CGContextRef    context = NULL;
    CGColorSpaceRef colorSpace;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Get image width, height. We'll use the entire image. Actually both of them returns the same result. CGImageGetWidth(Image.CGImage) returns the Bitmap image width, Image.size.width returns the UIImage width. If you ask about safe/fast, i think first one will be faster, because it comes from ApplicationServices framework and the second one is from UIKit framework. Hope this helps you.
    
    size_t pixelsWide = CGImageGetWidth(inImage);
    size_t pixelsHigh = CGImageGetHeight(inImage);
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (pixelsWide * 4);
    bitmapByteCount     = (bitmapBytesPerRow * pixelsHigh);
    
    // Use the generic RGB color space.
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    if (colorSpace == NULL)
    {
        fprintf(stderr, "Error allocating color space\n");
        return NULL;
    }
    
    // Allocate memory for image data. This is the destination in memory
    // where any drawing to the bitmap context will be rendered.
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        fprintf (stderr, "Memory not allocated!");
        CGColorSpaceRelease( colorSpace );
        return NULL;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    context = CGBitmapContextCreate (bitmapData,
                                     pixelsWide,
                                     pixelsHigh,
                                     8,      // bits per component
                                     bitmapBytesPerRow,
                                     colorSpace,
                                     kCGImageAlphaPremultipliedFirst);
    if (context == NULL)
    {
        free (bitmapData);
        fprintf (stderr, "Context not created!");
    }
    // Make sure and release colorspace before returning
    CGColorSpaceRelease( colorSpace );
    
    return context;
}

@end
