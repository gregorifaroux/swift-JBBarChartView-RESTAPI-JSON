//
//  JBChartTooltipView.m
//  JBChartViewDemo
//
//  Created by Terry Worona on 3/12/14.
//  Copyright (c) 2014 Jawbone. All rights reserved.
//

#import "JBChartTooltipView.h"

// Drawing
#import <QuartzCore/QuartzCore.h>

// Numerics
CGFloat static const kJBChartTooltipViewCornerRadius = 5.0;
CGFloat const kJBChartTooltipViewDefaultWidth = 50.0f;
CGFloat const kJBChartTooltipViewDefaultHeight = 25.0f;

#define UIColorFromHex(hex) [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 green:((float)((hex & 0xFF00) >> 8))/255.0 blue:((float)(hex & 0xFF))/255.0 alpha:1.0]
#define kJBColorTooltipColor [UIColor colorWithWhite:1.0 alpha:0.9]
#define kJBFontTooltipText [UIFont fontWithName:@"HelveticaNeue-Bold" size:14]
#define kJBColorTooltipTextColor UIColorFromHex(0x313131)

@interface JBChartTooltipView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation JBChartTooltipView

#pragma mark - Alloc/Init

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 0, kJBChartTooltipViewDefaultWidth, kJBChartTooltipViewDefaultHeight)];
    if (self)
    {
        self.backgroundColor = kJBColorTooltipColor;
        self.layer.cornerRadius = kJBChartTooltipViewCornerRadius;
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = kJBFontTooltipText;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.textColor = kJBColorTooltipTextColor;
        _textLabel.adjustsFontSizeToFitWidth = YES;
        _textLabel.numberOfLines = 1;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}

#pragma mark - Setters

- (void)setText:(NSString *)text
{
    self.textLabel.text = text;
    [self setNeedsLayout];
}

- (void)setTooltipColor:(UIColor *)tooltipColor
{
    self.backgroundColor = tooltipColor;
    [self setNeedsDisplay];
}

#pragma mark - Layout

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
}

@end
