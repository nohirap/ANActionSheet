//
//  UIScreen.swift
//  Pods
//
//  Created by nohirap on 2016/06/09.
//  Copyright © 2016 nohirap. All rights reserved.
//

internal extension UIScreen {
    
    class func width() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.width
    }
    
    class func height() -> CGFloat {
        return UIScreen.mainScreen().bounds.size.height
    }
    
    class func mergin() -> CGFloat {
        return 5.0
    }
    
    class func buttonWidth() -> CGFloat {
        return width() - (mergin() * 2)
    }
    
    class func buttonHeight() -> CGFloat {
        return 50.0
    }

}
