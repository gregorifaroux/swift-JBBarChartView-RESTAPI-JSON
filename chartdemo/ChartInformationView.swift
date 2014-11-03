//
//  ChartInformationView.swift
//  chartdemo
//
//  Created by Gregori Faroux on 11/2/14.
//  Copyright (c) 2014 digistarters. All rights reserved.
//

import Foundation

class ChartInformationView: UIView {
    
    let _valueViewPadding:CGFloat = 10.0;
    let _valueViewSeparatorSize:CGFloat = 0.5;
    let _valueViewTitleHeight:CGFloat = 50.0;
    let _valueViewTitleWidth:CGFloat = 75.0;
    let _valueViewDefaultAnimationDuration:CGFloat = 0.25;

    
    let _informationFont = UIFont(name:"HelveticaNeue", size:20.0)
    let _valueFont = UIFont(name:"HelveticaNeue-CondensedBold", size:70.0)
    
    let _valueView = ChartInformationValueView();

    let _titleLabel = UILabel();
    let _separatorView = UIView()
    
    func setTitleText(aText:String) {
        _titleLabel.text = aText;
    }

    
    override convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true;
        _titleLabel.font = _informationFont;
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = true;
        _titleLabel.backgroundColor = UIColor.clearColor()
        _titleLabel.textColor = UIColor.whiteColor()
        _titleLabel.shadowColor = UIColor.blackColor()
        _titleLabel.shadowOffset = CGSizeMake(0, 1);
        _titleLabel.textAlignment = NSTextAlignment.Left;
        self.addSubview(_titleLabel)
 
        _separatorView.backgroundColor = UIColor.whiteColor();
        self.addSubview(_separatorView)
        
        
        _valueView.frame = valueViewRect();
        self.addSubview(_valueView)
        
        
        //    [self setHidden:YES animated:NO];
    }
    
    func valueViewRect() -> CGRect {
        var valueRect:CGRect = CGRectZero;
        valueRect.origin.x = _valueViewPadding;
        valueRect.origin.y = _valueViewPadding + _valueViewTitleHeight;
        valueRect.size.width = self.bounds.size.width - (_valueViewPadding * 2);
        valueRect.size.height = self.bounds.size.height - valueRect.origin.y - _valueViewPadding;
        return valueRect;

    }

    func titleViewRectForHidden(hidden : Bool) ->CGRect {
        var titleRect:CGRect = CGRectZero;
        titleRect.origin.x = _valueViewPadding;
        titleRect.origin.y = hidden ? -_valueViewTitleHeight : _valueViewPadding;
        titleRect.size.width = self.bounds.size.width - (_valueViewPadding * 2);
        titleRect.size.height = _valueViewTitleHeight;
        return titleRect;
    }
    
    func separatorViewRectForHidden(hidden : Bool) -> CGRect    {
        var separatorRect : CGRect  = CGRectZero;
        separatorRect.origin.x = _valueViewPadding;
        separatorRect.origin.y = _valueViewTitleHeight;
        separatorRect.size.width = self.bounds.size.width - (_valueViewPadding * 2);
        separatorRect.size.height = _valueViewSeparatorSize;
        if (hidden) {
            separatorRect.origin.x -= self.bounds.size.width;
        }
        return separatorRect;
    }
    
    
    func setTitleText(titleText: NSString?) {
        self._titleLabel.text = titleText;
        self._separatorView.hidden = !(titleText != nil);
    }
    
    func setValueText(valueText: NSString) {
        self._valueView._valueLabel.text = valueText;
        self._valueView.setNeedsLayout()
    }
    
    func setTitleTextColor(titleTextColor: UIColor) {
        self._titleLabel.textColor = titleTextColor;
        self._valueView.setNeedsDisplay()
    }
    
    func setValueAndUnitTextColor(valueAndUnitColor: UIColor) {
        self._valueView._valueLabel.textColor = valueAndUnitColor;
        self._valueView.setNeedsDisplay()
    }
    
    func setTextShadowColor(shadowColor: UIColor) {
        self._valueView._valueLabel.shadowColor = shadowColor;
        self._titleLabel.shadowColor = shadowColor;
        self._valueView.setNeedsDisplay()
    }
    
    func setSeparatorColor(separatorColor: UIColor) {
        self._separatorView.backgroundColor = separatorColor;
        self._valueView.setNeedsDisplay()
    }

    
    
    func setHidden(hidden: Bool, animated: Bool) {
        if (animated) {
            if (hidden) {
                UIView.animateWithDuration(0.25 , delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self._titleLabel.alpha = 0.0;
                    self._separatorView.alpha = 0.0;
                    self._valueView._valueLabel.alpha = 0.0;
                    }, completion: {
                        (value: Bool) in
                            self._titleLabel.frame = self.titleViewRectForHidden(true);
                            self._separatorView.frame = self.separatorViewRectForHidden(true);
                        
                    })
            } else {
                UIView.animateWithDuration(0.25 , delay: 0.0, options: UIViewAnimationOptions.BeginFromCurrentState, animations: {
                    self._titleLabel.frame = self.titleViewRectForHidden(false);
                    self._titleLabel.alpha = 1.0;
                    self._valueView._valueLabel.alpha = 1.0;
                    self._separatorView.frame = self.separatorViewRectForHidden(false);
                    self._separatorView.alpha = 1.0;

                    }, completion: nil)
            }
    
        } else {
            self._titleLabel.frame = self.titleViewRectForHidden(hidden);
            self._titleLabel.alpha = hidden ? 0.0 : 1.0;
            self._separatorView.frame = self.separatorViewRectForHidden(hidden);
            self._separatorView.alpha = hidden ? 0.0 : 1.0;
            self._valueView._valueLabel.alpha = hidden ? 0.0 : 1.0;
        }
    }
    
    func setHidden(hidden: Bool) {
        self.setHidden(hidden, animated: false)
    }


    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }


    
}
