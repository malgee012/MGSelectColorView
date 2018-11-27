//
//  MGSelectColorView.h
//  MGSelectColorView
//
//  Created by maling on 2018/11/6.
//  Copyright © 2018 maling. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MGSelectColorView;
@protocol MGSelectColorViewDelegate <NSObject>

- (void)selectColorView:(MGSelectColorView *)colorView color:(UIColor *)currentColor;

@end
@interface MGSelectColorView : UIView

@property (nonatomic, assign) id<MGSelectColorViewDelegate> delegate;

+ (instancetype)instanceWithView:(UIView *)view;

@end

NS_ASSUME_NONNULL_END
