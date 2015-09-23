//
//  PicScrollViewController.h
//
//  Created by systemexception on 3/6/15.
//  Copyright (c) 2015 todotodoo@163.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicScrollViewController : UIViewController <UIScrollViewDelegate> {
    UIScrollView *scrollView;
    UIPageControl *pageControl;
}

@end

