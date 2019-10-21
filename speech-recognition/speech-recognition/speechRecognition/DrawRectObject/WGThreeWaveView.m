//
//  WGThreeWaveView.m
//  weGood
//
//  Created by 黄龙山 on 2019/8/29.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import "WGThreeWaveView.h"
#import "WaveView.h"
#import "UIView+SetRect.h"
@interface WGThreeWaveView()
@property(nonatomic, strong) WaveView *WaveOne;
@property(nonatomic, strong) WaveView *WaveTwo;
@property(nonatomic, strong) WaveView *WaveThree;
@end

@implementation WGThreeWaveView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}

-(void)setupUI{
    
    self.layer.masksToBounds = YES;
    
    
    // WaveOne
    {
        
        WaveView *WaveOne = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, self.height)];
        WaveOne.phase     = 7.5f;
        WaveOne.waveCrest = 10.f;
        WaveOne.waveCount = 2;
        WaveOne.type      = kStrokeWave;
        self.WaveOne=WaveOne;
        [self addSubview:WaveOne];
        {
            DrawingStyle *strokeStyle = [DrawingStyle new];
            strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[WGColorHex(0xFFFF94A9) colorWithAlphaComponent:1.0f]];
            strokeStyle.lineWidth     = 2.0f;
            WaveOne.strokeStyle      = strokeStyle;
            
        }
    }
    
    
    // WaveTwo
    {
        WaveView *WaveTwo = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, self.height)];
        WaveTwo.phase     = 5.f;
        self.WaveTwo=WaveTwo;
        WaveTwo.waveCrest = 15.f;
        WaveTwo.waveCount = 2;
        WaveTwo.type      = kStrokeWave;
        [self addSubview:WaveTwo];
        {
            DrawingStyle *strokeStyle = [DrawingStyle new];
            strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[WGColorHex(0xFFFF94A9) colorWithAlphaComponent:1.0f]];
            strokeStyle.lineWidth     = 2.0f;
            WaveTwo.strokeStyle      = strokeStyle;
            
        }
    }
    
    // WaveThree
    {
        WaveView *WaveThree = [[WaveView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 2, self.height)];
        WaveThree.phase     = 0.f;
        self.WaveThree=WaveThree;
        WaveThree.waveCrest =17.f;
        WaveThree.waveCount = 2;
        WaveThree.type      = kStrokeWave;
        [self addSubview:WaveThree];
        {
            DrawingStyle *strokeStyle = [DrawingStyle new];
            strokeStyle.strokeColor   = [DrawingColor colorWithUIColor:[WGColorHex(0xFFFF4F72) colorWithAlphaComponent:1.0f]];
            strokeStyle.lineWidth     = 2.0f;
            WaveThree.strokeStyle      = strokeStyle;
            
        }
    }
    
    [self readyToBegin];
}


- (void)readyToBegin {
    
    UIView *waveOne   = self.WaveOne;
    UIView *waveTwo   = self.WaveTwo;
    UIView *waveThree = self.WaveThree;
    
    [waveOne.layer   removeAllAnimations];
    [waveTwo.layer   removeAllAnimations];
    [waveThree.layer removeAllAnimations];
    
    waveOne.x   = 0.f;
    waveTwo.x   = 0.f;
    waveThree.x = 0.f;
    
    [self doAnimation];
}

- (void)doAnimation {
    
    {
        UIView *waveView = self.WaveOne;
        [UIView animateWithDuration:2.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
    
    {
        UIView *waveView = self.WaveTwo;
        [UIView animateWithDuration:4.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
    
    {
        UIView *waveView = self.WaveThree;
        [UIView animateWithDuration:6.f
                              delay:0
                            options:UIViewAnimationOptionRepeat | UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             
                             waveView.x = -Width;
                             
                         } completion:nil];
    }
}

- (void)changeAnimate{
    self.WaveOne.waveCrest = 15.f;
    self.WaveOne.waveCount = 4;
    
    self.WaveTwo.waveCrest = 17.f;
    self.WaveTwo.waveCount = 4;
    
    self.WaveThree.waveCrest = 25.f;
    self.WaveThree.waveCount = 4;
    
    [self readyToBegin];
}

@end
