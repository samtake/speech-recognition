//
//  WGSpeechTouchButton.h
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WGSpeechTouchButtonDelegate <NSObject>

-(void)touchBegin;
-(void)touchOutCancel;

@end

@interface WGSpeechTouchButton : UIView
@property(nonatomic, weak) id<WGSpeechTouchButtonDelegate> delegate;
+ (instancetype)shareInstance;
@end

NS_ASSUME_NONNULL_END
