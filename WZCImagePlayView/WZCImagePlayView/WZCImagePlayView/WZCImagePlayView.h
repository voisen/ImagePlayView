//
//  WZCScrollView.h
//  图片轮播器
//
//  Created by 邬志成 on 16/9/2.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WZCImagePlayViewDelegate <NSObject>

/**
 *  图片被点击
 *
 *  @param imageView 被点击的 imageView
 *  @param idx       图片数组中的 idx
 */
- (void)WZCImagePlayViewImageDidClickWithImageView:(UIImageView *)imageView arrayIndex:(NSInteger)idx;

@end

@interface WZCImagePlayView : UIView

/** brief: 间隔时间 (单位 s)*/
@property (nonatomic,assign) NSTimeInterval wzc_intervalTime; // <- default is 3

/** brief:用户拖拽后重启定时器的时间 */
@property (nonatomic,assign)  NSTimeInterval wzc_resetTime;  // <- default is 10

/** brief:imageView content Mode*/
@property (nonatomic,assign) UIViewContentMode wzc_imageViewContentMode; // <- default is UIViewContentModeScaleAspectFit

/** brief:pageControl */
@property (nonatomic,assign) UIPageControl *wzc_pageControl;

/** brief: 图片点击后的事件代理 */
@property (nonatomic,assign) id<WZCImagePlayViewDelegate> wzc_image_delegate;

/** brief: 唯一仅有的构建方法 */
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *>*)images;
- (instancetype)initWithFrame:(CGRect)frame imagesUrlString:(NSArray <NSString *>*)imageUrlStrings placeholderImage:(UIImage *)placeholderImage;

#pragma mark - 下面的代码一定要调用,否则无法实现图片显示及轮播
/** 开始轮播 */
- (void)wzc_imagesBeginWorking;

@end
