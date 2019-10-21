//
//  WGRightImgBtn.h
//  weGood
//
//  Created by 梁爱军 on 2019/8/22.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface WGRightImgBtn : UIButton

/**
 *  自定义构建方法
 *  @param space : 图片和文字之间的间距
 * 
 */
-(instancetype)initWithSpace:(CGFloat)space;
/** 左边到图片的距离 */
@property(nonatomic,assign)CGFloat imgLeft;

/**  图片和文字之间的间距 */
@property(nonatomic,assign)CGFloat space;
@end

NS_ASSUME_NONNULL_END
