# ANActionSheet

[![CI Status](http://img.shields.io/travis/nohirap/ANActionSheet.svg?style=flat)](https://travis-ci.org/nohirap/ANActionSheet)
[![Version](https://img.shields.io/cocoapods/v/ANActionSheet.svg?style=flat)](http://cocoapods.org/pods/ANActionSheet)
[![License](https://img.shields.io/cocoapods/l/ANActionSheet.svg?style=flat)](http://cocoapods.org/pods/ANActionSheet)
[![Platform](https://img.shields.io/cocoapods/p/ANActionSheet.svg?style=flat)](http://cocoapods.org/pods/ANActionSheet)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ANActionSheet is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "ANActionSheet"
```

## Usage

Import ANActionSheet then use the following codes when you want to show the view.

```ruby
let actionSheet = ANActionSheet(title: "Title", message: "Message!!!")
        let action1 = ANAction(title: "First Button", style: .Default) {
            NSLog("Tap First Button!!!")
        }
        action1.buttonColor = UIColor.redColor()
        actionSheet.addAction(action1)
        
        let action2 = ANAction(title: "Second Button", style: .Default) {
            NSLog("Tap Second Button!!!")
        }
        action2.buttonColor = UIColor.blueColor()
        actionSheet.addAction(action2)
        
        let action3 = ANAction(title: "Third Button", style: .Default) {
            NSLog("Tap Third Button!!!")
        }
        action3.buttonColor = UIColor.yellowColor()
        actionSheet.addAction(action3)
        
        let cancelAction = ANAction(title: "Cancel", style: .Cancel)
        cancelAction.labelColor = UIColor.redColor()
        actionSheet.addAction(cancelAction)
        
        actionSheet.show()
```

## Author

nohirap, zepchan@gmail.com

## License

ANActionSheet is available under the MIT license. See the LICENSE file for more info.
