//
//  BarChartView.swift
//  chartdemo
//
//  Created by Gregori Faroux on 4/16/15.
//  Copyright (c) 2015 digistarters. All rights reserved.
//

import Foundation

class BarChartView: UIView {
    let labelFont = UIFont(name:"HelveticaNeue-Light", size:14.0)
    
    
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

        footer.addSubview(legendLabel)

        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let xOffset:CGFloat = self.frame.origin.x
        let yOffset:CGFloat = 0
        let width = self.frame.size.width
        let height = self.labelHeight
        
        self.legendLabel.frame = CGRectMake(xOffset, yOffset, width, height)
    }
    
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }
}
