//
//  UIView+Frame.h
//  iOS-Categories (https://github.com/shaojiankui/iOS-Categories)
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIView (Frame)
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;

// shortcuts for positions
@property (nonatomic) CGFloat wgCenterX;
@property (nonatomic) CGFloat wgCenterY;


@property (nonatomic) CGFloat wgTop;
@property (nonatomic) CGFloat wgBottom;
@property (nonatomic) CGFloat wgRight;
@property (nonatomic) CGFloat wgLeft;

@property (nonatomic) CGFloat wgWidth;
@property (nonatomic) CGFloat wgHeight;
@end
