//
//  VerificationCodeView.h
//  codeView
//
//  Created by 段桥 on 2017/9/27.
//  Copyright © 2017年 DQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CMICodeTextField;
@class CMIVeriyCollectionCell;

@interface VerificationCodeView : UIView
/*
 *验证码是否正确
 *
 */
@property (nonatomic, assign) BOOL isTure;

@end

@interface CMICodeTextField : UITextField

@end

@interface CMIVeriyCollectionCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *textLabel; //显示单位验证码

@property (nonatomic, strong) UIView *lineView;   //文字下划线


@end
