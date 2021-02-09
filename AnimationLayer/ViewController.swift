//
//  ViewController.swift
//  AnimationLayer
//
//  Created by user on 06.11.2020.
//

import UIKit
import RCNativeiOSSDK


class ViewController: UIViewController {

  lazy var slider: RCNativeSliderBanner = {
    let banner = RCNativeSliderBanner(bannerId: "1233", size: .preset250x250)
    banner.presentingController = self
    return banner
  }()
  
  @IBOutlet var starButton: UIButton!
//  @IBOutlet var initialImageView: UIImageView!
//
//  lazy var animLayer: CheckpointAnimationLayer = {
//    return CheckpointAnimationLayer(crystalCenter: initialImageView.center, startPoint: view.center)
//  }()
  lazy var animationView: CheckpointAnimationView = {
    let animatioView = CheckpointAnimationView()
    animatioView.destinationView = starButton
    animatioView.presentingView = self.view
    return animatioView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //kek lol soft.
    //second change
    // Do any additional setup after loading the view.
    //main1
    //main2
    //main3
    
    
//    let images = (1...10).map { UIImage(named: "crystal_green_\($0)")! }
//    initialImageView.animationImages = images
//    initialImageView.animationDuration = 0.3
//    initialImageView.animationRepeatCount = 1
    
//    DispatchQueue.main.asyncAfter(deadline: .now()+2) { [weak self] in
//      self?.animationView.startCollectingAnimation(checkpointType: .blue)
////      self?.initialImageView.startAnimating()
////
////      UIView.animate(withDuration: 0.3, delay: 0, options: .curveLinear) {
////        let originX = self!.initialImageView.frame.origin.x - 6
////        let originY = self!.initialImageView.frame.origin.y - 12
////
////        let height = self!.initialImageView.frame.height + 12
////        let width = self!.initialImageView.frame.width + 12
////
////        self?.initialImageView.frame = CGRect(x: originX, y: originY, width: width, height: height)
////
////      } completion: { (_) in
////
////
////        var origin = self!.initialImageView.frame.origin
////        origin.x += 3
////        let size = CGSize(width: 34, height: 34)
////        self?.initialImageView.frame = CGRect(origin: origin, size: size)
////        self!.initialImageView.image = UIImage(named: "crystal_green_highlighted")
////
////
////        let path = UIBezierPath()
////        path.move(to: self!.initialImageView.center)
////        path.addCurve(to: self!.starButton.center,
////                      controlPoint1: CGPoint(x: self!.starButton.center.x+100, y: self!.initialImageView.frame.origin.y/6),
////                      controlPoint2: CGPoint(x: self!.starButton.center.x, y: self!.starButton.center.y))
////
////        let animation = CAKeyframeAnimation(keyPath: "crystalCenter")
////        animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
////        animation.path = path.cgPath
////        animation.duration = 5
////        animation.calculationMode = .cubic
////        animation.delegate = self
////
////        self?.animLayer.contentsScale = UIScreen.main.scale
////        self?.animLayer.destinationPoint = self!.starButton.center
////        self?.view.layer.addSublayer(self!.animLayer)
////        self?.animLayer.frame = self!.view.bounds
////        self?.animLayer.add(animation, forKey: nil)
////      }
//    }
  }
  
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
//    initialImageView.center = view.center
  }
}

//extension ViewController: CAAnimationDelegate {
//  func animationDidStart(_ anim: CAAnimation) {
//    initialImageView.isHidden = true
//  }
//  func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
//    print("Animation ended")
//    initialImageView.center = starButton.center
//    initialImageView.isHidden = false
//    animLayer.isHidden = true
//  }
//}

//brunch1_1
//brunch1_2

extension UIView {
  func addBadge(view: UIView, size: CGSize = .zero, corner: UIRectCorner = .bottomRight, isShouldAddAsSubview: Bool = false, isShoulAddInViewFrame: Bool = false, customSuperviewSize: CGSize? = nil) {
    removeBadge()
    var holderView: UIView
    if isShouldAddAsSubview {
      holderView = self
    } else {
      holderView = superview!
    }
    let randomTag = Int(arc4random_uniform(1024)) + 1
    view.tag = randomTag
    tag = randomTag
    var badgeSize = size
    let badgeViewSize = customSuperviewSize ?? bounds.size
    if badgeSize == .zero {
      let side = min(badgeViewSize.width, badgeViewSize.height) / 3
      badgeSize = CGSize(width: side, height: side)
    }
    print("bounds: \(bounds), size: \(size)")
    let delta = sqrt(pow(Double(badgeViewSize.width / 2), 2) / 2)
    var centerPoint: CGPoint = .zero

    switch corner {
    case .topRight:
      centerPoint = CGPoint(x: delta, y: -delta)
//      if isShoulAddInViewFrame {
//        centerPoint = CGPoint(x: delta, y: -delta)
//        if centerPoint.x > bounds.width - badgeSize.width/2 {
//          centerPoint.x = bounds.width - badgeSize.width/2
//        }
//      }
    case .bottomRight:
      centerPoint = CGPoint(x: delta, y: delta)
    case .topLeft:
      centerPoint = CGPoint(x: -delta, y: -delta)
    case .bottomLeft:
      centerPoint = CGPoint(x: -delta, y: delta)
    default:
      centerPoint = CGPoint(x: delta, y: -delta)
    }

    view.layer.cornerRadius = badgeSize.height / 2
    view.clipsToBounds = true
    holderView.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false
    view.heightAnchor.constraint(equalToConstant: badgeSize.height).isActive = true
    view.widthAnchor.constraint(equalToConstant: badgeSize.width).isActive = true
    
    view.centerYAnchor.constraint(equalTo: centerYAnchor, constant: centerPoint.y).isActive = true
    view.centerXAnchor.constraint(equalTo: centerXAnchor, constant: centerPoint.x).isActive = true
    layoutIfNeeded()
  }
  
  func removeBadge() {
    superview?.subviews.first(where: { $0 != self && $0.tag == tag && tag != 0 })?.removeFromSuperview()
    tag = 0
  }
}
