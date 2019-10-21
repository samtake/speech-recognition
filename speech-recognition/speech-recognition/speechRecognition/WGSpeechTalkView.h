//
//  WGSpeechTalkView.h
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "WGThreeWaveView.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGSpeechTalkView : UIView
@property(nonatomic, copy) NSString *resultString;
@property(nonatomic, strong) WGThreeWaveView *threeWave;
@property(nonatomic, strong) UILabel *lbUnGetSource;
-(void)startAnimate;
@end

NS_ASSUME_NONNULL_END
