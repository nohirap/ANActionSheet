//
//  ANActionSheet.swift
//  Pods
//
//  Created by nohirap on 2016/06/05.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

final public class ANActionSheet: UIView {
    
    private let sheetView = UIView()
    private let borderLine: CGFloat = 1.0
    private let cornerRadius: CGFloat = 6.0
    private let animateDuration = 0.5
    
    private var actions = [ANAction]()
    private var sheetViewMoveY: CGFloat = 0.0
    private var titleText = ""
    private var messageText = ""
    
    public var headerBackgroundColor = UIColor.defaultBackgroundColor()
    public var titleColor = UIColor.defaultTextColor()
    public var messageColor = UIColor.defaultTextColor()
    public var buttonsBorderColor = UIColor.defaultButtonsBorderColor()
    
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
        if actions.count == 0 {
            return
        }
        
        let viewTag = 1000
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
        
        let headerView = ANHeaderView(model: setupHeaderViewModel())
        if headerView.height > 0 {
            sheetView.addSubview(headerView)
        }
        
        let frameHeight = createButtonsView(headerView.height)
        
        sheetView.frame = CGRectMake(0, UIScreen.height(), UIScreen.buttonWidth(), headerView.height + frameHeight)
        self.addSubview(sheetView)
        
        UIView.animateWithDuration(animateDuration) {
            self.sheetView.frame = CGRectOffset(self.sheetView.frame, 0, -self.sheetViewMoveY)
        }
    }
    
    private func setupHeaderViewModel() -> ANHeaderViewModel {
        var headerViewModel = ANHeaderViewModel()
        headerViewModel.title = titleText
        headerViewModel.message = messageText
        headerViewModel.headerBackgroundColor = headerBackgroundColor
        headerViewModel.titleColor = titleColor
        headerViewModel.messageColor = messageColor
        return headerViewModel
    }
    
    private func createButtonsView(headerHeight: CGFloat) -> CGFloat {
        let defaultsView = UIView()
        var cancelView: UIView?
        var actionCount = 0
        var firstAction: ANAction!
        var lastAction: ANAction!
        
        // Setting buttons
        var buttonsY: CGFloat = 0.0
        for action in actions {
            if action.style == .Cancel {
                if let _ = cancelView {
                    // Cancel button only one.
                    continue
                }
                action.setupFrame(0)
                cancelView = UIView()
                cancelView?.addSubview(action)
            } else {
                if actionCount > 6 {
                    // Default button rimit 7.
                    continue
                }
                
                if firstAction == nil {
                    firstAction = action
                } else {
                    let border = UIView()
                    border.frame = CGRectMake(0, buttonsY, UIScreen.buttonWidth(), borderLine)
                    border.backgroundColor = buttonsBorderColor
                    defaultsView.addSubview(border)
                    buttonsY += borderLine
                }
                buttonsY += action.setupFrame(buttonsY)
                defaultsView.addSubview(action)
                lastAction = action
                actionCount += 1
            }
        }
        
        // Setting corners
        if headerHeight == 0 {
            if actionCount > 1 {
                let maskPath = UIBezierPath(roundedRect: firstAction.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii:CGSizeMake(cornerRadius, cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = maskPath.CGPath
                firstAction.layer.mask = maskLayer
            } else {
                lastAction.layer.cornerRadius = cornerRadius
                lastAction.layer.masksToBounds = true
            }
        }
        if headerHeight > 0 || actionCount > 1 {
            let maskPath = UIBezierPath(roundedRect: lastAction.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii:CGSizeMake(cornerRadius, cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            lastAction.layer.mask = maskLayer
        }
        
        // Setting views frame
        var frameHeight = buttonsY
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
        UIView.animateWithDuration(animateDuration, delay: 0.0, options: .CurveEaseOut, animations: {
            self.sheetView.frame = CGRectOffset(self.sheetView.frame , 0, self.sheetViewMoveY)
        }, completion: { (finished) in
            self.removeFromSuperview()
        })
    }
}
