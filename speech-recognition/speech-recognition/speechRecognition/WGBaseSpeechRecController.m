//
//  WGBaseSpeechRecController.m
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#define LoadingText @"正在录音。。。"
#import "WGBaseSpeechRecController.h"
#import "WGSpeechTalkView.h"
#import <Speech/Speech.h>
#import <AVFoundation/AVFoundation.h>

API_AVAILABLE(ios(10.0))
@interface WGBaseSpeechRecController ()<SFSpeechRecognizerDelegate>
@property(nonatomic, strong) UIButton *btnBg;
@property(nonatomic, strong) WGSpeechTalkView *viewTalk;


@property (nonatomic,strong) SFSpeechRecognizer *speechRecognizer;
@property (nonatomic,strong) AVAudioEngine *audioEngine;
@property (nonatomic,strong) SFSpeechRecognitionTask *recognitionTask;
@property (nonatomic,strong) SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
@property(nonatomic, copy) NSString *resultString;
@end

@implementation WGBaseSpeechRecController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self  speechRoot];
    [self setupUI];
}

-(void)btnBgClick{
    [self.view setHidden:true];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


-(void)setupUI{
    
    //上圆角
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.view.bounds;
    maskLayer.path = maskPath.CGPath;
    self.view.layer.mask = maskLayer;
    
    
    _btnBg = [UIButton new];
    [self.view addSubview:_btnBg];
    _btnBg.backgroundColor = [UIColor whiteColor];
    _btnBg.alpha=0.95;
    [_btnBg addTarget:self action:@selector(btnBgClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _viewTalk = [WGSpeechTalkView new];
    _viewTalk.frame = CGRectMake(0, 0, kScreenWidth, 0);
    [self.view addSubview:_viewTalk];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _btnBg.frame=self.view.bounds;
}

#pragma mark - 语音识别
- (void)buttonTouchBegin{
    self.resultString=@"";
    self.viewTalk.resultString=@"";
    /*
    if (self.audioEngine.isRunning) {
        [self startRecording];
    }
     */
    self.viewTalk.lbUnGetSource.hidden=true;
    [self.viewTalk startAnimate];
    [self startRecording];
    
}


- (void)buttonTouchCancel{
    [self endRecording];
    
    self.viewTalk.resultString=self.resultString;
    if(self.resultString.length==0){
        self.viewTalk.lbUnGetSource.hidden=false;
        [self.viewTalk startAnimate];
    }else{
        self.viewTalk.lbUnGetSource.hidden=true;
    }
    
    //2秒钟之后
    __block int timeout = 2;
    __weak __typeof(self)weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(_timer, ^{
        if ( timeout <= 0 )
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //隐藏视图
                weakSelf.view.hidden=true;
                //执行网络请求的block
                if (weakSelf.resultString.length==0) {
                    //展示无法识别
                    return ;
                }else{
                    if (weakSelf.blockRequestWithResult) {
                        weakSelf.blockRequestWithResult(weakSelf.resultString);
                    }
                }
                
            });
        }
        else
        {
            timeout--;
        }
    });
    dispatch_resume(_timer);
    
}


#pragma mark - 结束录音
- (void)endRecording{
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }
    
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
}

#pragma mark - 开始录音
- (void)startRecording{
    
    [self.audioEngine stop];
    if (_recognitionRequest) {
        [_recognitionRequest endAudio];
    }
    
    
    if (_recognitionTask) {
        [_recognitionTask cancel];
        _recognitionTask = nil;
    }
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    NSError *error;
    [audioSession setCategory:AVAudioSessionCategoryRecord error:&error];
    NSParameterAssert(!error);
    [audioSession setMode:AVAudioSessionModeMeasurement error:&error];
    NSParameterAssert(!error);
    [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
    NSParameterAssert(!error);
    
    if (@available(iOS 10.0, *)) {
        _recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
    } else {
        // Fallback on earlier versions
    }
    AVAudioInputNode *inputNode = self.audioEngine.inputNode;
    NSAssert(inputNode, @"录入设备没有准备好");
    NSAssert(_recognitionRequest, @"请求初始化失败");
    _recognitionRequest.shouldReportPartialResults = YES;
    __weak typeof(self) weakSelf = self;
    if (@available(iOS 10.0, *)) {
        
        _recognitionTask = [self.speechRecognizer recognitionTaskWithRequest:_recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            BOOL isFinal = NO;
            if (result) {
                NSString  *resultString = result.bestTranscription.formattedString;
                NSLog(@"resultString=%@",resultString);
                if(resultString.length>0){
                    self.resultString=resultString;
                    self.viewTalk.resultString=self.resultString;
                }
                isFinal = result.isFinal;
                //[strongSelf.viewTalk.threeWave changeAnimate];
            }
            if (error || isFinal) {
                [self.audioEngine stop];
                [inputNode removeTapOnBus:0];
                strongSelf.recognitionTask = nil;
                strongSelf.recognitionRequest = nil;
                NSLog(@"(error || isFinal)=%@",error);
            }
            
        }];
    } else {
        // Fallback on earlier versions
    }
    
    AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
    //在添加tap之前先移除上一个  不然有可能报"Terminating app due to uncaught exception 'com.apple.coreaudio.avfaudio',"之类的错误
    [inputNode removeTapOnBus:0];
    [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf.recognitionRequest) {
            [strongSelf.recognitionRequest appendAudioPCMBuffer:buffer];
        }
    }];
    
    [self.audioEngine prepare];
    [self.audioEngine startAndReturnError:&error];
    NSParameterAssert(!error);
}



#pragma mark - SFSpeechRecognizerDelegate  识别代理
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available API_AVAILABLE(ios(10.0)){
    if (available) {
        NSLog(@"delegate :开始录音");
    }
    else{
        NSLog(@"语音识别不可用");
    }
}



#pragma mark - 懒加载
- (AVAudioEngine *)audioEngine{
    if (!_audioEngine) {
        _audioEngine = [[AVAudioEngine alloc] init];
    }
    return _audioEngine;
}
- (SFSpeechRecognizer *)speechRecognizer API_AVAILABLE(ios(10.0)){
    if (!_speechRecognizer) {
        //要为语音识别对象设置语言，这里设置的是中文
        NSLocale *local =[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        
        if (@available(iOS 10.0, *)) {
            _speechRecognizer =[[SFSpeechRecognizer alloc] initWithLocale:local];
        } else {
            // Fallback on earlier versions
        }
        _speechRecognizer.delegate = self;
    }
    return _speechRecognizer;
}


#pragma mark - 录音权限
-(void)speechRoot{
    if (@available(iOS 10.0, *)) {
        [SFSpeechRecognizer  requestAuthorization:^(SFSpeechRecognizerAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (status) {
                    case SFSpeechRecognizerAuthorizationStatusNotDetermined:
                        NSLog(@"语音识别未授权");
                        break;
                    case SFSpeechRecognizerAuthorizationStatusDenied:
                        NSLog(@"用户未授权使用语音识别");
                        break;
                    case SFSpeechRecognizerAuthorizationStatusRestricted:
                        NSLog(@"语音识别在这台设备上受到限制");
                        
                        break;
                    case SFSpeechRecognizerAuthorizationStatusAuthorized:
                        NSLog(@"SFSpeechRecognizerAuthorizationStatusAuthorized");
                        break;
                        
                    default:
                        break;
                }
                
            });
        }];
    } else {
        // Fallback on earlier versions
    }
}
@end
