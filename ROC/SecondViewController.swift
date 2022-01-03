//
//  SecondViewController.swift
//  ROC
//
//  Created by Matsui Keiji on 2017/03/22.
//  Copyright © 2017年 Matsui Keiji. All rights reserved.
//

import UIKit

class SecondViewController: ViewController {
    
    @IBOutlet var screenShotButton: UIBarButtonItem!

    override func viewDidLoad() {
        super.viewDidLoad()
        for subview in view.subviews{
            subview.removeFromSuperview()
        }
        if sensitivityArray == []{
            return
        }
        let testDraw = TestDraw(frame: CGRect(x: 0, y: screenHeight - screenWidth, width: screenWidth, height: screenWidth))
        testDraw.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.view.addSubview(testDraw)
        let label = UILabel()
        view.addSubview(label)
        label.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/18)))
        label.text = "sensitivity"
        label.textAlignment = NSTextAlignment.center
        label.sizeToFit()
        label.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        label.frame = CGRect( x:0, y:screenHeight - screenWidth, width:0.07 * screenWidth, height:screenWidth)
        let oneMinusSpecificityLabel = UILabel()
        view.addSubview(oneMinusSpecificityLabel)
        oneMinusSpecificityLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/18)))
        oneMinusSpecificityLabel.text = "1-specificity"
        oneMinusSpecificityLabel.textAlignment = NSTextAlignment.center
        oneMinusSpecificityLabel.sizeToFit()
        oneMinusSpecificityLabel.frame = CGRect( x:0, y:0.93 * screenHeight, width:screenWidth, height:0.07 * screenHeight )
               
        let cutoffLabel = UILabel()
        let sensitivityLabel = UILabel()
        let specificityLabel = UILabel()
        let areaUnderCurveLabel = UILabel()
        
        var heightAdjust:Double = screenHeight * 0.12
        if UIDevice.current.userInterfaceIdiom == .pad{
            heightAdjust = 0.0
        }
        
        view.addSubview(cutoffLabel)
        cutoffLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/20)))
        cutoffLabel.text = "optimal cutoff   " + String(round(cutOff * 1000) / 1000)
        cutoffLabel.textAlignment = NSTextAlignment.left
        cutoffLabel.sizeToFit()
        cutoffLabel.frame = CGRect( x:0.24 * screenWidth, y:0.07 * screenHeight + heightAdjust, width:0.7 * screenWidth, height:0.07 * screenHeight )
        view.addSubview(sensitivityLabel)
        sensitivityLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/20)))
        sensitivityLabel.text = "sensitivity         " + String(round(sensitivity * 1000) / 1000)
        sensitivityLabel.textAlignment = NSTextAlignment.left
        sensitivityLabel.sizeToFit()
        sensitivityLabel.frame = CGRect( x:0.24 * screenWidth, y:0.13 * screenHeight + heightAdjust, width:0.7 * screenWidth, height:0.07 * screenHeight )
        view.addSubview(specificityLabel)
        specificityLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/20)))
        specificityLabel.text = "specificity         " + String(round(specificity * 1000) / 1000)
        specificityLabel.textAlignment = NSTextAlignment.left
        specificityLabel.sizeToFit()
        specificityLabel.frame = CGRect( x:0.24 * screenWidth, y:0.19 * screenHeight + heightAdjust, width:0.7 * screenWidth, height:0.07 * screenHeight )
        view.addSubview(areaUnderCurveLabel)
        areaUnderCurveLabel.font = UIFont(name: "HelveticaNeue", size: CGFloat(Int(screenWidth/20)))
        areaUnderCurveLabel.text = "AUC                  " + String(round(areaUnderCurve * 1000) / 1000)
        areaUnderCurveLabel.textAlignment = NSTextAlignment.left
        areaUnderCurveLabel.sizeToFit()
        areaUnderCurveLabel.frame = CGRect( x:0.24 * screenWidth, y:0.25 * screenHeight + heightAdjust, width:0.7 * screenWidth, height:0.07 * screenHeight )
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func myActionScreenShot(){
        let rect = self.view.bounds
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        self.view.layer.render(in: context)
        let capturedImage : UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        UIImageWriteToSavedPhotosAlbum(capturedImage, self, #selector(self.showResultOfSaveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func showResultOfSaveImage(_ image: UIImage, didFinishSavingWithError error: NSError!, contextInfo: UnsafeMutableRawPointer) {
        var title = "SAVED"
        var message = "Image was saved in Photo Library."
        if error != nil {
            title = "error"
            message = "Image was not saved.\n\nYou can change the setting via\nSettings > Privacy > Photos."
        }
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
