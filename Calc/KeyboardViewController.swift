//
//  KeyboardViewController.swift
//  Calc
//
//  Created by Mark on 1/15/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    // buttons
    @IBOutlet var nextKeyboardButton: UIButton!
    
    // labels
    @IBOutlet var display: UILabel!
    
    // flags
    var shouldClearDisplayBeforeInserting = true
    
    // ui calc view
    var calcView: UIView!
    
    // MARK: View Initialization

    override func viewDidLoad()
    {
        super.viewDidLoad()
    
        // load custom interface and clear display
        loadInterface()
        clearDisplay()
        
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated
    }
    
    
    override func updateViewConstraints()
    {
        super.updateViewConstraints()
        
        // Add custom view sizing constraints here
    }

    // MARK: UIInputView Functions
    
    override func textWillChange(textInput: UITextInput)
    {
        // The app is about to change the document's contents. Perform any preparation here.
    }

    override func textDidChange(textInput: UITextInput)
    {
        // The app has just changed the document's contents, the document context has been updated.
    
        var textColor: UIColor
        var proxy = self.textDocumentProxy as UITextDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.Dark {
            textColor = UIColor.whiteColor()
        } else {
            textColor = UIColor.blackColor()
        }
    }
    
    // MARK: UI Functions
    
    func loadInterface()
    {
        // load nib file
        var calcNib = UINib(nibName: "Calc", bundle: nil)
        
        // instantiate view
        calcView = calcNib.instantiateWithOwner(self, options: nil)[0] as UIView
        
        // add interface to main view
        view.addSubview(calcView)
        
        // copy the background color
        view.backgroundColor = calcView.backgroundColor
        
        // make button call advanceToNextInput
        nextKeyboardButton.addTarget(self, action: "advanceToNextInputMode", forControlEvents: .TouchUpInside)
    }
    
    @IBAction func clearDisplay()
    {
        display.text = "0"
        shouldClearDisplayBeforeInserting = true
    }
    
    @IBAction func didTapNumber(number: UIButton)
    {
        if shouldClearDisplayBeforeInserting {
            display.text = ""
            shouldClearDisplayBeforeInserting = false
        }
        
        // use titleLabel of button to determine which number is tapped
        if var numberAsString = number.titleLabel?.text {
            var numberAsNSString = numberAsString as NSString
            if var oldDisplay = display?.text! {
               display.text = "\(oldDisplay)\(numberAsNSString.intValue)"
            } else {
                display.text = "\(numberAsNSString.intValue)"
            }
        }
    }
    
    @IBAction func didTapDot()
    {
        // check for dot already in display
        if let input = display?.text {
            var hasDot = false
            for ch in input.unicodeScalars {
                if ch == "." {
                    hasDot = true
                    break
                }
            }
            // if no dot, add one
            if hasDot == false {
                display.text = "\(input)."
            }
        }
    }

}
