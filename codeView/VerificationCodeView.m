//
//  VerificationCodeView.m
//  codeView
//
//  Created by 段桥 on 2017/9/27.
//  Copyright © 2017年 DQ. All rights reserved.
//

#import "VerificationCodeView.h"
#define MAS_SHORTHAND_GLOBALS
#import <Masonry.h>


@interface VerificationCodeView ()<UITextFieldDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;//显示框

@property (nonatomic, strong) CMICodeTextField *textField;//文本输入

@property (nonatomic, strong) NSMutableArray *textArr;//将整个字符串截成单个字符的存储位置

@property (nonatomic, strong) UIControl *tapControl;//点击手势

@end

static NSString *const veriyCell = @"veriyCell";

@implementation VerificationCodeView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self createUI];
    self.isTure = YES;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     
        [self createUI];
    }
    return self;
}

- (void)setIsTure:(BOOL)isTure
{
    _isTure = isTure;
    [self.collectionView reloadData];
}

- (void)createUI {

    [self.textField becomeFirstResponder];
    [self collectionView];
    [self tapControl];
}

- (void)textFieldDidChange:(NSNotification *)noti{
    CMICodeTextField *textField = (CMICodeTextField *)noti.object;
    [self.textArr removeAllObjects];
    if (textField.text.length == 0) {
        [self.collectionView reloadData];
     }
    for (int i = 0; i < textField.text.length; i++) {
        NSString *text = [textField.text substringWithRange:NSMakeRange(i, 1)];
        [self.textArr addObject:text];
        [self.collectionView reloadData];
    }
    if (textField.text.length == 6 && ![textField.text isEqualToString:@"123456"]) {
        self.isTure = NO;
    }else{
        self.isTure = YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger existedLength = textField.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = string.length;
    NSInteger length = existedLength - selectedLength + replaceLength;
    if (length > 6) {
        return NO;
    }
    return YES;
}

- (void)becomeRegister
{
    [self.textField becomeFirstResponder];

}

#pragma mark ----UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 6;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CMIVeriyCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:veriyCell forIndexPath:indexPath];
    if (indexPath.row == self.textField.text.length-1) {
        cell.lineView.backgroundColor = [UIColor blueColor];
    }

    if (!self.isTure) {
        cell.lineView.backgroundColor = [UIColor redColor];
    }
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.row < self.textField.text.length) {
        cell.textLabel.text = self.textArr[indexPath.row];
    }
    return cell;
}



#pragma mark ----lazy

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.itemSize = CGSizeMake(32, 36.5);
        layout.minimumInteritemSpacing = (self.frame.size.width-32*6)/5;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:[CMIVeriyCollectionCell class] forCellWithReuseIdentifier:veriyCell];
        [self addSubview:_collectionView];
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _collectionView;
}


- (CMICodeTextField *)textField {
    if (!_textField) {
        
        _textField = [[CMICodeTextField alloc] init];
        _textField.backgroundColor = [UIColor clearColor];
        _textField.delegate = self;
        _textField.secureTextEntry = YES;
        _textField.textColor = [UIColor clearColor];
        _textField.tintColor = [UIColor clearColor];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:nil];
        [self addSubview:_textField];
        [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
    }
    return _textField;
}

- (UIControl *)tapControl
{
    if (_tapControl == nil) {
        _tapControl = [[UIControl alloc]init];
        [self addSubview:_tapControl];
        [_tapControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(0);
        }];
        [_tapControl addTarget:self action:@selector(becomeRegister) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tapControl;
}

- (NSMutableArray *)textArr
{
    if (_textArr == nil) {
        _textArr = [[NSMutableArray alloc]initWithCapacity:6];
    }
    return _textArr;
}

@end


/*------------------------------------------输入显示框cell------------------------------------*/

@interface CMIVeriyCollectionCell ()

@end


@implementation CMIVeriyCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self textLabel];
        [self lineView];
    }
    return self;
}

- (UILabel *)textLabel
{
    if (_textLabel == nil) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.font = [UIFont systemFontOfSize:20];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_textLabel];
        [_textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(0);
            make.top.equalTo(0);
            make.height.equalTo(28);
            make.width.equalTo(12);
        }];
    }
    return _textLabel;
}

- (UIView *)lineView
{
    if (_lineView == nil) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(0);
            make.left.right.equalTo(0);
            make.height.equalTo(0.5);
        }];
    }
    return _lineView;
}

- (void)prepareForReuse
{
    self.textLabel.text = @"";
    self.lineView.backgroundColor = [UIColor lightGrayColor];
}

@end

/*------------------------------------------CMICodeTextField防止复制------------------------------------*/
@interface CMICodeTextField ()

@end

@implementation CMICodeTextField


// 禁止复制粘贴功能
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    
    return NO;
}


@end
