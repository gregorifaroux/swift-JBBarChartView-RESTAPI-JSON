//
//  HeaderView.swift
//  ResearchDashboard
//
//  Created by Gregori Faroux on 11/1/14.
//  Copyright (c) 2014 Gregori Faroux. All rights reserved.
//

import Foundation

class HeaderView : UIView {
    let _fontTitle = UIFont(name:"HelveticaNeue-Bold", size:24.0)
    let _fontSubtitle = UIFont(name:"HelveticaNeue-Light", size:14.0)
    let _viewSeparatorHeight = CGFloat(0.5);
    
    let _separatorView = UIView();
    
    var padding = CGFloat(4);
    var titleLabel = UILabel();
    var subtitleLabel = UILabel();
    var separatorColor = UIColor.whiteColor();
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = uicolorFromHex(0x313131)
        
        titleLabel.numberOfLines = 1;
        titleLabel.adjustsFontSizeToFitWidth = true;
        titleLabel.textAlignment = NSTextAlignment.Center;
        titleLabel.font = _fontTitle;
        titleLabel.textColor = UIColor.whiteColor();
        titleLabel.shadowColor = UIColor.blackColor();
        titleLabel.shadowOffset = CGSizeMake(0, 1);
        titleLabel.backgroundColor = UIColor.clearColor();
        self.addSubview(titleLabel)
        
        subtitleLabel.numberOfLines = 1;
        subtitleLabel.adjustsFontSizeToFitWidth = true;
        subtitleLabel.font = _fontSubtitle
        subtitleLabel.textAlignment = NSTextAlignment.Center;
        subtitleLabel.textColor = UIColor.whiteColor()
        subtitleLabel.shadowColor = UIColor.blackColor();
        subtitleLabel.shadowOffset = CGSizeMake(0, 1);
        subtitleLabel.backgroundColor = UIColor.clearColor()
        self.addSubview(subtitleLabel)

        _separatorView.backgroundColor = separatorColor;
        self.addSubview(_separatorView)

    }

    func setSeparatorColor(separatorColor:UIColor) {
        self.separatorColor = separatorColor;
        self._separatorView.backgroundColor = separatorColor;
        self.setNeedsLayout()
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        let xOffset = self.padding;
        var yOffset:CGFloat = 0;
        let titleHeight = ceil(self.bounds.size.height * 0.5);
        let subTitleHeight = self.bounds.size.height - titleHeight - _viewSeparatorHeight;
        
        self.titleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), titleHeight);
        yOffset += self.titleLabel.frame.size.height;
        self._separatorView.frame = CGRectMake(xOffset * 2, yOffset, self.bounds.size.width - (xOffset * 4), _viewSeparatorHeight);
        yOffset += self._separatorView.frame.size.height;
        self.subtitleLabel.frame = CGRectMake(xOffset, yOffset, self.bounds.size.width - (xOffset * 2), subTitleHeight);

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