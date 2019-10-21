//
//  WGSpeechTalkView.m
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import "WGSpeechTalkView.h"

@interface WGSpeechTalkView()
@property(nonatomic, strong) UILabel *lbTitle;
@property(nonatomic, strong) NSMutableArray *aryTags;
@property(nonatomic, strong) UILabel *resultStringLabel;
@end

@implementation WGSpeechTalkView

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}


-(void)setupUI{
    self.backgroundColor = [UIColor yellowColor];

    
    _lbUnGetSource = [UILabel new];
    [self addSubview:_lbUnGetSource];
    _lbUnGetSource.font=[UIFont systemFontOfSize:14*kFixRaxW];
    [_lbUnGetSource setTextAlignment:NSTextAlignmentCenter];
    _lbUnGetSource.textColor = WGColorHex(0xFFFF0033);
    _lbUnGetSource.text=@"未监测到语音，请重试";
    [_lbUnGetSource sizeToFit];
    _lbUnGetSource.frame=CGRectMake(0, 28*kFixRax, kScreenWidth, 15*kFixRax);

    
    
    self.resultStringLabel = [UILabel new];
    [self addSubview:self.resultStringLabel];
    self.resultStringLabel.font=[UIFont systemFontOfSize:14*kFixRaxW];
    self.resultStringLabel.textColor = WGColorHex(0xFF333333);
    [self.resultStringLabel setTextAlignment:NSTextAlignmentCenter];
    self.resultStringLabel.frame=CGRectMake(0, 28*kFixRax, kScreenWidth, 15*kFixRax);
    self.resultStringLabel.text=@"你说,我在聆听...";
    
    
    
    _lbTitle = [UILabel new];
    [self addSubview:_lbTitle];
    _lbTitle.font=[UIFont systemFontOfSize:13*kFixRaxW];
    _lbTitle.textColor = WGColorHex(0xFF999999);
    [_lbTitle setTextAlignment:NSTextAlignmentCenter];
    _lbTitle.text=@"- 您可以这样说 -";
    [_lbTitle sizeToFit];
    self.lbTitle.frame=CGRectMake(0, 65*kFixRax, kScreenWidth, 13*kFixRax);
    
    
    _aryTags = [NSMutableArray new];
    [_aryTags removeAllObjects];
    NSArray *titles = @[@"新款限定口红",@"高颜值零食",@"时尚鞋包"];
    
    for (NSString *strTitle in titles) {
        UILabel *tag  = [UILabel new];
        tag.font=[UIFont systemFontOfSize:13*kFixRaxW];
        tag.textColor = WGColorHex(0xFF999999);
        [tag setTextAlignment:NSTextAlignmentCenter];
        tag.text=strTitle;
        [tag sizeToFit];
        [_aryTags addObject:tag];
    }
    
    self.threeWave = [[WGThreeWaveView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_lbTitle.frame)+144*kFixRax, kScreenWidth, 36*kFixRax)];
    [self addSubview:self.threeWave];
    
    [self startAnimate];
}

-(void)startAnimate{
    __weak __typeof(self)weakSelf = self;
    CGFloat lbTitleY = 65*kFixRax;
    Boolean resultLabelHide = false;
    //Boolean lbUnGetSource
    if (!self.lbUnGetSource.isHidden) {
        lbTitleY = 100*kFixRax;
        resultLabelHide=true;
        
    }
    
    self.resultStringLabel.hidden=resultLabelHide;
    
    _lbTitle.frame = CGRectMake(-_lbTitle.frame.size.width, lbTitleY, -_lbTitle.frame.size.width, 20*kFixRaxW);
    [UIView animateWithDuration:1.0 animations:^{
        weakSelf.lbTitle.frame = CGRectMake((kScreenWidth-weakSelf.lbTitle.frame.size.width)/2, lbTitleY, weakSelf.lbTitle.frame.size.width, 20*kFixRaxW);
    }];
    _lbTitle.frame=CGRectMake(0, 65*kFixRax, kScreenWidth, 20*kFixRaxW);
    
    
    

    UIView  *lastView = self.lbTitle;
    for (UILabel *tag in self.aryTags) {
        [tag  removeFromSuperview];
    }
    for (int i=0; i<self.aryTags.count;i++) {
        UILabel *tag = self.aryTags[i];
        tag.hidden=false;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((i*0.5+1.0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            tag.frame = CGRectMake(-tag.frame.size.width, CGRectGetMaxY(lastView.frame)+16*kFixRax, tag.frame.size.width, 15*kFixRaxW);
            [self addSubview:tag];
            [UIView animateWithDuration:0.5 animations:^{
                tag.frame = CGRectMake((strongSelf.frame.size.width-tag.frame.size.width)/2, CGRectGetMaxY(lastView.frame)+16*kFixRax, tag.frame.size.width, 15*kFixRaxW);
            }];
        });
        
        
        lastView = tag;
    }
    
}


-(void)setResultString:(NSString *)resultString{
    _resultString=resultString;
    if (resultString.length==0) {
        self.lbTitle.hidden=false;
        for (UILabel *tag in self.aryTags) {
            tag.hidden=false;
        }
        self.resultStringLabel.text=@"你说,我在聆听...";
    }else{
        self.resultStringLabel.text=resultString;
//        self.lbTitle.hidden=true;
//        for (UILabel *tag in self.aryTags) {
//            tag.hidden=true;
//        }
    }
}
@end
