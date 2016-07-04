//
//  ANActionSheet.swift
//  Pods
//
//  Created by nohirap on 2016/06/05.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

@objc public protocol ANActionSheetDelegate {
    func anActionSheet(actionSheet: ANActionSheet, clickedButtonAtIndex buttonIndex: Int)
    optional func anActionSheetCancel(actionSheet: ANActionSheet)
}

final public class ANActionSheet: UIView {
    
    private let sheetView = UIView()
    private let borderLine: CGFloat = 1.0
    private let cornerRadius: CGFloat = 6.0
    private let animateDuration = 0.5
    private let cancelIndex = -1
    
    private var delegate: ANActionSheetDelegate?
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
    
    public init(title: String = "", message: String = "", delegate: ANActionSheetDelegate? = nil) {
        super.init(frame: CGRectZero)
        
        titleText = title
        messageText = message
        self.delegate = delegate
        
        self.frame = UIScreen.mainScreen().bounds
        self.backgroundColor  = UIColor(white: 0, alpha: 0.25)
    }
    
    public func addAction(action: ANAction) {
        action.output = self
        actions.append(action)
    }
    
    public func show() {
        if notExistDefaultButton() {
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
        
        let headerView = ANHeaderView(setupHeaderViewModel())
        if headerView.height > 0 {
            sheetView.addSubview(headerView)
        }
        
        let frameHeight = createButtonsView(headerView.height)
        
        sheetView.frame = CGRectMake(0, UIScreen.height(), UIScreen.buttonWidth(), headerView.height + frameHeight)
        self.addSubview(sheetView)
        
        UIView.performSystemAnimation(.Delete,
                                      onViews: [],
                                      options: [],
                                      animations: {
                                        
                                        self.sheetView.frame = CGRectOffset(self.sheetView.frame, 0, -self.sheetViewMoveY)
                                      },
                                      completion: nil)
    }
    
    public func dismiss() {
        
        UIView.performSystemAnimation(.Delete,
                                      onViews: [],
                                      options: [],
                                      animations: {
                                        
                                        self.sheetView.frame = CGRectOffset(self.sheetView.frame , 0, self.sheetViewMoveY)
                                      },
                                      completion: { _ in
                                        
                                        self.removeFromSuperview()
                                      })
    }
    
    private func notExistDefaultButton() -> Bool {
        return actions.filter{$0.style.isDefault}.count == 0
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
        var firstAction: ANAction?
        var lastAction: ANAction?
        
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
                action.index = actionCount
                defaultsView.addSubview(action)
                lastAction = action
                actionCount += 1
            }
        }
        
        guard let openedFirstAction = firstAction, openedLastAction = lastAction else {
            return 0
        }
        
        // Setting corners
        if headerHeight == 0 {
            if actionCount > 1 {
                let maskPath = UIBezierPath(roundedRect: openedFirstAction.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii:CGSizeMake(cornerRadius, cornerRadius))
                let maskLayer = CAShapeLayer()
                maskLayer.path = maskPath.CGPath
                openedFirstAction.layer.mask = maskLayer
            } else {
                openedLastAction.layer.cornerRadius = cornerRadius
                openedLastAction.layer.masksToBounds = true
            }
        }
        if headerHeight > 0 || actionCount > 1 {
            let maskPath = UIBezierPath(roundedRect: openedLastAction.bounds, byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight], cornerRadii:CGSizeMake(cornerRadius, cornerRadius))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            openedLastAction.layer.mask = maskLayer
        }
        
        // Setting views frame
        var frameHeight = buttonsY
        defaultsView.frame = CGRectMake(UIScreen.mergin(), headerHeight, UIScreen.buttonWidth(), frameHeight)
        sheetView.addSubview(defaultsView)
        if let cancelView = cancelView {
            cancelView.frame = CGRectMake(UIScreen.mergin(), headerHeight + frameHeight + UIScreen.mergin(), UIScreen.buttonWidth(), UIScreen.buttonHeight())
            sheetView.addSubview(cancelView)
            frameHeight += UIScreen.mergin() + UIScreen.buttonHeight()
        }
        
        sheetViewMoveY = headerHeight + frameHeight + UIScreen.mergin()
        
        return frameHeight
    }
}

// MARK: - ANActionOutPut
extension ANActionSheet: ANActionOutPut {
    func tappedButton(buttonIndex: Int) {
        guard let delegate = delegate else {
            dismiss()
            return
        }
        
        guard buttonIndex > cancelIndex else {
            delegate.anActionSheetCancel?(self) ?? dismiss()
            return
        }
        
        delegate.anActionSheet(self, clickedButtonAtIndex: buttonIndex)
    }
}
