//
//  ANActionSheetAction.swift
//  Pods
//
//  Created by nohirap on 2016/06/05.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

protocol ANActionSheetOutPut {
    func dismiss()
}

final public class ANAction: UIButton {
    
    var output: ANActionSheetOutPut?
    var style: ANActionSheetStyle = .Default
    
    public var buttonColor = UIColor.whiteColor() {
        didSet {
            self.backgroundColor = buttonColor
        }
    }
    public var labelColor = UIColor.blackColor() {
        didSet {
            self.setTitleColor(labelColor, forState: .Normal)
        }
    }
    
    private var handler: (() -> Void)?
    
    private let fontSize: CGFloat = 18
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, style: ANActionSheetStyle = .Default, handler: (() -> Void)? = nil) {
        super.init(frame: CGRectZero)
        setupAction(title, style: style, handler: handler)
    }
    
    private func setupAction(title: String, style: ANActionSheetStyle, handler: (() -> Void)?) {
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(labelColor, forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        self.backgroundColor = buttonColor
        self.titleLabel?.lineBreakMode = .ByTruncatingTail
        self.style = style
        if style == .Cancel {
            self.layer.cornerRadius = 6.0
            self.layer.masksToBounds = true
        }
        self.handler = handler
        self.addTarget(self, action:#selector(ANAction.tappedButton(_:)), forControlEvents: .TouchUpInside)
    }
    
    func tappedButton(button: UIButton) {
        if let handler = handler {
            handler()
        }
        output?.dismiss()
    }

}
