//
//  MGSelectColorView.m
//  MGSelectColorView
//
//  Created by maling on 2018/11/6.
//  Copyright © 2018 maling. All rights reserved.
//

#import "MGSelectColorView.h"
#import "MGValveView.h"
#include <math.h>

/** colorViewWidth 宽度*/
#define MGColorWidth (MGSCREENWIDTH * 1)
/** color 圆环是半径的倍速 可修改*/
#define MGMultiple 0.32    // 0.32
/** 圆形半径 */
#define MGCornerRadius (MGColorWidth * MGMultiple)     // 0.32
/** 圆形外边距 */
#define MGOutsideMargin (MGColorWidth * (0.5 - MGMultiple))     // 0.18
/** 小球圆心距离大圆中心在 X 方向的距离 */
#define MGViewXMargin(angle) (cosf(MGAngleToRadian(angle)) * MGCornerRadius)
/** 内容视图距离顶部的距离 */
#define MGContentViewTopMargin 0
/** 角度换算弧度 π */
#define MGAngleToRadian(angle)  (M_PI * angle / 180.0 )
/** 弧度换算角度 ° */
#define MGRadianToAngle(radian) (180.0 * radian / M_PI)


@interface MGSelectColorView ()

/** 圆心point */
@property (nonatomic, assign, readonly) CGPoint centerPoint;
/** 默认位置 */
@property (nonatomic, assign, readonly) CGPoint originPoint;
/** 盛放环形颜色的view */
@property (nonatomic, strong, nonnull) UIView *bgContentView;
/** 指示器圆球view */
@property (nonatomic, strong) UIView *valveView;
/** 指示器圆球的变动的 rect */
@property (nonatomic, assign) CGRect valveRect;
/** 标记初始触摸是否在指示球上 */
@property (nonatomic, assign) BOOL spot;
/** 环形渐变圈 */
@property (nonatomic, strong) UIImageView *colorImageView;


@end
@implementation MGSelectColorView

+ (instancetype)instanceWithView:(UIView *)view
{
    
    MGSelectColorView *instanceView = [[MGSelectColorView alloc] initWithFrame:CGRectMake(0.5 * (MGSCREENWIDTH - MGColorWidth), 100, MGColorWidth, MGColorWidth + MGContentViewTopMargin)];
    
    [view addSubview:instanceView];
    
    return instanceView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{

    self.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
    
    UIView *bgContentView = [[UIView alloc] initWithFrame:CGRectMake(0, MGContentViewTopMargin,
                                                                     self.width, self.height - MGContentViewTopMargin)];
    
    [self addSubview:bgContentView];
    
    self.bgContentView = bgContentView;
    
    [self initializationData];
    
    // 设置 color imageView 背景图
    UIImage *colorImage = [UIImage imageNamed:@"ic_color_pick_circle"];
    UIImageView *colorImageView = [[UIImageView alloc] initWithImage:colorImage];
    colorImageView.frame = CGRectMake(0, 0, MGCornerRadius * 2 + 10, MGCornerRadius * 2 + 10);
    colorImageView.centerX = bgContentView.centerX;
    colorImageView.centerY = bgContentView.centerY;
    self.colorImageView = colorImageView;
    [bgContentView addSubview:colorImageView];
    
//    NSLog(@"初始image  %@  size：%@", NSStringFromCGRect(colorImageView.frame),  NSStringFromCGSize(colorImage.size));
    
//    [self drawAnnularTrack];
    
    self.valveView = [MGValveView valveView:bgContentView];
    
    self.valveView.center = _originPoint;
    
//    NSLog(@"初始的位置>>  %@  ", NSStringFromCGRect(self.valveView.frame));
    
    self.valveRect = self.valveView.frame;
}

- (void)initializationData
{
    _centerPoint = CGPointMake(_bgContentView.center.x, _bgContentView.center.y - MGContentViewTopMargin);
    
    _originPoint = CGPointMake(_centerPoint.x - MGViewXMargin(45) , _centerPoint.y - MGViewXMargin(45));
    
//    CGFloat angle = angleBetweenLines(_originPoint, _centerPoint, CGPointMake(_centerPoint.x, _originPoint.y));
//
//    NSLog(@"初始的两条线的夹角  %f", angle);
}

- (void)drawAnnularTrack
{
    
    UIView *hView = [[UIView alloc] initWithFrame:CGRectMake(0, 0.5 * (_bgContentView.height - 0.5), _bgContentView.width, 0.5)];
    UIView *vView = [[UIView alloc] initWithFrame:CGRectMake( 0.5 * (_bgContentView.width - 0.5), 0, 0.5, _bgContentView.height)];
    hView.backgroundColor = [UIColor blackColor];
    vView.backgroundColor = [UIColor blackColor];
    [self.bgContentView addSubview:hView];
    [self.bgContentView addSubview:vView];

    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(MGOutsideMargin, MGOutsideMargin, MGCornerRadius * 2, MGCornerRadius * 2)];

    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 1;
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = nil;
    layer.path = path.CGPath;

    [self.bgContentView.layer addSublayer:layer];
    
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    point = CGPointMake(point.x, point.y - MGContentViewTopMargin);
    
    BOOL container =  CGRectContainsPoint(self.valveRect, point);

    if (container) {

        self.spot = YES;
        
        [self moveValveViewWithPoint:point];
    }
    else
    {
        self.spot = NO;
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    point = CGPointMake(point.x, point.y + MGContentViewTopMargin);
    
    if (self.spot) [self moveValveViewWithPoint:point];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.spot = NO;
}

- (void)moveValveViewWithPoint:(CGPoint)point
{

    CGFloat angle = angleBetweenLines(point, CGPointMake(_centerPoint.x, _centerPoint.y + MGContentViewTopMargin), CGPointMake(_centerPoint.x, _originPoint.y));
    
    CGPoint currentPoint = [MGValveView valveTheCenterWithCircleRadius:MGCornerRadius moveAngle:angle point:point centerPoint:_centerPoint];
    
    
    if (isnan(currentPoint.x) || isnan(currentPoint.y))
    {
        return;
    }
    else
    {
        self.valveView.center = currentPoint;
    }
    
    _valveRect = CGRectMake(currentPoint.x - self.valveView.width * 0.5, currentPoint.y - self.valveView.height * 0.5, self.valveView.width, self.valveView.height);
    
    
    CGPoint tempPoint = CGPointMake(currentPoint.x - MGOutsideMargin + 5 , currentPoint.y - MGOutsideMargin + 5);
    
    UIColor *selectColor = [MGValveView colorAtPixel:tempPoint withImage:self.colorImageView.image imageWidth: MGCornerRadius * 2 + 10];
    
    self.valveView.backgroundColor = selectColor;
    
    if ([self.delegate respondsToSelector:@selector(selectColorView:color:)]) {
    
        [self.delegate selectColorView:self color:selectColor];
    }
}

/**
 获取两条线的夹角

 @param line1Start 当前移动的点
 @param lineEnd Y 圆心点
 @param line2Start 当前移动点投影到 Y 轴上的点
 @return 夹角
 */
CGFloat angleBetweenLines(CGPoint line1Start, CGPoint lineEnd, CGPoint line2Start)
{
    CGFloat a = lineEnd.x - line1Start.x;
    CGFloat b = lineEnd.y - line1Start.y;
    
    CGFloat c = lineEnd.x - line2Start.x;
    CGFloat d = lineEnd.y - line2Start.y;
    
    CGFloat rads = acos(((a*c) + (b*d)) / ((sqrt(a*a + b*b)) * (sqrt(c*c + d*d))));

    return MGRadianToAngle(rads);
}


@end
