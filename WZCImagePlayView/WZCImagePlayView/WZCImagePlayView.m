//
//  WZCScrollView.m
//  图片轮播器
//
//  Created by 邬志成 on 16/9/2.
//  Copyright © 2016年 邬志成. All rights reserved.
//

#import "WZCImagePlayView.h"

@interface WZCImagePlayView()<UIScrollViewDelegate>

/* brief:scrollerView */
@property (nonatomic,assign) UIScrollView *scrollView;

/* brief:定时器 */
@property (nonatomic,strong) NSTimer *picTimer;

/* brief:分页指示器 */
@property (nonatomic,assign) UIPageControl *pageControl;

/* brief:images */
@property (nonatomic,strong) NSArray *imagesArray;

@end

@implementation WZCImagePlayView

#pragma mark - 初始化操作

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray <UIImage *>*)images{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        self.imagesArray = images;
        {
            UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
            scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * (self.imagesArray.count + 2), 0);
            scrollView.showsHorizontalScrollIndicator = NO;
            scrollView.showsVerticalScrollIndicator = NO;
            scrollView.pagingEnabled = YES;
            scrollView.delegate = self;
            _scrollView = scrollView;
            [self addSubview:self.scrollView];
        }
        
        {
            UIPageControl *pageControl = [[UIPageControl alloc]init];
            CGSize pageControlSize = [pageControl sizeForNumberOfPages:images.count];
            pageControl.frame = CGRectMake(frame.size.width - pageControlSize.width - 10, frame.size.height - pageControlSize.height, pageControlSize.width,pageControlSize.height);
            pageControl.currentPageIndicatorTintColor = [UIColor redColor];
            pageControl.pageIndicatorTintColor = [UIColor brownColor];
            pageControl.numberOfPages = self.imagesArray.count;
            pageControl.currentPage = 0;
            pageControl.hidesForSinglePage = YES;
            _pageControl = pageControl;
            [self addSubview:self.pageControl];
            self.wzc_intervalTime = 3;
            self.wzc_resetTime = 10;
            self.wzc_imageViewContentMode = UIViewContentModeScaleAspectFit;
        }
        
    }
    return self;
}

#pragma mark - 启动

- (void)wzc_imagesBeginWorking{
    
    [self startTimer];
    
    [self loadImages];
    
}

#pragma mark - 定时器停止操作

- (void)stopTimer{
    
    [self.picTimer invalidate];
    
    self.picTimer = nil;
    
}

#pragma mark - 开始定时器

- (void)startTimer{
    
    if ([self.picTimer isValid]) {
        [self stopTimer];
    }
    
    NSTimer *picTimer = [NSTimer timerWithTimeInterval:self.wzc_intervalTime target:self selector:@selector(changeScrollViewContentOffset) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:picTimer forMode:NSRunLoopCommonModes];
    
    _picTimer = picTimer;
    
}

#pragma mark - 定时器循环函数

- (void)changeScrollViewContentOffset{
    
    CGPoint contentOffset = self.scrollView.contentOffset;
    
    contentOffset.x += self.scrollView.frame.size.width;
    
    if (contentOffset.x > self.scrollView.frame.size.width * (self.imagesArray.count + 1)) {
        contentOffset.x = self.scrollView.frame.size.width;
        self.scrollView.contentOffset = contentOffset;
        contentOffset.x += self.scrollView.frame.size.width;
    }
    
    if (contentOffset.x == 0) {
        contentOffset.x = self.scrollView.frame.size.width * (self.imagesArray.count - 1);
        self.scrollView.contentOffset = contentOffset;
        contentOffset.x += self.scrollView.frame.size.width;
    }
    
    NSInteger curPage = contentOffset.x / self.scrollView.frame.size.width;
    
    if (curPage == 1) {
        curPage = self.imagesArray.count - 1;
    }else if (curPage == self.imagesArray.count + 1) {
        curPage = 0;
    }else{
        
        curPage -= 1;
        
    }
    
    
    self.pageControl.currentPage = curPage % self.imagesArray.count;
    
    [self.scrollView setContentOffset:contentOffset animated:YES];
    
}

#pragma mark - 加载图片
- (void)loadImages{
    
    CGFloat img_W = self.scrollView.frame.size.width;
    CGFloat img_H = self.scrollView.frame.size.height;
    for (int i = 0; i < self.imagesArray.count + 2; i ++) {
        @autoreleasepool {
            CGFloat img_X = i * img_W;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(img_X, 0, img_W, img_H)];
            if (i == 0) {
                imageView.image = [self.imagesArray lastObject];
            }else{
                imageView.image = self.imagesArray[(i - 1) % self.imagesArray.count];
            }
            
            imageView.contentMode = self.wzc_imageViewContentMode;
            
            if (self.wzc_image_delegate) {
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidChick:)];
                [imageView addGestureRecognizer:tap];
                imageView.userInteractionEnabled = YES;
            }
            
            [self.scrollView addSubview:imageView];
        }
    }
    
    self.scrollView.contentOffset = CGPointMake(self.scrollView.frame.size.width, 0);
    
    if (self.wzc_image_delegate) {
        self.scrollView.userInteractionEnabled = YES;
    }
}


- (void)imageViewDidChick:(UITapGestureRecognizer *)tap{
    
    if ([self.wzc_image_delegate respondsToSelector:@selector(WZCImagePlayViewImageDidClickWithImageView:arrayIndex:)]) {
        
        UIImageView *imageView = (UIImageView*)tap.view;
        
        [self.wzc_image_delegate WZCImagePlayViewImageDidClickWithImageView:imageView arrayIndex:[self.imagesArray indexOfObject:imageView.image]];
    }
}

#pragma  mark -ScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    [self stopTimer];
    
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    self.picTimer = [NSTimer timerWithTimeInterval:self.wzc_resetTime target:self selector:@selector(startTimer) userInfo:nil repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:self.picTimer forMode:NSRunLoopCommonModes];
    [scrollView removeObserver:self forKeyPath:@"contentOffset"];
    
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self changePageWithContentOffset:scrollView.contentOffset];
    
}

/**
 *  拖拽改变页码
 *
 *  @param contentOffset
 */


- (void)changePageWithContentOffset:(CGPoint)contentOffset{
    
    NSInteger curPage = contentOffset.x / self.scrollView.frame.size.width;
    
    if (curPage == 0) {
        
        curPage = self.imagesArray.count - 1;
        
    } else if (curPage > self.imagesArray.count) {
        
        curPage = 0;
        
    }else{
        
        curPage -= 1;
        
    }
    self.pageControl.currentPage = curPage;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    CGPoint contentOffset = [change[@"new"] CGPointValue];
    CGPoint contentOffset_old = [change[@"old"] CGPointValue];
    if (contentOffset.x <= self.scrollView.frame.size.width && contentOffset_old.x <= self.scrollView.frame.size.width) {
        
        self.scrollView.contentOffset = CGPointMake(contentOffset.x + self.scrollView.frame.size.width * self.imagesArray.count, 0);
        
    }
    
    if (contentOffset.x >= self.scrollView.frame.size.width * self.imagesArray.count) {
        
        self.scrollView.contentOffset = CGPointMake(((NSInteger)contentOffset.x % (NSInteger)self.scrollView.frame.size.width), 0);
        
    }
    
    
}

- (UIPageControl *)wzc_pageControl{
    
    return self.pageControl;
}

@end
