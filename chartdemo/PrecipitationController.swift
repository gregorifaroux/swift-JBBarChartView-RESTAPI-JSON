//
//  PrecipitationController.swift
//  dropdownmenu
//
//  Created by Gregori Faroux on 3/25/15.
//  Copyright (c) 2015 digistarters. All rights reserved.
//

import UIKit

class PrecipitationController: UIViewController, ENSideMenuDelegate,  JBLineChartViewDelegate, JBLineChartViewDataSource{
    
    let _headerHeight:CGFloat = 80
    let _footerHeight:CGFloat = 40
    let _padding:CGFloat = 10

    var _chartData: [Float] = []
    var _chartLegend: [String] = []
    var _chartBar: [DotView] = []

    let _lineChartView = JBLineChartView();

    let _headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let _informationView = ChartInformationView()
    let _tooltipView = TooltipView()
    let _tooltipTipView = TooltipTipView()
    let _footerView = FooterView()

    var _view_constraint_V:NSArray = [NSLayoutConstraint]()
    let _view_height_portrait:CGFloat = 320.0
    let _view_height_landscape:CGFloat = 180.0


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("PrecipitationController.viewDidLoad")
        self.sideMenuController()?.sideMenu?.delegate = self
        
        
        self.title = "Precipitation"
        self.view.backgroundColor = UIColor.clearColor()

        var homeButton : UIBarButtonItem = UIBarButtonItem(title: "Menu", style: UIBarButtonItemStyle.Plain, target: self, action: "showMenu")
        self.navigationItem.leftBarButtonItem = homeButton
        
        //make dictionary for views
        self.view.addSubview(_lineChartView)
        self.view.addSubview(_informationView)
        _lineChartView.setTranslatesAutoresizingMaskIntoConstraints(false)
        _informationView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let viewsDictionary = ["view1":_lineChartView,"view2":_informationView]
        
        //position constraints
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view1]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        let view_constraint_H2:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[view2]-10-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        _view_constraint_V = NSLayoutConstraint.constraintsWithVisualFormat("V:|-0-[view1(height)]-[view2]-0-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: ["height": _view_height_portrait], views: viewsDictionary)
        
        view.addConstraints(view_constraint_H as! [NSLayoutConstraint])
        view.addConstraints(view_constraint_H2 as! [NSLayoutConstraint])
        view.addConstraints(_view_constraint_V as! [NSLayoutConstraint])
        
        // Forces to compute the layout size, so JBChartView library does not complain that the footer and headers are bigger than the chart itself.
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        _lineChartView.dataSource = self;
        _lineChartView.delegate = self;
        _lineChartView.backgroundColor = uicolorFromHex(0x3c3c3c)



        // Header
        _headerView.frame = CGRectMake(_padding,ceil(self.view.bounds.size.height * 0.5) - ceil(_headerHeight * 0.5),self.view.bounds.width - _padding*2, _headerHeight)
        _headerView.titleLabel.text = "Loading..."
        _headerView.subtitleLabel.text = "Average Daily Rainfall"
        _lineChartView.headerView = _headerView

        // Footer
        _footerView.frame = CGRectMake(_padding, ceil(self.view.bounds.size.height * 0.5) - ceil(_footerHeight * 0.5),self.view.bounds.width - _padding*2, _footerHeight)
        _footerView.padding = _padding
        _footerView.leftLabel.textColor = UIColor.whiteColor()
        _footerView.rightLabel.textColor = UIColor.whiteColor()
        _lineChartView.footerView = _footerView
        
        // Information View
        //   _informationView.frame = CGRectMake(self.view.bounds.origin.x, CGRectGetMaxY(_lineChartView.frame), self.view.bounds.width, self.view.bounds.size.height - CGRectGetMaxY(_lineChartView.frame))
        
        // Tooltip
        _tooltipView.alpha = 0.0
        _lineChartView.addSubview(_tooltipView)
        _tooltipTipView.alpha = 0.0
        _lineChartView.addSubview(_tooltipTipView)

        //
//        _lineChartView.backgroundColor = UIColor.darkGrayColor();
        _lineChartView.frame = CGRectMake(0, 20, self.view.bounds.width, self.view.bounds.height * 0.5);
        println("Launched");
        
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
                if var rain:Double = day["rain"].asDouble {
                    _chartData.append(Float(rain))
                } else {
                    _chartData.append(Float(0))
                }
                var date:Double = day["dt"].asDouble!
                _chartLegend.append(dateFormatter.stringFromDate(NSDate(timeIntervalSince1970: date)))

                _chartBar.append(DotView(frame: CGRect(x: 0, y: 0, width: 5, height: 5), footer: _footerView))
            }
            _headerView.titleLabel.text = json["city"]["name"].asString
            

            _lineChartView.reloadData()

            
        }
        
    }
    
    func lineChartView(lineChartView: JBLineChartView!, didSelectLineAtIndex lineIndex: UInt, horizontalIndex: UInt, touchPoint: CGPoint) {
        _informationView.setValueText(NSString(format: "%.2f mm", _chartData[Int(horizontalIndex)]))
        _informationView.setTitleText(_chartLegend[Int(horizontalIndex)])
        _informationView.setHidden(false, animated: true)
        
        // Adjust tooltip position
        var convertedTouchPoint:CGPoint = touchPoint
        let minChartX:CGFloat = (_lineChartView.frame.origin.x + ceil(_tooltipView.frame.size.width * 0.5))
        if (convertedTouchPoint.x < minChartX)
        {
            convertedTouchPoint.x = minChartX
        }
        var maxChartX:CGFloat = (_lineChartView.frame.origin.x + _lineChartView.frame.size.width - ceil(_tooltipView.frame.size.width * 0.5))
        if (convertedTouchPoint.x > maxChartX)
        {
            convertedTouchPoint.x = maxChartX
        }
        _tooltipView.frame = CGRectMake(convertedTouchPoint.x - ceil(_tooltipView.frame.size.width * 0.5),
            CGRectGetMaxY(_headerView.frame),
            _tooltipView.frame.size.width,
            _tooltipView.frame.size.height)
        _tooltipView.setText(_chartLegend[Int(horizontalIndex)])
        
        
        var originalTouchPoint:CGPoint = touchPoint
        let minTipX:CGFloat = (_lineChartView.frame.origin.x + _tooltipTipView.frame.size.width)
        if (touchPoint.x < minTipX)
        {
            originalTouchPoint.x = minTipX
        }
        let maxTipX = (_lineChartView.frame.origin.x + _lineChartView.frame.size.width - _tooltipTipView.frame.size.width)
        if (originalTouchPoint.x > maxTipX)
        {
            originalTouchPoint.x = maxTipX
        }
        _tooltipTipView.frame = CGRectMake(originalTouchPoint.x - ceil(_tooltipTipView.frame.size.width * 0.5), CGRectGetMaxY(_tooltipView.frame), _tooltipTipView.frame.size.width, _tooltipTipView.frame.size.height)
        _tooltipView.alpha = 1.0
        _tooltipTipView.alpha = 1.0
    }
    
    func didDeselectLineInLineChartView(lineChartView: JBLineChartView) {
        _informationView.setHidden(true, animated: true)
        _tooltipView.alpha = 0.0
        _tooltipTipView.alpha = 0.0
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfLinesInLineChartView(lineChartView: JBLineChartView!) -> UInt {
        return 1
    }
    
    func lineChartView(lineChartView: JBLineChartView!, numberOfVerticalValuesAtLineIndex lineIndex: UInt) -> UInt {
        return UInt(_chartData.count)
    }
    
    func lineChartView(lineChartView: JBLineChartView!, verticalValueForHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return CGFloat(100 * _chartData[Int(horizontalIndex)])
   }
    
    func lineChartView(lineChartView: JBLineChartView!, widthForLineAtLineIndex lineIndex: UInt) -> CGFloat {
        return 6.0
    }
    
    func lineChartView(lineChartView: JBLineChartView!, colorForLineAtLineIndex lineIndex: UInt) -> UIColor! {
        return UIColor.whiteColor()
    }
    
    func verticalSelectionWidthForLineChartView(lineChartView: JBLineChartView!) -> CGFloat {
        return 16.0;
    }
    

    func lineChartView(lineChartView: JBLineChartView!, showsDotsForLineAtLineIndex lineIndex: UInt) -> Bool {
        return true;
    }
    
    func lineChartView(lineChartView: JBLineChartView!, dotRadiusForDotAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> CGFloat {
        return 10.0
    }

    func lineChartView(lineChartView: JBLineChartView!, dotViewAtHorizontalIndex horizontalIndex: UInt, atLineIndex lineIndex: UInt) -> UIView! {
        var barView = _chartBar[Int(horizontalIndex)]
        barView.legendLabel.text = _chartLegend[Int(horizontalIndex)]
        
        return barView
    }
    
    func lineChartView(lineChartView: JBLineChartView!, smoothLineAtLineIndex lineIndex: UInt) -> Bool {
        return true;
    }
    
     //
    func showMenu() {
        toggleSideMenuView()
    }
    
    
    
    func sideMenuShouldOpenSideMenu() -> Bool {
        println("sideMenuShouldOpenSideMenu")
        return true
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
        
        _lineChartView.setState(JBChartViewState.Collapsed, animated: true)
        
        if (UIDevice.currentDevice().orientation.isLandscape) {
            println("Landscape")
            _headerView.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
            (self._view_constraint_V[1] as! NSLayoutConstraint).constant = _view_height_landscape
        } else {
            println("Portrait")
            _headerView.frame = CGRectMake(_padding,ceil(self.view.bounds.size.height * 0.5) - ceil(_headerHeight * 0.5),self.view.bounds.width - _padding*2, _headerHeight)
            (self._view_constraint_V[1] as! NSLayoutConstraint).constant = _view_height_portrait
        }
        // Refresh the graph once the transition is completed
        coordinator.animateAlongsideTransition(nil, completion: {
            _ in self._lineChartView.reloadData()
            self._lineChartView.setState(JBChartViewState.Expanded, animated: true)
        })
    }

    
    //
    func uicolorFromHex(rgbValue:UInt32)->UIColor{
        let red = CGFloat((rgbValue & 0xFF0000) >> 16)/256.0
        let green = CGFloat((rgbValue & 0xFF00) >> 8)/256.0
        let blue = CGFloat(rgbValue & 0xFF)/256.0
        
        return UIColor(red:red, green:green, blue:blue, alpha:1.0)
    }

    
}
