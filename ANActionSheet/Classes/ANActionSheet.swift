//
//  ANActionSheet.swift
//  Pods
//
//  Created by nohirap on 2016/06/05.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

public enum ANActionSheetStyle {
    case Default
    case Cancel
}

final public class ANActionSheet: UIView {
    
    private let sheetView = UIView()
    private let borderLine: CGFloat = 1.0
    
    private var actions = [ANAction]()
    private var sheetViewMoveY: CGFloat = 0.0
    private var titleText = ""
    private var messageText = ""
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String = "", message: String = "") {
        super.init(frame: CGRectZero)
        
        titleText = title
        messageText = message
        
        self.frame = UIScreen.mainScreen().bounds
        self.backgroundColor  = UIColor(white: 0, alpha: 0.25)
        
    }
    
    public func addAction(action: ANAction) {
        action.output = self
        actions.append(action)
    }
    
    public func show() {
        let viewTag = 100
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
        if let keyWindow = UIApplication.sharedApplication().keyWindow {
            if keyWindow.viewWithTag(viewTag) == nil {
                self.tag = viewTag
                keyWindow.addSubview(self)
            }
        } else {
            return
        }
        
        if actions.count == 0 {
            return
        }
        
        let headerView = ANHeaderView(title: titleText, message: messageText)
        if headerView.height > 0 {
            sheetView.addSubview(headerView)
        }
        
        let frameHeight = createButtonsView(headerView.height)
        
        sheetView.frame = CGRectMake(0, UIScreen.height(), UIScreen.buttonWidth(), headerView.height + frameHeight)
        self.addSubview(sheetView)
        
        UIView.animateWithDuration(0.5) {
            self.sheetView.frame = CGRectOffset(self.sheetView.frame, 0, -self.sheetViewMoveY)
        }
    }
    
    private func createButtonsView(headerHeight: CGFloat) -> CGFloat {
        let defaultsView = UIView()
        var cancelView: UIView?
        var actionCount = 0
        var firstAction: ANAction!
        var lastAction: ANAction!
        
        // Setting buttons
        for action in actions {
            if action.style == .Cancel {
                if let _ = cancelView {
                    // Cancel button only one.
                    continue
                }
                action.frame = CGRectMake(0, 0, UIScreen.buttonWidth(), UIScreen.buttonHeight())
                cancelView = UIView()
                cancelView?.addSubview(action)
            } else {
                if actionCount > 6 {
                    // Default button rimit 7.
                    continue
                }
                action.frame = CGRectMake(0, (UIScreen.buttonHeight() + borderLine) * CGFloat(actionCount), UIScreen.buttonWidth(), UIScreen.buttonHeight())
                defaultsView.addSubview(action)
                if firstAction == nil {
                    firstAction = action
                }
                lastAction = action
                actionCount += 1
            }
        }
        
        // Setting corners
        if headerHeight == 0 && actionCount > 1 {
            let maskPath = UIBezierPath(roundedRect: firstAction.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii:CGSizeMake(6.0, 6.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            firstAction.layer.mask = maskLayer
        }
        if actionCount == 1 {
            lastAction.layer.cornerRadius = 6.0
            lastAction.layer.masksToBounds = true
        } else {
            let maskPath = UIBezierPath(roundedRect: lastAction.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii:CGSizeMake(6.0, 6.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            lastAction.layer.mask = maskLayer
        }
        
        // Setting views frame
        var frameHeight = (UIScreen.buttonHeight() + borderLine) * CGFloat(actionCount)
        defaultsView.frame = CGRectMake(UIScreen.mergin(), headerHeight, UIScreen.buttonWidth(), frameHeight)
        if let cancelView = cancelView {
            cancelView.frame = CGRectMake(UIScreen.mergin(), headerHeight + frameHeight + UIScreen.mergin(), UIScreen.buttonWidth(), UIScreen.buttonHeight())
            frameHeight += UIScreen.mergin() + UIScreen.buttonHeight()
        }
        
        sheetView.addSubview(defaultsView)
        if let cancelView = cancelView {
            sheetView.addSubview(cancelView)
        }
        
        sheetViewMoveY = headerHeight + frameHeight + UIScreen.mergin()
        
        return frameHeight
    }

}

// MARK: - ANActionSheetOutPut
extension ANActionSheet: ANActionSheetOutPut {
    func dismiss() {
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
            self.sheetView.frame = CGRectOffset(self.sheetView.frame , 0, self.sheetViewMoveY)
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
}
