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
    
    public init(_ model: ANHeaderViewModel) {
        super.init(frame: CGRectZero)
        setupHeaderView(model)
    }
    
    private func setupHeaderView(model: ANHeaderViewModel) {
        setupLabel(.Title, color: model.titleColor, text: model.title, height: titleHeight)
        setupLabel(.Message, color: model.messageColor, text: model.message, height: messageHeight)
        
        if height > 0 {
            self.frame = CGRectMake(UIScreen.mergin(), 0, UIScreen.buttonWidth(), height)
            let maskPath = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: [UIRectCorner.TopLeft, UIRectCorner.TopRight], cornerRadii:CGSizeMake(6.0, 6.0))
            let maskLayer = CAShapeLayer()
            maskLayer.path = maskPath.CGPath
            self.layer.mask = maskLayer
            self.backgroundColor = model.headerBackgroundColor
        }
    }
    
    private func setupLabel(type: ANLabelType, color: UIColor, text: String, height: CGFloat) {
        guard !text.isEmpty else {
            return
        }
        
        let label = ANLabel()
        label.type = type
        label.color = color
        label.text = text
        label.frame = CGRectMake(0, self.height, UIScreen.buttonWidth(), height)
        self.height += height
        self.addSubview(label)
    }

}
