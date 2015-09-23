//
//  PicScrollViewController.m
//
//  Created by systemexception on 3/6/15.
//  Copyright (c) 2015 todotodoo@163.com. All rights reserved.
//

#import "PicScrollViewController.h"

@interface PicScrollViewController () {
    NSMutableArray *imgArray;
    NSInteger curPage;
    UIImageView *firstView;
    UIImageView *secondView;
    UIImageView *lastView;
}
@end

@implementation PicScrollViewController

- (void)scrollToNextPage:(id)sender {
    NSInteger pageNum = pageControl.currentPage;
    CGSize viewSize = scrollView.frame.size;
    
    CGRect rect = CGRectMake((pageNum + 2) * viewSize.width, 0, viewSize.width, viewSize.height);
    [scrollView scrollRectToVisible:rect animated:NO];
    pageNum++;
    
    if (pageNum == imgArray.count) {
        CGRect newRect = CGRectMake(viewSize.width, 0, viewSize.width, viewSize.height);
        [scrollView scrollRectToVisible:newRect animated:NO];
    }
}


- (void)pageTurn:(UIPageControl *)sender {
    NSInteger pageNum = pageControl.currentPage;
    CGSize viewSize = scrollView.frame.size;
    [scrollView setContentOffset:CGPointMake((pageNum + 1) * viewSize.width, 0)];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)view {
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat pageHeight = scrollView.frame.size.height;
    
    NSInteger currentPage = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    switch (currentPage) {
        case 0://向左滑动
            if (curPage <= 0) {
                curPage = imgArray.count - 1;
                
                [firstView setImage:[imgArray objectAtIndex:imgArray.count - 2]];
                [secondView setImage:[imgArray lastObject]];
                [lastView setImage:[imgArray firstObject]];
            } else if (curPage == 1) {
                curPage = 0;
                [firstView setImage:[imgArray lastObject]];
                [secondView setImage:[imgArray objectAtIndex:curPage]];
                [lastView setImage:[imgArray objectAtIndex:curPage + 1]];
            } else {
                curPage--;
                [firstView setImage:[imgArray objectAtIndex:curPage - 1]];
                [secondView setImage:[imgArray objectAtIndex:curPage]];
                [lastView setImage:[imgArray objectAtIndex:(curPage + 1) % imgArray.count]];
            }
            
            break;
        case 1://当前页，保持不变
            break;
        case 2://向右滑动
            if (curPage >= imgArray.count - 1) {
                curPage = 0;
                
                [firstView setImage:[imgArray lastObject]];
                [secondView setImage:[imgArray firstObject]];
                [lastView setImage:[imgArray objectAtIndex:(curPage + 1) % imgArray.count]];
            } else {
                curPage++;
                [firstView setImage:[imgArray objectAtIndex:curPage - 1]];
                [secondView setImage:[imgArray objectAtIndex:curPage]];
                [lastView setImage:[imgArray objectAtIndex:(curPage + 1) % imgArray.count]];
            }

            break;
        default:
            break;
    }
    
    //保持scrollView在中间的那个subView中
    [scrollView scrollRectToVisible: CGRectMake(pageWidth, 0, pageWidth, pageHeight) animated:NO];
    
    //根据curPage更新control的当前页
    pageControl.currentPage = curPage;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    imgArray = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"5.png"], [UIImage imageNamed:@"6.png"], nil];
    
    scrollView = [[UIScrollView alloc] init];
    [scrollView setFrame: CGRectMake(0, 20, 380, 240)];
    scrollView.pagingEnabled = true;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate = self;
    
    CGFloat Width = scrollView.frame.size.width;
    CGFloat Height = scrollView.frame.size.height;
    
    
    //alloc三个UIImageView
    firstView = [[UIImageView alloc] initWithImage:[imgArray lastObject]];
    firstView.frame = CGRectMake(0, 0, Width, Height);
    [scrollView addSubview:firstView];

    secondView = [[UIImageView alloc] initWithImage:[imgArray firstObject]];
    secondView.frame = CGRectMake(Width, 0, Width, Height);
    [scrollView addSubview:secondView];
    
    lastView = [[UIImageView alloc] initWithImage:[imgArray objectAtIndex:1]];
    lastView.frame = CGRectMake(Width * 2, 0, Width, Height);
    [scrollView addSubview:lastView];

    
    [scrollView setContentSize:CGSizeMake(Width * 3, Height)];
    [self.view addSubview:scrollView];
    [scrollView scrollRectToVisible:CGRectMake(Width, 0, Width, Height) animated:NO];

    
    //设置pageControl
    CGRect pageControlFrame = CGRectMake(150, 220, 78, 36);
    pageControl = [[UIPageControl alloc] initWithFrame:pageControlFrame];
    
    pageControl.numberOfPages = imgArray.count;
    
    [pageControl setBounds:CGRectMake(0, 0, 16 * (pageControl.numberOfPages - 1), 16)];
    [pageControl.layer setCornerRadius:8];
    
    
    pageControl.enabled = YES;
    pageControl.currentPage = 0;
    curPage = 0;
    
    [self.view addSubview:pageControl];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    [pageControl addTarget:self action:@selector(pageTurn:) forControlEvents:UIControlEventValueChanged];
    
//    [NSTimer scheduledTimerWithTimeInterval:2.f target:self selector:@selector(scrollToNextPage:) userInfo:nil repeats:true];
}

@end
