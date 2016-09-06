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

/** brief:imageUrls */
@property (nonatomic,strong) NSArray *imageUrlStrings;

@end

/*  http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1408/07/c0/37179063_1407421362265_800x600.jpg
    http://img15.3lian.com/2015/f1/111/d/21.jpg
 http://img542.ph.126.net/628N3hbbFOq9uQcDTcPkMg==/2657968205079899331.jpg
 http://i3.s1.dpfile.com/pc/wed/cc16550a87068ad57789a07eee29c54e%28640c480%29/thumb.jpg
 http://i3.s1.dpfile.com/pc/wed/beace58b60543e50e1e7e7d3a8d1d68c%28640c480%29/thumb.jpg
 http://i3.s2.dpfile.com/pc/wed/87a8c4289fa52bf74bc148a4c8da6990%28640c480%29/thumb.jpg
 
 */
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    WZCImagePlayView *sv = [[WZCImagePlayView alloc]initWithFrame:CGRectMake(0, 100, self.view.frame.size.width, 250) imagesUrlString:self.imageUrlStrings placeholderImage:self.images[0]];
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
    
    NSURL *url = [NSURL URLWithString:self.imageUrlStrings[idx]];
    
    [[UIApplication sharedApplication] openURL:url];
    
    
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



- (NSArray *)imageUrlStrings{

    if (_imageUrlStrings) {
        return _imageUrlStrings;
    }

    _imageUrlStrings = @[
                         @"http://img.pconline.com.cn/images/upload/upc/tx/wallpaper/1408/07/c0/37179063_1407421362265_800x600.jpg",
                         @"http://img15.3lian.com/2015/f1/111/d/21.jpg",
                         @"http://img542.ph.126.net/628N3hbbFOq9uQcDTcPkMg==/2657968205079899331.jpg",
                         @"http://i3.s1.dpfile.com/pc/wed/cc16550a87068ad57789a07eee29c54e%28640c480%29/thumb.jpg",
                         @"http://i3.s1.dpfile.com/pc/wed/beace58b60543e50e1e7e7d3a8d1d68c%28640c480%29/thumb.jpg",
                         @"http://i3.s2.dpfile.com/pc/wed/87a8c4289fa52bf74bc148a4c8da6990%28640c480%29/thumb.jpg"
                         ];
    
    return _imageUrlStrings;
}


@end
