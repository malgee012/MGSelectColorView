//
//  MGValveView.m
//  MGSelectColorView
//
//  Created by maling on 2018/11/6.
//  Copyright © 2018 maling. All rights reserved.
//

#import "MGValveView.h"

/** 角度换算弧度 π */
#define MGAngleToRadian(angle)  (M_PI * angle / 180.0 )
@implementation MGValveView

+ (instancetype)valveView:(UIView *)view
{
    MGValveView *valve = [[MGValveView alloc] init];
    
    [view addSubview:valve];
    
    return valve;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self.frame = CGRectMake(0, 0, 50, 50);
        
        self.layer.cornerRadius = 25;
        
        self.layer.masksToBounds = YES;
        
        self.backgroundColor = [UIColor redColor];
        
        self.layer.borderColor = [UIColor whiteColor].CGColor;
        
        self.layer.borderWidth = 4;
        
    
        UIView *point = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 2, 2)];
        point.centerX = self.centerX;
        point.centerY = self.centerY;
        point.layer.cornerRadius = 1;
        point.layer.masksToBounds = YES;
        point.backgroundColor = [UIColor redColor];
        [self addSubview:point];
        
    }
    return self;
}

+ (CGPoint)valveTheCenterWithCircleRadius:(CGFloat)circleRadius moveAngle:(CGFloat)moveAngle point:(CGPoint)point centerPoint:(CGPoint)centerPoint
{
    CGPoint center = CGPointZero;
    
    
    CGFloat x = sin(MGAngleToRadian(moveAngle)) * circleRadius;
    
    CGFloat y = cos(MGAngleToRadian(moveAngle)) * circleRadius;
    
    if (point.x <= centerPoint.x)
    {
        center.x =  centerPoint.x - x;
    }
    else if (point.x > centerPoint.x)
    {
        center.x =  centerPoint.x + x;
    }
    
    center.y = centerPoint.y - y;
    
    return center;
}

+ (UIColor *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image imageWidth:(CGFloat)imageWidth
{
    
    //    判断给定的点是否被一个CGRect包含
    if (!CGRectContainsPoint(CGRectMake(0.0f, 0.0f, image.size.width, image.size.height), point)) {
        return nil;
    }
    
    //    trunc（n1,n2），n1表示被截断的数字，n2表示要截断到那一位。n2可以是负数，表示截断小数点前。注意，TRUNC截断不是四舍五入。
    //    TRUNC(15.79)---15
    //    trunc(15.79,1)--15.7
    
    NSInteger pointX = trunc(point.x);
    
    NSInteger pointY = trunc(point.y);
    
    CGImageRef cgImage = image.CGImage;
    
    NSUInteger width = imageWidth;
    
    NSUInteger height = imageWidth;
    
    //    创建色彩标准
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    int bytesPerPixel = 4;
    
    int bytesPerRow = bytesPerPixel * 1;
    
    NSUInteger bitsPerComponent = 8;
    
    unsigned char pixelData[4] = { 0, 0, 0, 0 };
    
    CGContextRef context = CGBitmapContextCreate(pixelData,
                                                 1,
                                                 1,
                                                 bitsPerComponent,
                                                 bytesPerRow,
                                                 colorSpace,
                                                 kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    
    CGContextTranslateCTM(context, -pointX, pointY-(CGFloat)height);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, (CGFloat)width, (CGFloat)height), cgImage);
    CGContextRelease(context);
    
    CGFloat red   = (CGFloat)pixelData[0] / 255.0f;
    CGFloat green = (CGFloat)pixelData[1] / 255.0f;
    CGFloat blue  = (CGFloat)pixelData[2] / 255.0f;
    CGFloat alpha = (CGFloat)pixelData[3] / 255.0f;
    

    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorAtPixel:(CGPoint)point withImage:(UIImage *)image 
{
   return [self colorAtPixel:point withImage:image imageWidth:image.size.width];
}


@end
