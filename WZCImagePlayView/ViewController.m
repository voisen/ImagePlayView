//
//  ViewController.m
//  图片轮播器
//
//  Created by 邬志成 on 16/9/2.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import "ViewController.h"
#import "WZCImagePlayView/WZCImagePlayView.h"

@interface ViewController ()<WZCImagePlayViewDelegate>

/* brief:images */
@property (nonatomic,strong) NSArray *images;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WZCImagePlayView *sv = [[WZCImagePlayView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 250) images:self.images];
    sv.wzc_image_delegate = self;
    sv.wzc_intervalTime = 1.5;
    sv.wzc_resetTime = 3;
    sv.wzc_imageViewContentMode = 0;
    sv.wzc_pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    sv.backgroundColor = [UIColor blackColor];
    [self.view addSubview:sv];
    [sv wzc_imagesBeginWorking];
}

- (void)WZCImagePlayViewImageDidClickWithImageView:(UIImageView *)imageView arrayIndex:(NSInteger)idx{
    
    NSLog(@"%@ --> %ld",imageView,idx);
    
}

- (NSArray *)images{
    
    if (_images) {
        return _images;
    }
    
    _images = @[
                [UIImage imageNamed:@"image_01"],
                [UIImage imageNamed:@"image_02"],
                [UIImage imageNamed:@"image_03"],
                [UIImage imageNamed:@"image_04"]
                ];
    
    return _images;
}

@end
