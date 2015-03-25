//
//  ChartInformationValueView.swift
//  chartdemo
//
//  Created by Gregori Faroux on 11/2/14.
//  Copyright (c) 2014 digistarters. All rights reserved.
//

import Foundation

class ChartInformationValueView : UIView {
    let _valueViewPadding:CGFloat = 10.0

    let _valueLabel = UILabel()
    let _valueFont = UIFont(name:"HelveticaNeue-CondensedBold", size:70.0)

    
    override convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        _valueLabel.font = _valueFont
        _valueLabel.textColor = UIColor.whiteColor()
        _valueLabel.shadowColor = UIColor.blackColor()
        _valueLabel.shadowOffset = CGSizeMake(0, 1)
        _valueLabel.backgroundColor =  UIColor.clearColor()
        _valueLabel.textAlignment = NSTextAlignment.Right
        _valueLabel.adjustsFontSizeToFitWidth = true
        _valueLabel.numberOfLines = 1
        self.addSubview(_valueLabel)

    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func layoutSubviews () {
        var valueLabelSize:CGSize = CGSizeZero
        self._valueLabel.adjustsFontSizeToFitWidth = true
        if let text = self._valueLabel.text {
            valueLabelSize = text.sizeWithAttributes([NSFontAttributeName: self._valueLabel.font])
        }
        self._valueLabel.frame = CGRectMake(0, 0, self.superview!.bounds.size.width - 2 * _valueViewPadding, valueLabelSize.height)
    }
}
