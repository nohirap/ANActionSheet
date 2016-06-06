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
    private let mergin: CGFloat = 5.0
    private let borderLine: CGFloat = 1.0
    private let titleHeight: CGFloat = 40.0
    private let messageHeight: CGFloat = 40.0
    private let displaySize = UIScreen.mainScreen().bounds.size
    
    private var titleLabel = UILabel()
    private var messageLabel = UILabel()
    private var actions = [ANAction]()
    private var sheetViewMoveY: CGFloat = 0.0
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String = "", message: String = "") {
        super.init(frame: CGRectZero)
        
        titleLabel.text = title
        messageLabel.text = message
        
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
        
        let titleView = UIView()
        let defaultsView = UIView()
        let buttonSize = CGSizeMake(displaySize.width - (mergin * 2), 50)
        
        var cancelView: UIView?
        var actionCount = 0
        var titleViewHeight: CGFloat = 0.0
        
        titleView.backgroundColor = UIColor.whiteColor()
        if !titleLabel.text!.isEmpty {
            titleLabel.frame = CGRectMake(0, 0, buttonSize.width, titleHeight)
            titleViewHeight += titleHeight
            titleView.addSubview(titleLabel)
        }
        if !messageLabel.text!.isEmpty {
            messageLabel.frame = CGRectMake(0, titleViewHeight, buttonSize.width, messageHeight)
            titleViewHeight += messageHeight
            titleView.addSubview(messageLabel)
        }
        if titleViewHeight > 0 {
            titleView.frame = CGRectMake(mergin, 0, buttonSize.width, titleViewHeight)
            sheetView.addSubview(titleView)
        }
        
        for action in actions {
            if action.style == .Cancel {
                action.frame = CGRectMake(0, 0, buttonSize.width, buttonSize.height)
                cancelView = UIView()
                cancelView?.addSubview(action)
            } else {
                action.frame = CGRectMake(0, (buttonSize.height + borderLine) * CGFloat(actionCount), buttonSize.width, buttonSize.height)
                defaultsView.addSubview(action)
                actionCount += 1
            }
        }
        
        var frameHeight = (buttonSize.height + borderLine) * CGFloat(actionCount)
        defaultsView.frame = CGRectMake(mergin, titleViewHeight, buttonSize.width, frameHeight)
        if let cancelView = cancelView {
            cancelView.frame = CGRectMake(mergin, titleViewHeight + frameHeight + mergin, buttonSize.width, buttonSize.height)
            frameHeight += mergin + buttonSize.height
        }
        sheetViewMoveY = titleViewHeight + frameHeight + mergin
        
        sheetView.frame = CGRectMake(0, displaySize.height, buttonSize.width, titleViewHeight + frameHeight)
        
        sheetView.addSubview(defaultsView)
        if let cancelView = cancelView {
            sheetView.addSubview(cancelView)
        }
        self.addSubview(sheetView)
        UIView.animateWithDuration(0.5) {
            self.sheetView.frame = CGRectOffset(self.sheetView.frame, 0, -self.sheetViewMoveY)
        }
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
