//
//  ANActionSheetAction.swift
//  Pods
//
//  Created by nohirap on 2016/06/05.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

public enum ANActionStyle {
    case Default
    case Cancel
    
    var isDefault: Bool {
        if self == .Default {
            return true
        }
        return false
    }
}

protocol ANActionOutPut {
    func tappedButton(buttonIndex: Int)
}

final public class ANAction: UIButton {
    
    override public var highlighted: Bool {
        didSet {
            self.alpha = (highlighted) ? 0.8 : 1.0
        }
    }
    
    var output: ANActionOutPut?
    var index = -1
    var style: ANActionStyle = .Default {
        didSet {
            if style == .Cancel {
                self.layer.cornerRadius = 6.0
                self.layer.masksToBounds = true
            }
        }
    }
    
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
    public var labelNumberOfLines = 0 {
        didSet {
            self.titleLabel?.numberOfLines = labelNumberOfLines
        }
    }
    
    private var handler: (() -> Void)?
    
    private let fontSize: CGFloat = 18
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init(title: String, style: ANActionStyle = .Default, handler: (() -> Void)? = nil) {
        super.init(frame: CGRectZero)
        setupAction(title, style: style, handler: handler)
    }
    
    private func setupAction(title: String, style: ANActionStyle, handler: (() -> Void)?) {
        self.setTitle(title, forState: .Normal)
        self.setTitleColor(labelColor, forState: .Normal)
        self.titleLabel?.font = UIFont.systemFontOfSize(fontSize)
        self.backgroundColor = buttonColor
        self.titleLabel?.lineBreakMode = .ByWordWrapping
        self.titleLabel?.sizeToFit()
        self.style = style
        self.handler = handler
        self.addTarget(self, action:#selector(ANAction.tappedButton(_:)), forControlEvents: .TouchUpInside)
    }
    
    private func lineNumber(label: UILabel, text: String) -> Int {
        let oneLineRect  =  "a".boundingRectWithSize(label.bounds.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
        let boundingRect = text.boundingRectWithSize(label.bounds.size, options: .UsesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil)
        
        return Int(boundingRect.height / oneLineRect.height)
    }
    
    private func calcButtonHeight(numberOflines: Int) -> CGFloat {
        if numberOflines == 1 {
            return UIScreen.buttonHeight()
        } else {
            return (UIScreen.buttonHeight() / 2) * CGFloat(numberOflines)
        }
    }
    
    func setupFrame(y: CGFloat) -> CGFloat {
        guard let titleLabel = self.titleLabel, text = titleLabel.text else {
            return y
        }
        
        let buttonHeight: CGFloat
        if labelNumberOfLines == 0 {
            buttonHeight = calcButtonHeight(lineNumber(titleLabel, text: text))
        } else {
            buttonHeight = calcButtonHeight(labelNumberOfLines)
        }
        self.frame = CGRectMake(0, y, UIScreen.buttonWidth(), buttonHeight)
        
        return buttonHeight
    }
    
    func tappedButton(button: UIButton) {
        if let handler = handler {
            handler()
        }
        output?.tappedButton(index)
    }

}
