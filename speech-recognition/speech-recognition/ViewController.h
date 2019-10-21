//
//  ViewController.h
//  speech-recognition
//
//  Created by 黄龙山 on 2019/8/24.
//  Copyright © 2019 黄龙山. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kScreenWidth [[UIScreen mainScreen] bounds].size.width
#define kScreenHeight [[UIScreen mainScreen] bounds].size.height

#define kFixRax  (float)(([UIScreen mainScreen].bounds.size.width)/375)
#define kFixRaxW (float)(([UIScreen mainScreen].bounds.size.width)/375)

#define WGColorHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define IMGWithName(strName)   [UIImage imageNamed:strName]

@interface ViewController : UIViewController


@end

