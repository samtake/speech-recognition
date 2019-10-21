//
//  ViewController.m
//  speech-recognition
//
//  Created by 黄龙山 on 2019/8/24.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import "ViewController.h"
#import "WGSpeechTouchButton.h"
#import "WGBaseSpeechRecController.h"
@interface ViewController ()<WGSpeechTouchButtonDelegate,UITextFieldDelegate>
@property(nonatomic, strong) UITextField *tfSpeech;
@property(nonatomic, strong) WGSpeechTouchButton *btnSpeechTouch;
@property(nonatomic, strong) WGBaseSpeechRecController *speechVC;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextField *tfSpeech = [[UITextField alloc]initWithFrame:CGRectMake((kScreenWidth-300)/2, 150, 300, 50)];
    tfSpeech.backgroundColor = [UIColor yellowColor];
    tfSpeech.textColor=[UIColor redColor];
    tfSpeech.delegate=self;
    tfSpeech.placeholder=@"这是占位。。";
    [self.view addSubview:tfSpeech];
    
    
    //键盘的弹起监听
    NSNotificationCenter * center=[NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //键盘收起监听
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

#pragma mark - 键盘的弹起监听
-(void)keyboardWillChange:(NSNotification *)note
{
    //获取键盘弹起时的frame值
    CGRect rect=[note.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    //获取键盘弹起时的Y值
    CGFloat keyboardY=rect.origin.y;
    //NSLog(@"keyboardY=%f",keyboardY);
    _btnSpeechTouch=[WGSpeechTouchButton shareInstance];
    _btnSpeechTouch.delegate=self;
    _btnSpeechTouch.frame=CGRectMake(0, keyboardY-44*kFixRax, kScreenWidth, 44*kFixRax);
    
    
    Boolean isContainTouch = false;
    for (UIView *subView in self.view.subviews) {
        if (subView==self.btnSpeechTouch) {
            isContainTouch=true;
        }
    }
    if (!isContainTouch) {
        [self.view addSubview:self.btnSpeechTouch];
    }
    __weak __typeof(self)weakSelf = self;
    [UIView animateWithDuration:1.5 animations:^{
        weakSelf.btnSpeechTouch.frame=CGRectMake(0, keyboardY-44*kFixRax, kScreenWidth, 44*kFixRax);
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    /**
    //获取键盘的高度
    CGRect rect=[notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    CGFloat keyboardY=rect.origin.y;
    NSLog(@"keyboardY=%f",keyboardY);
     ***/
    _btnSpeechTouch=[WGSpeechTouchButton shareInstance];
    _btnSpeechTouch.delegate=self;
    if(_btnSpeechTouch){
        _btnSpeechTouch.frame=CGRectMake(0, kScreenHeight-44*kFixRax, kScreenWidth, 44*kFixRax);
    }
}

#pragma mark - 语音识别
-(void)touchBegin{
    [self speechRecognition];
    [self.speechVC buttonTouchBegin];
}
-(void)touchOutCancel{
    [self.speechVC buttonTouchCancel];
}



-(void)speechRecognition{
    __weak __typeof(self)weakSelf = self;
    if (!_speechVC) {
        _speechVC = [WGBaseSpeechRecController new];
        [self addChildViewController:_speechVC];
        __weak __typeof(self)weakSelf = self;
        _speechVC.blockRequestWithResult = ^(NSString * _Nonnull resultStr) {
            if (resultStr.length>0) {
                weakSelf.tfSpeech.text=resultStr;
                //todo something
            }
        };
    }
    [self.speechVC.view setHidden:false];
    [self.view addSubview:self.speechVC.view];
    _speechVC.view.frame = CGRectMake(0, 50, kScreenWidth, 0);
    
    
    [UIView animateWithDuration:0.3 animations:^{
        weakSelf.speechVC.view.frame = CGRectMake(0, 50, kScreenWidth, self.btnSpeechTouch.frame.origin.y-50);
    }];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
