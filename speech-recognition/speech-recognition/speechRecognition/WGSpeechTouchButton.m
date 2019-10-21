//
//  WGSpeechTouchButton.m
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import "WGSpeechTouchButton.h"
#import "WGRightImgBtn.h"
@interface WGSpeechTouchButton()
@property(nonatomic, strong) WGRightImgBtn *btnIcon;
@property(nonatomic, strong) UIButton *btnCover;
@end
@implementation WGSpeechTouchButton



#pragma mark - 单例
// 定义全局变量,保证整个进程运行过程中都不会释放
static WGSpeechTouchButton *_instance;

// 保证整个进程运行过程中,只会分配一个内存空间
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    @synchronized(self) {
        if (nil == _instance) {
            _instance = [super allocWithZone:zone];
        }
        return _instance;
    }
}

+ (instancetype)shareInstance
{
    @synchronized(self) {
        
        if (nil == _instance) {
            _instance = [[self alloc] init];
        }
        return _instance;
    }
    
}

- (id)copyWithZone:(NSZone *)zone
{
    return _instance;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    return _instance;
}



-(instancetype)initWithFrame:(CGRect)frame
{
    if(self==[super initWithFrame:frame])
    {
        [self setupUI];
    }
    return self;
}


-(void)layoutSubviews{
    [super layoutSubviews];
    self.btnIcon.frame = CGRectMake((self.frame.size.width-200*kFixRaxW)/2, (self.frame.size.height-32*kFixRax)/2, 200*kFixRaxW, 32*kFixRax);
    self.btnIcon.titleLabel.font = [UIFont systemFontOfSize:13*kFixRaxW];
    
    self.btnCover.frame=self.bounds;
}

-(void)setupUI{
    self.backgroundColor = WGColorHex(0xFFF6F6F6);
    
    self.btnIcon = [[WGRightImgBtn alloc]initWithSpace:7*kFixRaxW];
    [self addSubview:self.btnIcon];
    self.btnIcon.frame=self.bounds;
    self.btnIcon.imgLeft=31*kFixRaxW;
    [self.btnIcon setImage:IMGWithName(@"luyin") forState:UIControlStateNormal];
    [self.btnIcon setTitle:@"按住  说出你要的宝贝" forState:UIControlStateNormal];
    [self.btnIcon setTitleColor:WGColorHex(0x666666) forState:UIControlStateNormal];
    [self.btnIcon.layer setCornerRadius:16*kFixRax];
    [self.btnIcon setClipsToBounds:true];
    [self.btnIcon setBackgroundColor:WGColorHex(0xFFFfff)];
    
    //[XDTool wg_shadowWithViewOrigView:self.btnIcon contetnView:self shadowOffset:CGSizeMake(6*kFixRaxW, 6*kFixRaxW) shadowOpacity:0.04 shadowRadius:0 shadowColor:[UIColor blackColor]];
    
    
    self.btnCover = [UIButton new];
    [self addSubview:self.btnCover];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
    longPress.minimumPressDuration = 0.01;
    [self.btnCover addGestureRecognizer:longPress];
}


#pragma warning - 保证整个过程,两个代理各自只能调用一次
- (void)longPress:(UILongPressGestureRecognizer *)gestureRecognizer {
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
    
        [self buttonTouchDown];
    } else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        /*
        NSLog(@"手势位置发生变化");
        CGPoint point = [gestureRecognizer locationInView:self];
        if (![self.layer containsPoint:point]) {
            [self buttonTouchCancel];
        }
         */
    } else if (gestureRecognizer.state == UIGestureRecognizerStateEnded){
        //NSLog(@"结束手势事件");
        [self buttonTouchCancel];
    } else if (gestureRecognizer.state == UIGestureRecognizerStateFailed){
        //NSLog(@"无法识别的手势");
    }
}


-(void)buttonTouchDown{
    [self.btnIcon setBackgroundColor: WGColorHex(0xdddddd)];
    [self.btnIcon setImage:IMGWithName(@"luyin") forState:UIControlStateNormal];
    [self.btnIcon setTitle:@"松开  搜索你的宝贝" forState:UIControlStateNormal];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(touchBegin)]) {
        [self.delegate touchBegin];
    }
}

-(void)buttonTouchCancel{
    [self.btnIcon setBackgroundColor:WGColorHex(0xFFFffff)];
    [self.btnIcon setImage:IMGWithName(@"luyin") forState:UIControlStateNormal];
    [self.btnIcon setTitle:@"按住  说出你要的宝贝" forState:UIControlStateNormal];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(touchOutCancel)]) {
        [self.delegate touchOutCancel];
    }
}
@end
