//
//  CustomOverlay.swift
//  LTCModule
//
//  Created by Artemy Markovsky on 08/04/2021.
//  Copyright © 2021. All rights reserved.
//

import UIKit

final class CustomOverlay: UIView {
    private var overlay: CAShapeLayer = {
        var overlay = CAShapeLayer()
        overlay.backgroundColor = UIColor.clear.cgColor
        overlay.fillColor = UIColor.clear.cgColor
        overlay.strokeColor = R.color.light()?.withAlphaComponent(0.4).cgColor ?? UIColor.white.cgColor
        overlay.lineWidth = 6
        
        return overlay
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupOverlay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setupOverlay()
    }
    
    private func setupOverlay() {
        layer.addSublayer(overlay)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        overlay.frame = bounds
        overlay.path = createOverlayPath(bounds)
    }
    
    var overlayColor: UIColor = UIColor.white {
        didSet {
            self.overlay.strokeColor = overlayColor.cgColor
            
            self.setNeedsDisplay()
        }
    }
    
    public override func draw(_ rect: CGRect) {
        overlay.path = createOverlayPath(rect)
    }
    
    fileprivate func createOverlayPath(_ rect: CGRect) -> CGPath {
        let path = UIBezierPath()
        let padding: CGFloat = 35
        let halfLine: CGFloat = 60
        let cornerRadius: CGFloat = 0
        
        path.move(to: CGPoint(
            x: padding - 3,
            y: padding
        ))
        path.addLine(to: CGPoint(
            x: padding + halfLine,
            y: padding
        ))
        path.move(to: CGPoint(
            x: rect.size.width - padding - cornerRadius - halfLine,
            y: padding
        ))
        path.addLine(to: CGPoint(
            x: rect.size.width - cornerRadius - padding,
            y: padding
        ))
        path.addArc(withCenter: CGPoint(
            x: rect.size.width - padding - cornerRadius,
            y: padding + cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat(270 * Double.pi / 180.0),
            endAngle: CGFloat(360 * Double.pi / 180.0),
            clockwise: true
        )
        path.addLine(to: CGPoint(
            x: rect.size.width - padding,
            y: halfLine + cornerRadius + padding
        ))
        
        path.move(to: CGPoint(x: rect.size.width - padding, y: rect.size.height - cornerRadius - padding - halfLine))
        path.addLine(to: CGPoint(x: rect.size.width - padding, y: rect.size.height - cornerRadius - padding))
        path.addArc(
            withCenter: CGPoint(x: rect.size.width - padding - cornerRadius, y: rect.size.height - cornerRadius - padding),
            radius: cornerRadius,
            startAngle: CGFloat(360 * Double.pi / 180.0),
            endAngle: CGFloat(90 * Double.pi / 180.0),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: rect.size.width - padding - cornerRadius - halfLine, y: rect.size.height - padding))
        path.move(to: CGPoint(x: padding + cornerRadius + halfLine, y: rect.size.height - padding))
        path.addLine(to: CGPoint(x: padding + cornerRadius, y: rect.size.height - padding))
        path.addArc(
            withCenter: CGPoint(x: padding + cornerRadius, y: rect.size.height - cornerRadius - padding),
            radius: cornerRadius,
            startAngle: CGFloat(90 * Double.pi / 180.0),
            endAngle: CGFloat(180 * Double.pi / 180.0),
            clockwise: true
        )
        path.addLine(to: CGPoint(x: padding, y: rect.size.height - padding - cornerRadius - halfLine))
        path.move(to: CGPoint(x: padding, y: cornerRadius + padding + halfLine))
        path.addLine(to: CGPoint(x: padding, y: cornerRadius + padding))
        path.addArc(
            withCenter: CGPoint(x: padding + cornerRadius, y: padding + cornerRadius),
            radius: cornerRadius,
            startAngle: CGFloat(180 * Double.pi / 180.0),
            endAngle: CGFloat(270 * Double.pi / 180.0),
            clockwise: true
        )
        
        return path.cgPath
    }
}
