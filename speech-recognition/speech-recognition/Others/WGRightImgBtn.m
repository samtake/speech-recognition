//
//  WGRightImgBtn.m
//  weGood
//
//  Created by 梁爱军 on 2019/8/22.
//  Copyright © 2019 changdaokeji. All rights reserved.
//

#import "WGRightImgBtn.h"
#import "UIView+Frame.h"
@interface WGRightImgBtn()

@end
@implementation WGRightImgBtn

-(instancetype)initWithSpace:(CGFloat)space
{
    if (self = [super init]) {
        self.space = space;
        
    }
    return self;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.imageView.image.size.width <=1*kFixRaxW) {
        self.imageView.frame = CGRectZero;
        
          [self.titleLabel sizeToFit];
        self.titleLabel.frame = CGRectMake(0, 0, self.titleLabel.wgWidth, self.titleLabel.wgHeight);
        self.titleLabel.wgCenterX = self.wgWidth*0.5;
           self.titleLabel.wgCenterY = self.wgHeight*0.5;
     }
    else
    {
    self.imageView.frame = CGRectMake(self.imgLeft, 0, self.imageView.image.size.width*kFixRaxW, self.imageView.image.size.height*kFixRax);
    
 
    self.imageView.wgCenterY = self.wgHeight*0.5;
    
    
    [self.titleLabel sizeToFit];
    
    
    self.titleLabel.frame = CGRectMake(self.imageView.wgRight+self.space, 0, self.titleLabel.wgWidth, self.titleLabel.wgHeight);
    
    self.titleLabel.wgCenterY = self.wgHeight*0.5;
        
    }
    
    
}
@end
