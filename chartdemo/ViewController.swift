//
//  ViewController.swift
//
//  Created by Gregori Faroux on 10/30/14.
//  Copyright (c) 2014 Gregori Faroux. All rights reserved.
//

import UIKit


class ViewController: UIViewController, JBBarChartViewDelegate, JBBarChartViewDataSource {
    
    let _headerHeight:CGFloat = 80
    let _footerHeight:CGFloat = 40
    let _padding:CGFloat = 10
    
    let _barChartView = JBBarChartView()
    let _headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let _informationView = ChartInformationView()
    let _tooltipView = TooltipView()
    let _tooltipTipView = TooltipTipView()
    let _footerView = FooterView()
    
    
    var _chartData: [Float] = []
    var _chartLegend: [String] = []
    
    var _view_constraint_V:NSArray = [NSLayoutConstraint]()
    let _view_height_portrait:CGFloat = 400.0
    let _view_height_landscape:CGFloat = 180.0
    
    func buttonRefresh(sender: AnyObject) {
        _barChartView.setState(JBChartViewState.Collapsed, animated: true)
        _headerView.titleLabel.text = "Loading..."
        _chartData = []
        _chartLegend = []
        downloadData()
    }
    
    func downloadData() {
        // Data
        var results = []
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "MM-dd"
        
        let json = JSON(url:"http://api.openweathermap.org/data/2.5/forecast/daily?q=atlanta&mode=json&units=metric&cnt=5")
        if let days = json["list"].asArray {
            var i:Int = 0
            for day in days {
                var temperature:Double = day["temp"]["day"].asDouble!
                var date:Double = day["dt"].asDouble!
                
                _chartLegend.append(dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: date)))
                _chartData.append(Float(temperature))
            }
            _footerView.leftLabel.text = _chartLegend[0]
            _footerView.rightLabel.text = _chartLegend[_chartLegend.count - 1 ]
            _headerView.titleLabel.text = json["city"]["name"].asString
            
            _barChartView.reloadData()
            _barChartView.setState(JBChartViewState.Expanded, animated: true)
            
        }
        
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = uicolorFromHex(0x2c2c2c)
        
        _barChartView.setTranslatesAutoresizingMaskIntoConstraints(false)
        _informationView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.view.addSubview(_barChartView)
        self.view.addSubview(_informationView)
        
        //--------------- constraints
        
        //make dictionary for views
        let viewsDictionary = ["view1":_barChartView,"view2":_informationView]
        
        //position constraints
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view1]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view2]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        _view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view1(height)]-[view2]-0-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: ["height": _view_height_portrait], views: viewsDictionary)
        
        view.addConstraints(view_constraint_H)
        view.addConstraints(view_constraint_H2)
        view.addConstraints(_view_constraint_V)
        
        // Forces to compute the layout size, so JBChartView library does not complain that the footer and headers are bigger than the chart itself.
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        _barChartView.dataSource = self
        _barChartView.delegate = self
        
        // Navigation bar
        self.navigationItem.title = "Weather App"
        
        
        // Body
        _barChartView.backgroundColor = uicolorFromHex(0x3c3c3c)
        //    _barChartView.frame = CGRectMake(_padding, 80, self.view.bounds.width - _padding * 2, self.view.bounds.height / 2)
        _barChartView.minimumValue = 0
        
        // Header
        _headerView.frame = CGRectMake(_padding,ceil(self.view.bounds.size.height * 0.5) - ceil(_headerHeight * 0.5),self.view.bounds.width - _padding*2, _headerHeight)
        _headerView.titleLabel.text = "Loading..."
        _headerView.subtitleLabel.text = "Weather Forecast"
        _barChartView.headerView = _headerView
        
        // Footer
        _footerView.frame = CGRectMake(_padding, ceil(self.view.bounds.size.height * 0.5) - ceil(_footerHeight * 0.5),self.view.bounds.width - _padding*2, _footerHeight)
        _footerView.padding = _padding
        _footerView.leftLabel.textColor = UIColor.whiteColor()
        _footerView.rightLabel.textColor = UIColor.whiteColor()
        _barChartView.footerView = _footerView
        
        // Information View
        //   _informationView.frame = CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(_barChartView.frame), self.view.bounds.width, self.view.bounds.size.height - CGRectGetMaxY(_barChartView.frame))
        
        // Tooltip
        _tooltipView.alpha = 0.0
        _barChartView.addSubview(_tooltipView)
        _tooltipTipView.alpha = 0.0
        _barChartView.addSubview(_tooltipTipView)
        
        downloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* Returns the numbers of BARs */
    func numberOfBarsInBarChartView(barChartView: JBBarChartView!) -> UInt {
        return UInt(_chartData.count)
    }
    
    /* Returns the value @ index */
    func barChartView(barChartView: JBBarChartView, heightForBarViewAtIndex index: UInt) -> CGFloat {
        return CGFloat(_chartData[Int(index)])
    }
    
    /* Bar color @ index */
    func barChartView(barChartView: JBBarChartView, colorForBarViewAtIndex index: UInt) -> UIColor {
        return (Int(index) % 2 == 0 ) ? uicolorFromHex(0x34b234) : uicolorFromHex(0x08bcef)
    }
    
    /* Called when user selects a bar */
    func barChartView(barChartView: JBBarChartView, didSelectBarAtIndex index: UInt, touchPoint:CGPoint) {
        _informationView.setValueText(NSString(format: "%.2f C", _chartData[Int(index)]))
        _informationView.setTitleText(_chartLegend[Int(index)])
        _informationView.setHidden(false, animated: true)
        
        // Adjust tooltip position
        var convertedTouchPoint:CGPoint = touchPoint
        let minChartX:CGFloat = (_barChartView.frame.origin.x + ceil(_tooltipView.frame.size.width * 0.5))
        if (convertedTouchPoint.x < minChartX)
        {
            convertedTouchPoint.x = minChartX
        }
        var maxChartX:CGFloat = (_barChartView.frame.origin.x + _barChartView.frame.size.width - ceil(_tooltipView.frame.size.width * 0.5))
        if (convertedTouchPoint.x > maxChartX)
        {
            convertedTouchPoint.x = maxChartX
        }
        _tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(_tooltipView.frame.size.width * 0.5),
            CGRectGetMaxY(_headerView.frame),
            _tooltipView.frame.size.width,
            _tooltipView.frame.size.height)
        _tooltipView.setText(_chartLegend[Int(index)])
        
        
        var originalTouchPoint:CGPoint = touchPoint
        let minTipX:CGFloat = (_barChartView.frame.origin.x + _tooltipTipView.frame.size.width)
        if (touchPoint.x < minTipX)
        {
            originalTouchPoint.x = minTipX
        }
        let maxTipX = (_barChartView.frame.origin.x + _barChartView.frame.size.width - _tooltipTipView.frame.size.width)
        if (originalTouchPoint.x > maxTipX)
        {
            originalTouchPoint.x = maxTipX
        }
        _tooltipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(_tooltipTipView.frame.size.width * 0.5), CGRectGetMaxY(_tooltipView.frame), _tooltipTipView.frame.size.width, _tooltipTipView.frame.size.height)
        _tooltipView.alpha = 1.0
        _tooltipTipView.alpha = 1.0
    }
    
    /* Called when user stop selecting a bar */
    func didDeselectBarChartView(barChartView: JBBarChartView) {
        _informationView.setHidden(true, animated: true)
        _tooltipView.alpha = 0.0
        _tooltipTipView.alpha = 0.0
        
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return false
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
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        println("viewWillTransitionToSize")
        _barChartView.setState(JBChartViewState.Collapsed, animated: true)
        
        if (UIDevice.currentDevice().orientation.isLandscape) {
            println("Landscape")
            _headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            (self._view_constraint_V[1] as NSLayoutConstraint).constant = _view_height_landscape
        } else {
            println("Portrait")
            _headerView.frame = CGRectMake(_padding,ceil(self.view.bounds.size.height * 0.5) - ceil(_headerHeight * 0.5),self.view.bounds.width - _padding*2, _headerHeight)
            (self._view_constraint_V[1] as NSLayoutConstraint).constant = _view_height_portrait
        }
        // Refresh the graph once the transition is completed
        coordinator.animateAlongsideTransition(nil, completion: {
            _ in self._barChartView.reloadData()
            self._barChartView.setState(JBChartViewState.Expanded, animated: true)
        })
    }
    
    
    
}

