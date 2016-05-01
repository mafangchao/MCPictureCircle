//
//  ViewController.m
//  151113-轮播
//
//  Created by apple on 15/11/13.
//  Copyright © 2015年 machao. All rights reserved.
//

#import "ViewController.h"
#define M 5

@interface ViewController ()<UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic ,strong)UIScrollView* scrollView;
//@property (weak, nonatomic) IBOutlet UIPageControl *pageView;
@property (nonatomic ,strong)UIPageControl* pageView;
@property (nonatomic ,strong)NSTimer * timer;
@property (nonatomic ,assign) CGPoint scrollPoinit;
@property (nonatomic ,assign) NSInteger  index;
@end

@implementation ViewController

-(void)setupUI{
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.pageView = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
    self.pageView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2 - 30, [UIScreen mainScreen].bounds.size.height-30);
    [self.view addSubview:self.pageView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    self.scrollView.contentSize=CGSizeMake(self.scrollView.bounds.size.width*(M+2), 0);
    CGFloat imageX=0;
    CGFloat imageY=0;
    CGFloat imageH=self.scrollView.bounds.size.height;
    CGFloat imageW=self.scrollView.bounds.size.width;
    //添加照片多添加了两张
    for (NSInteger i=0; i<M+2; i++) {
        if (i==0) {
            UIImageView *imageView=[[UIImageView alloc ]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
            
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",M]];
            
            [self.scrollView addSubview:imageView];
        }else if(i==M+1) {
            UIImageView *imageView=[[UIImageView alloc ]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            imageX=imageW*i;
            imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
            
            imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02d",1]];
            
            [self.scrollView addSubview:imageView];
        } else {
        UIImageView *imageView=[[UIImageView alloc ]init];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
        imageX=imageW*i;
        imageView.frame=CGRectMake(imageX, imageY, imageW, imageH);
        
        imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"img_%02ld",i]];
        
        [self.scrollView addSubview:imageView];
        }
    }
    self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width, 0);
    self.scrollView.pagingEnabled=YES;
    // 3.隐藏水平滚动条
    self.scrollView.showsHorizontalScrollIndicator = NO;
    // 4.隐藏垂直滚动条
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.pageView.pageIndicatorTintColor=[UIColor purpleColor];
    self.pageView.numberOfPages=M;
    self.pageView.currentPage=0;
    self.pageView.currentPageIndicatorTintColor=[UIColor blueColor];
    self.scrollView.delegate=self;
    [self timer];
   
}
//当前的拖动位置
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat maxW = self.scrollView.bounds.size.width;
    NSInteger page = (self.scrollView.contentOffset.x +maxW*0.5)/maxW;
    self.index = page;
    if (self.scrollView.contentOffset.x > maxW *(M + 0.5))
        page = 1;
    else if (self.scrollView.contentOffset.x <maxW*0.5)
        page = M;
    self.pageView.currentPage = page-1;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.timer invalidate];
    self.timer=nil;
}

//降速结束后调用
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self test];
    CGFloat maxW = self.scrollView.bounds.size.width;
    if (self.index == M+1)
        self.scrollView.contentOffset = CGPointMake(maxW, 0);
    else if (self.index == 0)
        self.scrollView.contentOffset = CGPointMake(maxW *M, 0);
    [self timer];
}
-(NSTimer *)timer{
    if (_timer==nil) {
        _timer=[NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    }
    // 把当前的定时器添加到当前的运行循环中,并指定它为通用模式,这样主线程在执行的时候就可以抽那么一点时间来关注一下我们的定时器
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    
    return _timer;
}
#pragma mark -自动调用方法
-(void)nextPage{
    //获取当前页码
    NSInteger pageCount=self.pageView.currentPage;
        //判断如果页码为4则证明为最后一页
    if (pageCount==M-1) {
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        pageCount=0;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width, 0) animated:YES];
        
    }else{
        pageCount++;
        [self.scrollView setContentOffset:CGPointMake(self.scrollView.bounds.size.width*(pageCount+1), 0) animated:YES];
    }
        self.pageView.currentPage = pageCount;
}
#pragma mark - 自动调用代码
-(void)test{
    
    if (self.scrollView.contentOffset.x >self.scrollView.frame.size.width*(M)) {
        self.pageView.currentPage=0;
        self.scrollView.contentOffset=CGPointMake(self.scrollView.bounds.size.width, 0);
    }
    if(self.scrollView.contentOffset.x < self.scrollView.frame.size.width*0.5){
         self.pageView.currentPage = M -1;
        self.scrollView.contentOffset=CGPointMake(self.scrollView.bounds.size.width*M, 0);
    }
   
}

@end
