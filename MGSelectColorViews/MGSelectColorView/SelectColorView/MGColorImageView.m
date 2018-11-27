//
//  MGColorImageView.m
//  MGSelectColorView
//
//  Created by maling on 2018/11/9.
//  Copyright © 2018 maling. All rights reserved.
//

#import "MGColorImageView.h"

@implementation MGColorImageView

- (void)setImage:(UIImage *)image
{
    UIImage *temp = [self imageForResizeWithImage:image resize:CGSizeMake(self.frame.size.width, self.frame.size.width)];
    
    [super setImage:temp];
}

/**
 通过上下图文创建self对应像素的image
 
 @param picture 要加载的图片
 @param resize 实际self的大小
 @return 返回self对应像素的大小的image
 */
- (UIImage *)imageForResizeWithImage:(UIImage *)picture resize:(CGSize)resize
{
    CGSize imageSize = resize; //CGSizeMake(25, 25)
    
    /**
     UIGraphicsBeginImageContextWithOptions(CGSize size, BOOL opaque, CGFloat scale);
     1.参数size为新创建的位图上下文的大小
     2.opaque—透明开关，如果图形完全不用透明，设置为YES以优化位图的存储
     3.scale—–缩放因子 iPhone 4是2.0，其他是1.0;实际上设为0后，系统就会自动设置正确的比例了。
     */
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO,0.0);
    
    CGRect imageRect = CGRectMake(0.0, 0.0, imageSize.width, imageSize.height);
    
    [picture drawInRect:imageRect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    return image;
}

@end
