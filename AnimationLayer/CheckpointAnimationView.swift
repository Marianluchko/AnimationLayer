//
//  CheckpointAnimationView.swift
//  AnimationLayer
//
//  Created by user on 12.11.2020.
//

import UIKit

class CheckpointAnimationView: UIView {
  weak var destinationView: UIView?
  weak var presentingView: UIView?
  
  var completion: (()->())?
  
  private lazy var imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.frame = CGRect(origin: .zero, size: CGSize(width: 28, height: 42))
    addSubview(imageView)
    imageView.center = center
    return imageView
  }()
  
  private lazy var animationLayer: CheckpointAnimationLayer = {
    let animationLayer = CheckpointAnimationLayer(crystalCenter: .zero, startPoint: .zero)
    return animationLayer
  }()
  
  
  func startCollectingAnimation(checkpointType: CheckpointType) {
    frame = presentingView?.bounds ?? .zero
    presentingView?.addSubview(self)
    guard let destinationView = destinationView else { return }
    
    
    let images = (1...10).map { UIImage(named: "crystal_green_\($0)")! }
    imageView.animationImages = images
    imageView.animationDuration = 0.3
    imageView.animationRepeatCount = 1
    
    imageView.image = UIImage(named: "crystal_green_1")
    imageView.center = center
    imageView.startAnimating()
    
    UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
      let originX = self.imageView.frame.origin.x - 6
      let originY = self.imageView.frame.origin.y - 12
      
      let height = self.imageView.frame.height + 12
      let width = self.imageView.frame.width + 12
      
      self.imageView.frame = CGRect(x: originX, y: originY, width: width, height: height)
      
    } completion: { (_) in
      
      
      var origin = self.imageView.frame.origin
      origin.x += 3
      let size = CGSize(width: 34, height: 34)
      self.imageView.frame = CGRect(origin: origin, size: size)
      self.imageView.image = UIImage(named: "crystal_green_highlighted")
      

      let path = UIBezierPath()
      path.move(to: self.imageView.center)
      path.addCurve(to: destinationView.center,
                    controlPoint1: CGPoint(x: destinationView.center.x+100, y: self.imageView.frame.origin.y/6),
                    controlPoint2: CGPoint(x: destinationView.center.x, y: destinationView.center.y))

      let animation = CAKeyframeAnimation(keyPath: "crystalCenter")
      animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
      animation.path = path.cgPath
      animation.duration = 0.6
      animation.calculationMode = .cubic
      animation.delegate = self

      self.animationLayer.contentsScale = UIScreen.main.scale
      self.animationLayer.destinationPoint = destinationView.center
      self.layer.addSublayer(self.animationLayer)
      self.animationLayer.frame = self.bounds
      
      self.animationLayer.add(animation, forKey: nil)
    }
  }
  
  private func finishAnimation() {
    UIView.animate(withDuration: 1, delay: 3, options: []) {
      self.imageView.alpha = 0
    } completion: { (_) in
      self.imageView.isHidden = true
      self.imageView.alpha = 1
    }
    
    let badgeView = UILabel()
    badgeView.text = " +1 "
    badgeView.backgroundColor = .green
    badgeView.alpha = 0
    destinationView?.addBadge(view: badgeView, size: badgeView.intrinsicContentSize, corner: .topRight)
    
    UIView.animate(withDuration: 0.4, delay: 1, options: []) {
      badgeView.alpha = 1
    } completion: { (_) in
      UIView.animate(withDuration: 1.1, delay: 2, options: []) {
        badgeView.alpha = 0
      } completion: { (_) in
        self.destinationView?.removeBadge()
        self.completion?()
      }
    }
  }
}


extension CheckpointAnimationView: CAAnimationDelegate {
  func animationDidStart(_ anim: CAAnimation) {
    self.imageView.isHidden = true
  }
  
  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
    print("Animation ended")
    imageView.center = destinationView?.center ?? .zero
    imageView.isHidden = false
    animationLayer.removeFromSuperlayer()
    finishAnimation()
  }
}
