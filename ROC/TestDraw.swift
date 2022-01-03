//
//  TestDraw.swift
//  ROC
//
//  Created by Matsui Keiji on 2017/03/22.
//  Copyright © 2017年 Matsui Keiji. All rights reserved.
//

import UIKit

class TestDraw: UIView {
    override func draw(_ rect: CGRect) {
        
        let outerLine = UIBezierPath()
        outerLine.move(to: CGPoint(x: 0.15 * screenWidth, y: 0.15 * screenWidth))
        outerLine.addLine(to: CGPoint(x: 0.15 * screenWidth, y: 0.85 * screenWidth))
        outerLine.addLine(to: CGPoint(x: 0.85 * screenWidth, y: 0.85 * screenWidth))
        UIColor.black.setStroke()
        outerLine.lineWidth = CGFloat(screenWidth / 150.0)
        outerLine.stroke()
        
        for i in 0...5{
            let shortLine = UIBezierPath()
            let x = 0.15 * screenWidth + 0.7 * screenWidth * Double(i) * 0.2
            shortLine.move(to: CGPoint(x: x, y: 0.85 * screenWidth))
            shortLine.addLine(to: CGPoint(x: x, y: 0.85 * screenWidth + 0.02 * screenWidth))
            UIColor.black.setStroke()
            shortLine.lineWidth = CGFloat(screenWidth / 200.0)
            shortLine.stroke()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .center
            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: CGFloat(Int(0.035 * screenWidth)))!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let string = String(Double(i) * 0.2)
            string.draw(with: CGRect(x: x - 0.05 * screenWidth, y: 0.868 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        
        for i in 0...5{
            let shortLine = UIBezierPath()
            let y = 0.15 * screenWidth + 0.7 * screenWidth * Double(i) * 0.2
            shortLine.move(to: CGPoint(x: 0.15 * screenWidth - 0.02 * screenWidth, y: y))
            shortLine.addLine(to: CGPoint(x: 0.15 * screenWidth, y: y))
            UIColor.black.setStroke()
            shortLine.lineWidth = CGFloat(screenWidth / 200.0)
            shortLine.stroke()
            
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            let attrs = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: CGFloat(Int(0.035 * screenWidth)))!, NSAttributedString.Key.paragraphStyle: paragraphStyle]
            let string = String(Double(i) * 0.2)
            let y2 = 0.15 * screenWidth + 0.7 * screenWidth * Double(5 - i) * 0.2
            string.draw(with: CGRect(x: 0.077 * screenWidth, y: y2 - 0.022 * screenWidth, width: 0.1 * screenWidth, height: 0.1 * screenWidth), options: .usesLineFragmentOrigin, attributes: attrs, context: nil)
        }
        
        let line = UIBezierPath()
        line.move(to: CGPoint(x: 0.15 * screenWidth, y: 0.85 * screenWidth))
        for i in 0...sensitivityArray.count-1{
            line.addLine(to: CGPoint(x: 0.15 * screenWidth + 0.7 * screenWidth * oneMinusSpecificityArray[i], y: 0.85 * screenWidth - 0.7 * screenWidth * sensitivityArray[i]))
        }//for i in 0...sensitivityArray.count-1
        line.addLine(to: CGPoint(x: 0.85 * screenWidth, y: 0.15 * screenWidth))
        UIColor.blue.setStroke()
        line.lineWidth = CGFloat(screenWidth / 100.0)
        line.stroke()
    }//override func draw(_ rect: CGRect)
}//class TestDraw: UIView
