//
//  KeyboardViewController.swift
//  Calc
//
//  Created by Mark on 1/15/15.
//  Copyright (c) 2015 MEB. All rights reserved.
//

import UIKit

enum Operation {
    case Addition
    case Multiplication
    case Subtraction
    case Division
    case None
}

class KeyboardViewController: UIInputViewController {

    // buttons
    @IBOutlet var nextKeyboardButton: UIButton!
    
    // labels
    @IBOutlet var display: UILabel!
    
    // flags
    var shouldCompute = false
    var shouldClearDisplayBeforeInserting = true
    
    // memory vars
    var internalMemory = 0.0
    var nextOperation = Operation.None
    
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
        internalMemory = 0.0
        nextOperation = Operation.Addition
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
    
    @IBAction func didTapInsert()
    {
        // add calc display text to insertion point
        var proxy = textDocumentProxy as UITextDocumentProxy
        
        if let input = display?.text as String? {
            proxy.insertText(input)
        }
    }

    @IBAction func didTapOperation(operation: UIButton)
    {
        if shouldCompute {
            computeLastOperation()
        }
        
        if var op = operation.titleLabel?.text {
            switch op {
                case "+":
                    nextOperation = Operation.Addition
                case "-":
                    nextOperation = Operation.Subtraction
                case "X":
                    nextOperation = Operation.Multiplication
                case "/":
                    nextOperation = Operation.Division
                default:
                    nextOperation = Operation.None
            }
        }
    }
    
    @IBAction func computeLastOperation()
    {
        // remember not to compute if another op is pressed without inputting another number first
        shouldCompute = false
        
        if var input = display?.text {
            var inputAsDouble = (input as NSString).doubleValue
            var result = 0.0
        
            // apply respective operation
            switch nextOperation {
            case .Addition:
                result = internalMemory + inputAsDouble
            case .Subtraction:
                result = internalMemory - inputAsDouble
            case .Multiplication:
                result = internalMemory * inputAsDouble
            case .Division:
                result = internalMemory / inputAsDouble
            default:
                result = 0.0
            }
            
            nextOperation = Operation.None
            
            var output = "\(result)"
            
            // if the result is an integer, remove decimal
            if output.hasSuffix(".0") {
                output = "\(Int(result))"
            }
            
            // truncate result to the last five digits
            var components = output.componentsSeparatedByString(".")
            if components.count >= 2 {
                var beforePoint = components[0]
                var afterPoint = components[1]
                if afterPoint.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) > 5 {
                    let index: String.Index = advance(afterPoint.startIndex, 5)
                    afterPoint = afterPoint.substringToIndex(index)
                }
                output = beforePoint + "." + afterPoint
            }
            
            // update display
            display.text = output
            
            // save result
            internalMemory = result
            
            // remember to clear display before inserting a new number
            shouldClearDisplayBeforeInserting = true
        }
    }
}


class RoundButton: UIButton {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}


class RoundLabel: UILabel {
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
}
