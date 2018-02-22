//
//  Extensions.swift
//  Vocab
//
//  Created by Prateek Kansara on 22/02/18.
//  Copyright © 2018 Prateek Kansara. All rights reserved.
//

import Foundation

public extension UIView {
    
    func shake(count : Float = 4,for duration : TimeInterval = 0.5,withTranslation translation : Float = -5) {
        
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionLinear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
    
    func drop() {
        
        let animator = UIDynamicAnimator(referenceView: self)
        let gravityBehaviour = UIGravityBehavior(items: [self])
        
        gravityBehaviour.gravityDirection = CGVector(dx: 0.0, dy: 10.0)
        animator.addBehavior(gravityBehaviour)
        
        let itemBehaviour = UIDynamicItemBehavior(items: [self])
        itemBehaviour.addAngularVelocity(-(CGFloat.pi/2), for: self)
        animator.addBehavior(itemBehaviour)
        
        UIView.animate(withDuration: 0.5, animations: {
        }, completion: {
            finished  in
            if finished{
            }
        })
    }
}
