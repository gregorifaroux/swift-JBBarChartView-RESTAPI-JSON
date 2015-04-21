//
//  DotView.swift
//  chartdemo
//
//  Created by Gregori Faroux on 4/19/15.
//  Copyright (c) 2015 digistarters. All rights reserved.
//

import Foundation

//
//  BarChartView.swift
//  chartdemo
//
//  Created by Gregori Faroux on 4/16/15.
//  Copyright (c) 2015 digistarters. All rights reserved.
//

import Foundation

class DotView: UIView {
    let labelFont = UIFont(name:"HelveticaNeue-Light", size:14.0)
    var _footer:FooterView?
    
    var padding = CGFloat(0)
    var barWidth = CGFloat(27)
    var legendLabel = UILabel()
    var legendLabelWidth = CGFloat(50)
    var labelHeight = CGFloat(27)
    
    override init(frame: CGRect) {
        fatalError("Not Implemented")
    }
    
    init(frame: CGRect, footer: FooterView) {
        super.init(frame: frame)
        
        self.backgroundColor = uicolorFromHex(0xE8E8E8)
        
        // setting up legend Label
        legendLabel.frame = CGRectMake(0, self.bounds.height, legendLabelWidth, labelHeight)
        legendLabel.textAlignment = NSTextAlignment.Center
        legendLabel.textColor = UIColor.whiteColor()
        legendLabel.font = labelFont
        legendLabel.adjustsFontSizeToFitWidth = true
        legendLabel.shadowColor = UIColor.blackColor()
        legendLabel.shadowOffset = CGSizeMake(0, 1)
        legendLabel.backgroundColor = UIColor.clearColor()

        _footer = footer
        self._footer!.addSubview(legendLabel)
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let width = legendLabel.bounds.width
        let height = self.labelHeight
        let yOffset:CGFloat = 0

        var xOffset:CGFloat = self.frame.origin.x - (width / 2)
        
        // Avoid clipping the legend
        if (xOffset < 0) {
            xOffset = 1
        }

        if ( (xOffset + width) > self._footer!.bounds.width ) {
            xOffset = self._footer!.bounds.width -  width
        }
        
        self.legendLabel.frame = CGRectMake(xOffset, yOffset, width, height)
        
        
    }
    
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
