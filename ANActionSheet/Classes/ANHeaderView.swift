//
//  ANHeaderView.swift
//  Pods
//
//  Created by nohirap on 2016/06/09.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

internal final class ANHeaderView: UIView {
    private let titleHeight: CGFloat = 40.0
    private let messageHeight: CGFloat = 60.0
    var height: CGFloat = 0.0

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, message: String) {
        super.init(frame: CGRectZero)
        setupHeaderView(title, message: message)
    }
    
    private func setupHeaderView(title: String, message: String) {
        if !title.isEmpty {
            let titleLabel = ANLabel()
            titleLabel.type = .Title
            titleLabel.text = title
            titleLabel.frame = CGRectMake(0, 0, UIScreen.buttonWidth(), titleHeight)
            height += titleHeight
            self.addSubview(titleLabel)
        }
        if !message.isEmpty {
            let messageLabel = ANLabel()
            messageLabel.type = .Message
            messageLabel.text = message
            messageLabel.frame = CGRectMake(0, height, UIScreen.buttonWidth(), messageHeight)
            height += messageHeight
            self.addSubview(messageLabel)
        }
        
        if height > 0 {
            self.frame = CGRectMake(UIScreen.mergin(), 0, UIScreen.buttonWidth(), height)
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii:CGSizeMake(6.0, 6.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            self.layer.mask = maskLayer
            self.backgroundColor = UIColor.whiteColor()
        }
    }

}
