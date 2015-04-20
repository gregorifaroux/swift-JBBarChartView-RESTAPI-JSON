//

import UIKit

@objc public protocol ENSideMenuDelegate {
    optional func sideMenuWillOpen()
    optional func sideMenuWillClose()
    optional func sideMenuShouldOpenSideMenu () -> Bool
}

@objc public protocol ENSideMenuProtocol {
    var sideMenu : ENSideMenu? { get }
    func setContentViewController(contentViewController: UIViewController)
}


public extension UIViewController {
    
    public func toggleSideMenuView () {
        sideMenuController()?.sideMenu?.toggleMenu()
    }
    
    public func hideSideMenuView () {
        sideMenuController()?.sideMenu?.hideSideMenu()
    }
    
    public func showSideMenuView () {
        
        sideMenuController()?.sideMenu?.showSideMenu()
    }
    
    public func isSideMenuOpen () -> Bool {
        let sieMenuOpen = self.sideMenuController()?.sideMenu?.isMenuOpen
        return sieMenuOpen!
    }
    
    public func sideMenuController () -> ENSideMenuProtocol? {
        var iteration : UIViewController? = self.parentViewController
        if (iteration == nil) {
            return topMostController()
        }
        do {
            if (iteration is ENSideMenuProtocol) {
                return iteration as? ENSideMenuProtocol
            } else if (iteration?.parentViewController != nil && iteration?.parentViewController != iteration) {
                iteration = iteration!.parentViewController
            } else {
                iteration = nil
            }
        } while (iteration != nil)
        
        return iteration as? ENSideMenuProtocol
    }
    
    internal func topMostController () -> ENSideMenuProtocol? {
        var topController : UIViewController? = UIApplication.sharedApplication().keyWindow?.rootViewController
        while (topController?.presentedViewController is ENSideMenuProtocol) {
            topController = topController?.presentedViewController
        }
        
        return topController as? ENSideMenuProtocol
    }
}

public class ENSideMenu : NSObject {
    private var offsetY: CGFloat = 64.0
    
    private let sideMenuContainerView =  UIView()
    private var menuTableViewController : UITableViewController!
    private var animator : UIDynamicAnimator!
    private var sourceView : UIView!
    private var needUpdateApperance : Bool = false
    public weak var delegate : ENSideMenuDelegate?
    private(set) var isMenuOpen : Bool = false

    public init(sourceView: UIView) {
        super.init()
        self.sourceView = sourceView
        self.setupMenuView()
        
        animator = UIDynamicAnimator(referenceView:sourceView)

    }
    
    public convenience init(sourceView: UIView, offsetY: CGFloat, menuTableViewController: UITableViewController) {
        self.init(sourceView: sourceView)
        self.menuTableViewController = menuTableViewController
        
        // Set sizes to table view + padding
        let height = UIApplication.sharedApplication().statusBarFrame.size.height + self.menuTableViewController.tableView.bounds.height
        sideMenuContainerView.frame = CGRectMake(0,
            offsetY - height,
            self.menuTableViewController.tableView.bounds.width,
             height)

        self.offsetY = offsetY
        self.sideMenuContainerView.addSubview(self.menuTableViewController.tableView)
        
        self.menuTableViewController.tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        let viewsDictionary = ["top":self.menuTableViewController.tableView]
        
        //position constraints
        let view_constraint_V:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[top]-|", options: NSLayoutFormatOptions.AlignAllLeading, metrics: nil, views: viewsDictionary)
        let view_constraint_H:NSArray = NSLayoutConstraint.constraintsWithVisualFormat("H:|-[top]-|", options: NSLayoutFormatOptions(0), metrics: nil, views: viewsDictionary)
        
        self.sideMenuContainerView.addConstraints(view_constraint_V as [AnyObject])
        self.sideMenuContainerView.addConstraints(view_constraint_H as [AnyObject])
    }
    
    private func setupMenuView() {
        
        // Configure side menu container

        sideMenuContainerView.backgroundColor = UIColor(red:73.0/255.0, green:73.0/255.0, blue:73.0/255.0, alpha:1.0)
        sideMenuContainerView.clipsToBounds = false
        sideMenuContainerView.layer.masksToBounds = false

        sourceView.addSubview(sideMenuContainerView)

    }
    
    private func toggleMenu (shouldOpen: Bool) {
        if (shouldOpen && delegate?.sideMenuShouldOpenSideMenu?() == false) {
            return
        }
        updateSideMenuApperanceIfNeeded()
        isMenuOpen = shouldOpen

        animator.removeAllBehaviors()
        

        var gravityDirectionY: CGFloat
        var pushMagnitude: CGFloat
        var boundaryPointX: CGFloat
        var boundaryPointY: CGFloat

        let gravity = UIGravityBehavior()
        gravity.addItem(sideMenuContainerView)
        gravity.gravityDirection = CGVectorMake(0, (shouldOpen) ? 1.0 : -1.0)
        animator?.addBehavior(gravity)

        // Will stop @ the height of the menu
        let collider = UICollisionBehavior()

        let menuHeight = sideMenuContainerView.bounds // self.menuTableViewController.tableView.contentSize
        collider.addItem(sideMenuContainerView)
        boundaryPointY = (shouldOpen) ? offsetY + menuHeight.height : offsetY - menuHeight.height
        collider.addBoundaryWithIdentifier("menuBoundary",
                fromPoint: CGPointMake(sourceView.frame.origin.x, boundaryPointY),
                toPoint: CGPointMake(sourceView.frame.width, boundaryPointY))

        animator?.addBehavior(collider)
            

        if (shouldOpen) {
            delegate?.sideMenuWillOpen?()
        } else {
            delegate?.sideMenuWillClose?()
        }
    }

    
    private func updateSideMenuApperanceIfNeeded () {
        if (needUpdateApperance) {
            var frame = sideMenuContainerView.frame
            frame.size.width = sourceView.frame.size.width
            sideMenuContainerView.frame = frame

            needUpdateApperance = false
        }
    }
    
    public func toggleMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
        else {
            updateSideMenuApperanceIfNeeded()
            toggleMenu(true)
        }
    }
    
    public func showSideMenu () {
        if (!isMenuOpen) {
            toggleMenu(true)
        }
    }
    
    public func hideSideMenu () {
        if (isMenuOpen) {
            toggleMenu(false)
        }
    }
}

