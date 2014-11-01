//
//  JBChartInformationView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 11/11/13.
//  Copyright (c) 2013 Jawbone. All rights reserved.
//

#import "JBChartInformationView.h"

// Numerics
CGFloat const kJBChartValueViewPadding = 10.0f;
CGFloat const kJBChartValueViewSeparatorSize = 0.5f;
CGFloat const kJBChartValueViewTitleHeight = 50.0f;
CGFloat const kJBChartValueViewTitleWidth = 75.0f;
CGFloat const kJBChartValueViewDefaultAnimationDuration = 0.25f;

// Colors (JBChartInformationView)
static UIColor *kJBChartViewSeparatorColor = nil;
static UIColor *kJBChartViewTitleColor = nil;
static UIColor *kJBChartViewShadowColor = nil;

// Colors (JBChartInformationView)
static UIColor *kJBChartInformationViewValueColor = nil;
static UIColor *kJBChartInformationViewShadowColor = nil;

#define kJBFontInformationTitle [UIFont fontWithName:@"HelveticaNeue" size:20]
#define kJBFontInformationValue [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:70]

@interface JBChartValueView : UIView

@property (nonatomic, strong) UILabel *valueLabel;

@end

@interface JBChartInformationView ()

@property (nonatomic, strong) JBChartValueView *valueView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *separatorView;

// Position
- (CGRect)valueViewRect;
- (CGRect)titleViewRectForHidden:(BOOL)hidden;
- (CGRect)separatorViewRectForHidden:(BOOL)hidden;

@end

@implementation JBChartInformationView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [JBChartInformationView class])
	{
		kJBChartViewSeparatorColor = [UIColor whiteColor];
        kJBChartViewTitleColor = [UIColor whiteColor];
        kJBChartViewShadowColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.clipsToBounds = YES;

        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = kJBFontInformationTitle;
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = kJBChartViewTitleColor;
        _titleLabel.shadowColor = kJBChartViewShadowColor;
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:_titleLabel];

        _separatorView = [[UIView alloc] init];
        _separatorView.backgroundColor = kJBChartViewSeparatorColor;
        [self addSubview:_separatorView];

        _valueView = [[JBChartValueView alloc] initWithFrame:[self valueViewRect]];
        [self addSubview:_valueView];
        
        [self setHidden:YES animated:NO];
    }
    return self;
}

#pragma mark - Position

- (CGRect)valueViewRect
{
    CGRect valueRect = CGRectZero;
    valueRect.origin.x = kJBChartValueViewPadding;
    valueRect.origin.y = kJBChartValueViewPadding + kJBChartValueViewTitleHeight;
    valueRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    valueRect.size.height = self.bounds.size.height - valueRect.origin.y - kJBChartValueViewPadding;
    return valueRect;
}

- (CGRect)titleViewRectForHidden:(BOOL)hidden
{
    CGRect titleRect = CGRectZero;
    titleRect.origin.x = kJBChartValueViewPadding;
    titleRect.origin.y = hidden ? -kJBChartValueViewTitleHeight : kJBChartValueViewPadding;
    titleRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    titleRect.size.height = kJBChartValueViewTitleHeight;
    return titleRect;
}

- (CGRect)separatorViewRectForHidden:(BOOL)hidden
{
    CGRect separatorRect = CGRectZero;
    separatorRect.origin.x = kJBChartValueViewPadding;
    separatorRect.origin.y = kJBChartValueViewTitleHeight;
    separatorRect.size.width = self.bounds.size.width - (kJBChartValueViewPadding * 2);
    separatorRect.size.height = kJBChartValueViewSeparatorSize;
    if (hidden)
    {
        separatorRect.origin.x -= self.bounds.size.width;
    }
    return separatorRect;
}

#pragma mark - Setters

- (void)setTitleText:(NSString *)titleText
{
    self.titleLabel.text = titleText;
    self.separatorView.hidden = !(titleText != nil);
}

- (void)setValueText:(NSString *)valueText
{
    self.valueView.valueLabel.text = valueText;
    [self.valueView setNeedsLayout];
}

- (void)setTitleTextColor:(UIColor *)titleTextColor
{
    self.titleLabel.textColor = titleTextColor;
    [self.valueView setNeedsDisplay];
}

- (void)setValueAndUnitTextColor:(UIColor *)valueAndUnitColor
{
    self.valueView.valueLabel.textColor = valueAndUnitColor;
    [self.valueView setNeedsDisplay];
}

- (void)setTextShadowColor:(UIColor *)shadowColor
{
    self.valueView.valueLabel.shadowColor = shadowColor;
    self.titleLabel.shadowColor = shadowColor;
    [self.valueView setNeedsDisplay];
}

- (void)setSeparatorColor:(UIColor *)separatorColor
{
    self.separatorView.backgroundColor = separatorColor;
    [self setNeedsDisplay];
}

- (void)setHidden:(BOOL)hidden animated:(BOOL)animated
{
    if (animated)
    {
        if (hidden)
        {
            [UIView animateWithDuration:kJBChartValueViewDefaultAnimationDuration * 0.5 delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.titleLabel.alpha = 0.0;
                self.separatorView.alpha = 0.0;
                self.valueView.valueLabel.alpha = 0.0;
            } completion:^(BOOL finished) {
                self.titleLabel.frame = [self titleViewRectForHidden:YES];
                self.separatorView.frame = [self separatorViewRectForHidden:YES];
            }];
        }
        else
        {
            [UIView animateWithDuration:kJBChartValueViewDefaultAnimationDuration delay:0.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                self.titleLabel.frame = [self titleViewRectForHidden:NO];
                self.titleLabel.alpha = 1.0;
                self.valueView.valueLabel.alpha = 1.0;
                self.separatorView.frame = [self separatorViewRectForHidden:NO];
                self.separatorView.alpha = 1.0;
            } completion:nil];
        }
    }
    else
    {
        self.titleLabel.frame = [self titleViewRectForHidden:hidden];
        self.titleLabel.alpha = hidden ? 0.0 : 1.0;
        self.separatorView.frame = [self separatorViewRectForHidden:hidden];
        self.separatorView.alpha = hidden ? 0.0 : 1.0;
        self.valueView.valueLabel.alpha = hidden ? 0.0 : 1.0;
    }
}

- (void)setHidden:(BOOL)hidden
{
    [self setHidden:hidden animated:NO];
}

@end

@implementation JBChartValueView

#pragma mark - Alloc/Init

+ (void)initialize
{
	if (self == [JBChartValueView class])
	{
		kJBChartInformationViewValueColor = [UIColor whiteColor];
        kJBChartInformationViewShadowColor = [UIColor blackColor];
	}
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _valueLabel = [[UILabel alloc] init];
        _valueLabel.font = kJBFontInformationValue;
        _valueLabel.textColor = kJBChartInformationViewValueColor;
        _valueLabel.shadowColor = kJBChartInformationViewShadowColor;
        _valueLabel.shadowOffset = CGSizeMake(0, 1);
        _valueLabel.backgroundColor = [UIColor clearColor];
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        _valueLabel.numberOfLines = 1;
        [self addSubview:_valueLabel];
        
    }
    return self;
}

#pragma mark - Layout

- (void)layoutSubviews
{
    CGSize valueLabelSize = CGSizeZero;
    self.valueLabel.adjustsFontSizeToFitWidth = true;
    valueLabelSize = [self.valueLabel.text sizeWithAttributes:@{NSFontAttributeName:self.valueLabel.font}];
    self.valueLabel.frame = CGRectMake(0, 0, self.superview.bounds.size.width - 2 * kJBChartValueViewPadding, valueLabelSize.height);
}

@end
