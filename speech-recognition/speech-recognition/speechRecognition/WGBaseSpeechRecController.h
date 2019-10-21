//
//  WGBaseSpeechRecController.h
//  weGood
//
//  Created by 黄龙山 on 2019/8/26.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface WGBaseSpeechRecController : UIViewController
@property(nonatomic, copy) void (^blockRequestWithResult)(NSString *resultStr);
- (void)buttonTouchBegin;
- (void)buttonTouchCancel;
@end

NS_ASSUME_NONNULL_END
