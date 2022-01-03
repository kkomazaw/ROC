//
//  ViewController.swift
//  ROC
//
//  Created by Matsui Keiji on 2017/02/26.
//  Copyright © 2017年 Matsui Keiji. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet var enterButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    @IBOutlet var ROCButton: UIButton!
    
    var patientTextView = UITextView()
    var controlTextView = UITextView()
    
    @IBAction func myActionClear(){
        patientTextView.text = ""
        controlTextView.text = ""
        patientTextView.becomeFirstResponder()
    }//@IBAction func myActionClear()
    
    @IBAction func myActionEnter(){
        if patientTextView.isFirstResponder == true{
            patientTextView.insertText("\n")
        }
        if controlTextView.isFirstResponder == true{
            controlTextView.insertText("\n")
        }
    }//@IBAction func myActionEnter()
    
    @IBAction func myActionROC(){
        sensitivityArray = []
        oneMinusSpecificityArray = []
        sensitivity = 0.0
        specificity = 0.0
        cutOff = 0.0
        areaUnderCurve = 0.0
        let patientText = patientTextView.text
        var patientArrayString:Array<String> = []
        patientText?.enumerateLines{(line, stop) -> () in
            patientArrayString.append(line)
        }
        var patientArrayDouble:Array<Double> = []
        var sumOfPatient:Double = 0.0
        for i in patientArrayString{
            if let j = Double(i.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)){
                patientArrayDouble.append(j)
                sumOfPatient = sumOfPatient + j
            }
        }//for i in patientArrayString
        if patientArrayDouble.count <= 1{
            return
        }
        let avarageOfPatient = sumOfPatient / Double(patientArrayDouble.count)
        let controlText = controlTextView.text
        var controlArrayString:Array<String> = []
        controlText?.enumerateLines{(line, stop) -> () in
            controlArrayString.append(line)
        }
        var controlArrayDouble:Array<Double> = []
        var sumOfControl:Double = 0.0
        for i in controlArrayString{
            if let j = Double(i.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)){
                controlArrayDouble.append(j)
                sumOfControl = sumOfControl + j
            }
        }//for i in controlArrayString
        if controlArrayDouble.count <= 1{
            return
        }
        let avarageOfControl = sumOfControl / Double(controlArrayDouble.count)
        if avarageOfPatient == avarageOfControl{
            return
        }
        if avarageOfPatient > avarageOfControl{
            patientArrayDouble.sort{ $1 < $0 }
            controlArrayDouble.sort{ $1 < $0 }
        }
        else{
            patientArrayDouble.sort{ $0 < $1 }
            controlArrayDouble.sort{ $0 < $1 }
        }
        var resultArrayDouble:Array<Double> = []
        for i in patientArrayDouble{
            resultArrayDouble.append(i)
        }
        for i in controlArrayDouble{
            resultArrayDouble.append(i)
        }
        if avarageOfPatient > avarageOfControl{
            resultArrayDouble.sort{ $1 < $0 }
        }
        else{
            resultArrayDouble.sort{ $0 < $1 }
        }
        var cutoffArray:Array<Double> = []
        for i in 0...resultArrayDouble.count-2{
            if resultArrayDouble[i] != resultArrayDouble[i+1]{
            let avarageResult = (resultArrayDouble[i] + resultArrayDouble[i+1])/2.0
                cutoffArray.append(avarageResult)
            }//if resultArrayDouble[i] != resultArrayDouble[i+1]
        }//for i in 0...resultArrayDouble.count-2
        
        if avarageOfPatient > avarageOfControl{
            for i in cutoffArray{
                var patientCountAboveCutoff:Int = 0
                for j in patientArrayDouble{
                    if j > i{
                        patientCountAboveCutoff = patientCountAboveCutoff + 1
                    }//if j > i
                    else{
                        break
                    }
                }//for j in patientArrayDouble
                sensitivityArray.append(Double(patientCountAboveCutoff) / Double(patientArrayDouble.count))
                var controlCountAboveCutoff:Int = 0
                for j in controlArrayDouble{
                    if j > i{
                        controlCountAboveCutoff = controlCountAboveCutoff + 1
                    }//if j > i
                    else{
                        break
                    }
                }//for j in controlArrayDouble
                oneMinusSpecificityArray.append(1.0 - Double((controlArrayDouble.count)-controlCountAboveCutoff) / Double(controlArrayDouble.count))
            }//for i in cutoffArray
        }//if avarageOfPatient > avarageOfControl
        if avarageOfPatient < avarageOfControl{
            for i in cutoffArray{
                var patientCountAboveCutoff:Int = 0
                for j in patientArrayDouble{
                    if j < i{
                        patientCountAboveCutoff = patientCountAboveCutoff + 1
                    }//if j < i
                    else{
                        break
                    }
                }//for j in patientArrayDouble
                sensitivityArray.append(Double(patientCountAboveCutoff) / Double(patientArrayDouble.count))
                var controlCountAboveCutoff:Int = 0
                for j in controlArrayDouble{
                    if j < i{
                        controlCountAboveCutoff = controlCountAboveCutoff + 1
                    }//if j < i
                    else{
                        break
                    }
                }//for j in controlArrayDouble
                oneMinusSpecificityArray.append(1.0 - Double((controlArrayDouble.count)-controlCountAboveCutoff) / Double(controlArrayDouble.count))
            }//for i in cutoffArray
        }//if avarageOfPatient < avarageOfControl
        var sumOfSensitivityAndSpecificity:Double = 0
        var maxSumOfSensitivityAndSpecificity:Double = 0
        var optimalIndexOfCutoff:Int = 0
        for i in 0...cutoffArray.count-1 {
            sumOfSensitivityAndSpecificity = sensitivityArray[i] + 1.0 - oneMinusSpecificityArray[i]
            if sumOfSensitivityAndSpecificity > maxSumOfSensitivityAndSpecificity {
                maxSumOfSensitivityAndSpecificity = sumOfSensitivityAndSpecificity
                optimalIndexOfCutoff = i
            }
        }//for i in 0...cutoffArray.count-1
        cutOff = cutoffArray[optimalIndexOfCutoff]
        sensitivity = sensitivityArray[optimalIndexOfCutoff]
        specificity = 1.0 - oneMinusSpecificityArray[optimalIndexOfCutoff]
        for i in 0...cutoffArray.count-2 {
            areaUnderCurve = areaUnderCurve + (sensitivityArray[i] + sensitivityArray[i+1])*(oneMinusSpecificityArray[i+1]-oneMinusSpecificityArray[i])/2.0
        }
        areaUnderCurve = areaUnderCurve + sensitivityArray.first! * oneMinusSpecificityArray.first! / 2.0
        areaUnderCurve = areaUnderCurve + (sensitivityArray.last! + 1.0)*(1.0 - oneMinusSpecificityArray.last!) / 2.0
    }//@IBAction func myActionROC()

    override func viewDidLoad() {
        super.viewDidLoad()
        screenWidth = Double(self.view.bounds.width)
        screenHeight = Double(self.view.bounds.height)
        var myFontSize:Int = Int(0.045 * screenWidth)
        var heightAdjust:Double = 0.0
        if UIDevice.current.userInterfaceIdiom == .pad{
            myFontSize = Int(0.025 * screenWidth)
            heightAdjust = 0.05 * screenHeight
        }
        let patientTitle = UILabel()
        patientTitle.frame = CGRect( x:0.025 * screenWidth, y:0.13 * screenHeight - heightAdjust, width:0.33 * screenWidth, height:0.05 * screenHeight)
        patientTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(myFontSize))
        patientTitle.text = "↓patient data"
        patientTitle.textAlignment = NSTextAlignment.center
        patientTitle.sizeToFit()
        view.addSubview(patientTitle)
        let controlTitle = UILabel()
        controlTitle.frame = CGRect( x:0.4 * screenWidth, y:0.13 * screenHeight - heightAdjust, width:0.33 * screenWidth, height:0.05 * screenHeight)
        controlTitle.font = UIFont(name: "HelveticaNeue", size: CGFloat(myFontSize))
        controlTitle.text = "↓control data"
        controlTitle.textAlignment = NSTextAlignment.center
        controlTitle.sizeToFit()
        view.addSubview(controlTitle)
        patientTextView.frame = CGRect( x:0.025 * screenWidth, y:0.168 * screenHeight - heightAdjust, width:0.33 * screenWidth, height:0.445 * screenHeight + 2 * heightAdjust)
        patientTextView.font = UIFont(name: "HelveticaNeue", size: CGFloat(myFontSize))
        patientTextView.backgroundColor = #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        self.patientTextView.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(patientTextView)
        controlTextView.frame = CGRect( x:0.4 * screenWidth, y:0.168 * screenHeight - heightAdjust, width:0.33 * screenWidth, height:0.445 * screenHeight + 2 * heightAdjust)
        controlTextView.font = UIFont(name: "HelveticaNeue", size: CGFloat(myFontSize))
        controlTextView.backgroundColor = #colorLiteral(red: 0.9499699473, green: 0.9504894614, blue: 0.965736568, alpha: 1)
        self.controlTextView.keyboardType = UIKeyboardType.decimalPad
        view.addSubview(controlTextView)
       // patientTextView.becomeFirstResponder()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

