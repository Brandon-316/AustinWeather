//
//  BackgroundView.swift
//  Austin Weather
//
//  Created by Brandon Mahoney on 8/8/16.
//

import UIKit

class BackgroundView: UIView {
    
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
        // Background View
        
        //// Color Declarations
        let lightPurple: UIColor = UIColor(red: 0.377, green: 0.075, blue: 0.778, alpha: 1.000)
        let darkPurple: UIColor = UIColor(red: 0.060, green: 0.036, blue: 0.202, alpha: 1.000)
        
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        let purpleGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [lightPurple.cgColor, darkPurple.cgColor] as CFArray, locations: [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        let options: CGGradientDrawingOptions = [.drawsBeforeStartLocation, .drawsAfterEndLocation]
        context?.saveGState()
        backgroundPath.addClip()
        context?.drawLinearGradient(purpleGradient!,
            start: CGPoint(x: 160, y: 0),
            end: CGPoint(x: 160, y: 568),
            options: options.self)
//            UInt32(CGGradientDrawingOptions.DrawsBeforeStartLocation) | UInt32(CGGradientDrawingOptions.DrawsAfterEndLocation))
        context?.restoreGState()
        
    }

}
