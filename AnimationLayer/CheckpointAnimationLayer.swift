//
//  File.swift
//  AnimationLayer
//
//  Created by user on 11.11.2020.
//

import UIKit

class CheckpointAnimationLayer: CAShapeLayer {
  var startPoint: CGPoint {
    return CGPoint(x: frame.origin.x+frame.size.width/2, y: frame.origin.y+frame.size.height/2)
  }
  var checkpointSize = CGSize(width: 34, height: 34)
  var destinationPoint: CGPoint = .zero
  var animationProgress: CGFloat {
    guard let currentPosition = presentation()?.crystalCenter else { return 0 }
    let xVal = startPoint.x-destinationPoint.x
    let yVal = startPoint.y-destinationPoint.y
    let dx = xVal-currentPosition.x
    let dy = yVal-currentPosition.y
    let xProgress = dx/xVal
    let yProgress = dy/yVal
    return (xProgress+yProgress)/2
  }
  
  @objc dynamic var crystalCenter: CGPoint
  
  override init() {
    crystalCenter = .zero
    super.init()
  }
  
  required init?(coder: NSCoder) {
    crystalCenter = .zero
    super.init(coder: coder)
  }
  
  override init(layer: Any) {
    self.crystalCenter = .zero
    super.init(layer: layer)
  }
  
  init(crystalCenter: CGPoint, startPoint: CGPoint) {
    self.crystalCenter = .zero
    super.init()
  }
  
  override func draw(in ctx: CGContext) {
    
    guard let currentCenter = presentation()?.crystalCenter, currentCenter != .zero else { return }
    
    
    let image = UIImage(named: "crystal_green_highlighted")
   
    let imageOrigin = CGPoint(x: currentCenter.x-(checkpointSize.width/2), y: currentCenter.y-checkpointSize.height/2)
    let imageFrame = CGRect(origin: imageOrigin, size: checkpointSize)
   
    
    
    let path = UIBezierPath()
    path.move(to: CGPoint(x: imageFrame.origin.x+2, y: imageFrame.origin.y + 17 + (imageFrame.height/4.2)))

    path.addLine(to: CGPoint(x: imageFrame.origin.x+32, y: imageFrame.origin.y + 17 - (imageFrame.height/4.2)))

    let dy = startPoint.y - imageFrame.origin.y
    let controlPointOne = CGPoint(x: startPoint.x+17, y: imageFrame.origin.y + 0.25*dy)
    path.addQuadCurve(to: startPoint, controlPoint: controlPointOne)
    let controlPointTwo = CGPoint(x: startPoint.x-17, y: imageFrame.origin.y + 0.25*dy)
    path.addQuadCurve(to: CGPoint(x: imageFrame.origin.x+2, y: imageFrame.origin.y + 17 + (imageFrame.height/4.2)), controlPoint: controlPointTwo)
    
    
    ctx.addPath(path.cgPath)
    ctx.saveGState()
    ctx.clip()
    ctx.replacePathWithStrokedPath()
    
    let colors = [UIColor(red: 71/255, green: 177/255, blue: 12/255, alpha: 0.19 - 0.19*(animationProgress)).cgColor,
                  UIColor(red: 164/255, green: 219/255, blue: 64/255, alpha: 0.19 - 0.19*(animationProgress)).cgColor
                  ]
    let colorSpace = CGColorSpaceCreateDeviceRGB()
    let colorLocations: [CGFloat] = [0.0, 1.0]
    guard let gradient = CGGradient(
      colorsSpace: colorSpace,
      colors: colors as CFArray,
      locations: colorLocations
    ) else {
      fatalError()
    }
    
    ctx.drawLinearGradient(
      gradient,
      start: imageOrigin,
      end: startPoint,
      options: []
    )
    ctx.restoreGState()
    ctx.drawPath(using: .stroke)
    
    print("\(currentCenter),  startPoint: \(startPoint), frame: \(frame), animationProgress: \(animationProgress), destPoint: \(destinationPoint)")
    
    ctx.draw(image!.cgImage!, in: imageFrame)
  }
    
    
  override class func needsDisplay(forKey key: String) -> Bool {
    if key == "crystalCenter" {
        return true
    }
    return super.needsDisplay(forKey: key)
  }
    
  override func display() {
    super.display()
    
  }
}
