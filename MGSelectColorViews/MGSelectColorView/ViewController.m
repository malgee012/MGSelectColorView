//
//  ViewController.m
//  MGSelectColorView
//
//  Created by maling on 2018/11/5.
//  Copyright © 2018 maling. All rights reserved.
//

#import "ViewController.h"
#import "MGSelectColorView.h"

@interface ViewController ()<MGSelectColorViewDelegate>


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [MGSelectColorView instanceWithView:self.view].delegate = self;
}

- (void)selectColorView:(MGSelectColorView *)colorView color:(UIColor *)currentColor
{
    
    self.view.backgroundColor = currentColor;
}


@end
