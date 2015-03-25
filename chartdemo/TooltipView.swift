//
//  TooltipVoew.swift
//  chartdemo
//
//  Created by Gregori Faroux on 11/1/14.
//  Copyright (c) 2014 digistarters. All rights reserved.
//

import Foundation

class TooltipView : UIView {
    let _defaultWidth:CGFloat = 50
    let _defaultHeight:CGFloat = 25
    
    let _tooltipColor = UIColor.whiteColor().colorWithAlphaComponent(0.9)
    let _textLabel = UILabel()
    let _font = UIFont(name:"HelveticaNeue-Bold", size:14.0)
    
    override convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 0, y: 0, width: _defaultWidth, height: _defaultHeight))
        self.backgroundColor = _tooltipColor
        self.layer.cornerRadius = 5.0
        
        _textLabel.font = _font
        _textLabel.backgroundColor = UIColor.clearColor()
        _textLabel.textColor = uicolorFromHex(0x313131)
        _textLabel.adjustsFontSizeToFitWidth = true
        _textLabel.numberOfLines = 1
        _textLabel.textAlignment = NSTextAlignment.Center
        self.addSubview(_textLabel)
        
        
    }
    
    func setText(text:String) {
        self._textLabel.text = text
        self.setNeedsLayout()
    }
    
    func setTooltipColor(tooltipColor:UIColor) {
        self.backgroundColor = tooltipColor
        self.setNeedsLayout()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _textLabel.frame = self.bounds
    }
    

    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
    
    
    
}
