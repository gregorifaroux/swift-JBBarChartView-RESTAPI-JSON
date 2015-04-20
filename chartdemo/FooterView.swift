//
//  FooterView.swift
//
//  Created by Gregori Faroux on 11/1/14.
//  Copyright (c) 2014 Gregori Faroux. All rights reserved.
//

import Foundation

class FooterView : UIView {
    
    var padding = CGFloat(4)
    var rightLabel = UILabel()
    var leftLabel = UILabel()
    
    convenience init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()
    }
/*
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        
        let context = UIGraphicsGetCurrentContext()
        let step = (rect.width / (5 * 2))

        CGContextSetLineWidth(context, 0.5)
        CGContextSetStrokeColorWithColor(context, UIColor.whiteColor().CGColor)
        
        CGContextMoveToPoint(context, 0, 2)
        CGContextAddLineToPoint(context, 0 + step, 2)
        CGContextAddLineToPoint(context, 0 + step, 4)
        CGContextAddLineToPoint(context, 0 + step, 2)
        CGContextSetShouldAntialias(context, true);
        CGContextAddLineToPoint(context, rect.width, 2)
        CGContextStrokePath(context)

    } */
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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