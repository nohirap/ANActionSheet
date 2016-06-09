//
//  ANLabel.swift
//  Pods
//
//  Created by nohirap on 2016/06/07.
//  Copyright © 2016 nohirap. All rights reserved.
//

import UIKit

enum ANLabelType {
    case Title
    case Message
    
    func font() -> UIFont {
        switch self {
        case .Title:
            return UIFont.boldSystemFontOfSize(16)
        default:
            return UIFont.systemFontOfSize(16)
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .Title:
            return UIColor.grayColor()
        default:
            return UIColor.grayColor()
        }
    }
    
    func numberOfLines() -> Int {
        switch self {
        case .Title:
            return 1
        default:
            return 0
        }
    }
}

class ANLabel: UILabel {
    
    var type: ANLabelType = .Title {
        didSet {
            self.font = type.font()
            self.textColor = type.color()
            self.numberOfLines = type.numberOfLines()
        }
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public init() {
        super.init(frame: CGRectZero)
        self.textAlignment = .Center
    }

}
