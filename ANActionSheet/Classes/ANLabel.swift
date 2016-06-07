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
            return UIFont.systemFontOfSize(12)
        default:
            return UIFont.systemFontOfSize(10)
        }
    }
}

class ANLabel: UILabel {
    
    var type: ANLabelType = .Title {
        didSet {
            self.font = type.font()
        }
    }
    var color = UIColor.grayColor() {
        didSet {
            self.textColor = color
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
