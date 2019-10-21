
![2019-10-21 17.04.38.gif](https://upload-images.jianshu.io/upload_images/3850802-50b27741afa9d08d.gif?imageMogr2/auto-orient/strip)

文档
[Android speech](https://developer.android.google.cn/reference/android/speech/package-summary?hl=en)
[iOS speech](https://developer.apple.com/documentation/speech?language=objc)

####权限
![权限.png](https://upload-images.jianshu.io/upload_images/3850802-a5e6eddfdc7b0af8.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####开始录音
```
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
```
####结束录音
```
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
```
####识别代理
```
#pragma mark - SFSpeechRecognizerDelegate  识别代理
- (void)speechRecognizer:(SFSpeechRecognizer *)speechRecognizer availabilityDidChange:(BOOL)available API_AVAILABLE(ios(10.0)){
    if (available) {
        NSLog(@"delegate :开始录音");
    }
    else{
        NSLog(@"语音识别不可用");
    }
}
```

⚠️然而需要注意的却是出发录音和结束录音的方法调用：保证从开始到结束整个过程,各自只能调用一次。
```
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
```



[具体demo放这了--](https://github.com/samtake/speech-recognition)


----end.






