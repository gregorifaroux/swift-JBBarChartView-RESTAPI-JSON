//
//  FooterView.swift
//  ResearchDashboard
//
//  Created by Gregori Faroux on 11/1/14.
//  Copyright (c) 2014 Gregori Faroux. All rights reserved.
//

import Foundation

class FooterView : UIView {
    let _font = UIFont(name:"HelveticaNeue-Light", size:12.0)
    
    var padding = CGFloat(4);
    var rightLabel = UILabel();
    var leftLabel = UILabel();
    
    override convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = uicolorFromHex(0x313131)
        
        leftLabel.adjustsFontSizeToFitWidth = true;
        leftLabel.font = _font;
        leftLabel.textAlignment = NSTextAlignment.Left
        leftLabel.shadowColor = UIColor.blackColor()
        leftLabel.shadowOffset = CGSizeMake(0, 1);
        leftLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(leftLabel)
        
        rightLabel.adjustsFontSizeToFitWidth = true;
        rightLabel.font = _font;
        rightLabel.textAlignment = NSTextAlignment.Right;
        rightLabel.shadowColor = UIColor.blackColor()
        rightLabel.shadowOffset = CGSizeMake(0, 1);
        rightLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(rightLabel)

    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let xOffset = self.padding;
        let yOffset:CGFloat = 0;
        let width = self.bounds.size.width * 0.5 - self.padding;

        self.leftLabel.frame = CGRectMake(xOffset, yOffset, width, self.bounds.size.height);
        self.rightLabel.frame = CGRectMake(CGRectGetMaxX(leftLabel.frame), yOffset, width, self.bounds.size.height);
    }
    
    /*
    Converts hex values to UIColor(with red, green and blue)
    */
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}