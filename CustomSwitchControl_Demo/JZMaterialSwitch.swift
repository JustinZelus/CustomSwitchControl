//
//  JZMaterialSwitch.swift
//  CustomSwitchControl_Demo
//
//  Created by icm_mobile on 2018/1/10.
//  Copyright © 2018年 icm_mobile. All rights reserved.
//

import Foundation
import UIKit


public enum JZMaterialSwitchSize {
    case big, normal, small
}

public enum JZMaterialSwitchState {
    case on, off
}

protocol JZMaterialSwitchDelegate: class {
    func switchStateChanged(_ currentState: JZMaterialSwitchState)
}

class JZMaterialSwitch : UIControl {
    
    //MARK: - Properties
    //MARK: Delegate
    weak var delegate: JZMaterialSwitchDelegate? = nil
    
    //MARK: State
    /** A Boolean value that represent switch's current state(ON/OFF). YES to ON, NO to OFF the switch */
    var isOn: Bool = false
    
    //MARK:  Colour
    /** An UIColor property to represent the colour of the switch thumb when position is ON */
    var thumbOnTintColor: UIColor!
    
    /** An UIColor property to represent the colour of the switch thumb when position is OFF */
    var thumbOffTintColor: UIColor!
    
    /** An UIColor property to represent the colour of the track when the postion is ON*/
    var trackOnTintColor: UIColor!
    
    /** An UIColor property to represent the colour of the track  when the position is OFF */
    var trackOffTintColor: UIColor!
    
    /** An UIColor property to represent the colour of the switch thumb when position is DISABLED */
    var thumbDisabledTintColor: UIColor!
    
    /** An UIColor property to represent the colour of the track when position is DISABLED */
    var trackDisabledTintColor: UIColor!
    
    /** An UIColor property to represent the fill colour of the ripple only when ripple effect is enabled */
    var rippleFillColor: UIColor = .gray
    
    
    
    //MARK: UI components
    /** An UIButton object that represent current state(ON/OFF) */
    var switchThumb: UIButton!
    /** An UIView object that represents the track for the thumb */
    var track: UIView!
    
    /** A CGFloat value to represent the track thickness of the switch */
    var trackThickness: CGFloat!
    
    /** A CGFloat value to represent the switch thumb size(width and height)*/
    var thumbSize: CGFloat!
    
    /** A Boolean value whether the ripple animation effect is enabled or not */
    var isRippleEnabled: Bool = false;
    
    fileprivate var thumbOnPosition: CGFloat!
    fileprivate var thumbOffPosition: CGFloat!
    fileprivate var testLayer: CALayer!
    fileprivate var rippleLayer: CAShapeLayer!
    fileprivate var bounceOffset: CGFloat!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    convenience init (withSize size: JZMaterialSwitchSize, state: JZMaterialSwitchState) {
        var frame: CGRect!
        var trackFrame = CGRect.zero
        var thumbFrame = CGRect.zero
        
        switch (size) {
        case .big:
            frame = CGRect(x: 0, y: 0, width: 50, height: 35)
            self.init(frame: frame)
            self.trackThickness = 22.0
            self.thumbSize = 31.0
            break
        case .normal:
            frame = CGRect(x: 0, y: 0, width: 40, height: 30)
            self.init(frame: frame)
            self.trackThickness = 17.0
            self.thumbSize = 24.0
            break
        case .small:
            frame = CGRect(x: 0, y: 0, width: 30 , height: 25)
            self.init(frame: frame)
            self.trackThickness = 13.0
            self.thumbSize = 18.0
            break
        }
        
        // initialize parameters
        self.thumbOnTintColor = UIColor(red: 52.0 / 255.0, green: 109.0 / 255.0, blue: 241.0 / 255.0, alpha: 1.0)
        self.thumbOffTintColor = UIColor(red: 249.0 / 255.0, green: 249.0 / 255.0, blue: 240.0 / 255.0, alpha: 1.0)
        
        self.trackOnTintColor = UIColor(red: 143.0 / 255.0, green: 179.0 / 255.0, blue: 247.0 / 255.0, alpha: 1.0)
        self.trackOffTintColor = UIColor(red: 174.0 / 255.0 , green: 174.0 / 255.0 , blue: 174.0 / 255.0 , alpha: 1.0)
        
        self.isEnabled = true;
        
        self.isRippleEnabled = true
   
        self.bounceOffset = 3.0
      
        trackFrame.size.height = self.trackThickness
        trackFrame.size.width = frame.size.width
        trackFrame.origin.x = 0.0
        trackFrame.origin.y = (frame.size.height - trackFrame.size.height) / 2
        thumbFrame.size.height = self.thumbSize
        thumbFrame.size.width = thumbFrame.size.height
        thumbFrame.origin.x = 0.0
        thumbFrame.origin.y = (frame.size.height - thumbFrame.size.height) / 2
        
        self.track = UIView(frame: trackFrame)
        self.track.backgroundColor = .gray
        self.track.layer.cornerRadius = min(self.track.frame.size.height, self.track.frame.size.width) / 2
        self.addSubview(self.track)
        
        self.switchThumb = UIButton(frame: thumbFrame)
        self.switchThumb.backgroundColor = .white
        self.switchThumb.layer.cornerRadius = self.switchThumb.frame.size.height / 2
        self.switchThumb.layer.shadowOpacity = 0.5
        self.switchThumb.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        
        self.switchThumb.layer.shadowColor = UIColor.purple.cgColor
        self.switchThumb.layer.shadowRadius = 2.0
        
        //Add events for user action
        self.switchThumb.addTarget(self, action: #selector(self.onTouchDown(btn:withEvent:)), for: UIControlEvents.touchDown)
        self.switchThumb.addTarget(self, action: #selector(onTouchUpOutsideOrCanceled(btn:withEvent:)), for: UIControlEvents.touchUpOutside)
        self.switchThumb.addTarget(self, action: #selector(self.switchThumbTapped), for: UIControlEvents.touchUpInside)
        self.switchThumb.addTarget(self, action: #selector(onTouchUpOutsideOrCanceled(btn:withEvent:)), for: UIControlEvents.touchCancel)
        
        self.addSubview(self.switchThumb)
        
        thumbOnPosition = self.frame.size.width - self.switchThumb.frame.size.width
        thumbOffPosition = self.switchThumb.frame.origin.x
        
        // Set thumb's inital position from state property
        switch state {
        case .on:
            self.isOn = true
            self.switchThumb.backgroundColor = self.thumbOnTintColor
            var thumb_Frame = self.switchThumb.frame
            thumb_Frame.origin.x = self.thumbOnPosition
            self.switchThumb.frame = thumb_Frame
            break
        
        case .off:
            self.isOn = false
            self.switchThumb.backgroundColor = self.thumbOffTintColor
            var thumb_Frame = self.switchThumb.frame
            thumb_Frame.origin.x = self.thumbOffPosition
            break
        }
        
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(self.switchAreaTapped(recognizer:)))
        self.addGestureRecognizer(singleTap)
        
        self.setOn(on: self.isOn, animated: self.isRippleEnabled)
    }
    
    func setOn(on: Bool, animated: Bool) {
        if on {
            self.changeThumbStateOFFwithAnimation()
        } else {
            self.changeThumbStateONwithAnimation()
        }
        
        if animated {
            self.animateRippleEffect()
        }
    }
    
    //The event handling method
    @objc func switchAreaTapped(recognizer: UITapGestureRecognizer) {
        //Delegate method
        if self.isOn {
            self.delegate?.switchStateChanged(.off)
        } else {
            self.delegate?.switchStateChanged(.on)
        }
        
        self.changeThumbState()
    }
    
    func changeThumbState() {
        if self.isOn {
            self.changeThumbStateOFFwithAnimation()
        } else {
            self.changeThumbStateONwithAnimation()
        }
        
        if self.isRippleEnabled {
            self.animateRippleEffect()
        }
    }
    
    func animateRippleEffect() {
        // Create ripple layer
        if rippleLayer == nil {
            self.initializeRipple()
        }
        
        //Animation begins from here
        rippleLayer.opacity = 0.0
        
        CATransaction.begin()
        
        //remove layer after animation completed
        CATransaction.setCompletionBlock{
            self.rippleLayer.removeFromSuperlayer()
            self.rippleLayer = nil
        }
        
        // Scale ripple to the modelate size
        let scaleAnimation = CABasicAnimation(keyPath:  "transfoem.scale")
        scaleAnimation.fromValue = 0.5
        scaleAnimation.toValue = 1.25
        
        // Alpha animation to the modelate size
        let alphaAnimation = CABasicAnimation(keyPath: "opacity")
        alphaAnimation.fromValue = 0.4
        alphaAnimation.toValue = 0
        
        // Do above animations at the same time with proper duration
        let animation = CAAnimationGroup()
        animation.animations = [scaleAnimation, alphaAnimation]
        animation.duration = 0.4
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
        rippleLayer.add(animation, forKey: nil)
        
        CATransaction.commit()
        
    }
    
    func changeThumbStateONwithAnimation() {
        // switch movement animation
        //withDuration 如果不設為0，就會有延遲。(目前無解)
        //經測試用另一種block寫法不會有延遲。(註解的地方)
        UIView.animate(withDuration: 0.0, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {

            var thumbFrame = self.switchThumb.frame
            thumbFrame.origin.x = self.thumbOffPosition + self.bounceOffset
            self.switchThumb.frame = thumbFrame

            if self.isEnabled {
                self.switchThumb.backgroundColor = self.thumbOnTintColor
                self.track.backgroundColor = self.trackOnTintColor
            } else {
                self.switchThumb.backgroundColor = self.thumbDisabledTintColor
                self.track.backgroundColor = self.trackDisabledTintColor
            }
            self.isUserInteractionEnabled = false

        }, completion: { (finished: Bool) in

            //change state to ON
            if self.isOn {
                self.isOn = true
                self.sendActions(for: UIControlEvents.valueChanged)
            }
            self.isOn = true

            UIView.animate(withDuration: 0.15, animations: {
                //Bounce to the position
                var thumbFrame = self.switchThumb.frame
                thumbFrame.origin.x = self.thumbOnPosition
                self.switchThumb.frame = thumbFrame

            }, completion: { (finished) in
               self.isUserInteractionEnabled = true
            })
        })
        
        
        
//        // switch movement animation
//        UIView.animate(withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//
//            var thumbFrame = self.switchThumb.frame
//            thumbFrame.origin.x = self.thumbOnPosition + self.bounceOffset
//            self.switchThumb.frame = thumbFrame
//            if self.isEnabled {
//                self.switchThumb.backgroundColor = self.thumbOnTintColor
//                self.track.backgroundColor = self.trackOnTintColor
//            } else {
//                self.switchThumb.backgroundColor = self.thumbDisabledTintColor
//                self.track.backgroundColor = self.trackDisabledTintColor
//            }
//            self.isUserInteractionEnabled = false
//
//        }) { (finished) in
//
//            // change state to ON
//            if self.isOn {
//                self.isOn = true // Expressly put this code here to change surely and send action correctly
//                self.sendActions(for: UIControlEvents.valueChanged)
//            }
//            self.isOn = true
//            // print("now isOn: %d", self.isOn)
//            // print("thumb end pos: %@", NSStringFromCGRect(self.switchThumb.frame))
//            // Bouncing effect: Move thumb a bit, for better UX
//
//            UIView.animate(withDuration: 0.15, animations: {
//                // Bounce to the position
//                var thumbFrame = self.switchThumb.frame
//                thumbFrame.origin.x = self.thumbOnPosition
//                self.switchThumb.frame = thumbFrame
//
//            }, completion: { (finished) in
//                self.isUserInteractionEnabled = true
//            })
//        }
    }
    
    func changeThumbStateOFFwithAnimation() {
        // switch movement animation
        UIView.animate(withDuration: 0.15 , delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            print("thumo off animation done ")
            var thumbFrame = self.switchThumb.frame
            thumbFrame.origin.x = self.thumbOffPosition - self.bounceOffset
            self.switchThumb.frame = thumbFrame

            if self.isEnabled {
                self.switchThumb.backgroundColor = self.thumbOffTintColor
                self.track.backgroundColor = self.trackOffTintColor
            } else {
                self.switchThumb.backgroundColor = self.thumbDisabledTintColor
                self.track.backgroundColor = self.trackDisabledTintColor
            }
            self.isUserInteractionEnabled = false

        }, completion: { (finished: Bool) in
//            print("thumo off animation completion : " + String(finished))

            // change state to OFF
            if self.isOn {
                self.isOn = false //
                self.sendActions(for: UIControlEvents.valueChanged)
            }
            self.isOn = false

            UIView.animate(withDuration: 0.15, animations: {

                // Bounce to the position
                var thumbFrame = self.switchThumb.frame
                thumbFrame.origin.x = self.thumbOffPosition
                self.switchThumb.frame = thumbFrame
            },completion: { (finish) in
                self.isUserInteractionEnabled = true
            })
        })
        
        // switch movement animation
//        UIView.animate(withDuration: 0.15, delay: 0.05, options: UIViewAnimationOptions.curveEaseInOut, animations: {
//            var thumbFrame = self.switchThumb.frame
//            thumbFrame.origin.x = self.thumbOffPosition - self.bounceOffset
//            self.switchThumb.frame = thumbFrame
//            if self.isEnabled {
//                self.switchThumb.backgroundColor = self.thumbOffTintColor
//                self.track.backgroundColor = self.trackOffTintColor
//            } else {
//                self.switchThumb.backgroundColor = self.thumbDisabledTintColor
//                self.track.backgroundColor = self.trackDisabledTintColor
//            }
//            self.isUserInteractionEnabled = false
//
//        }) { (finished) in
//
//            // change state to OFF
//            if self.isOn {
//                self.isOn = false // Expressly put this code here to change surely and send action correctly
//                self.sendActions(for: UIControlEvents.valueChanged)
//            }
//            self.isOn = false
//            // print("now isOn: %d", self.isOn)
//            // print("thumb end pos: %@", NSStringFromCGRect(self.switchThumb.frame))
//            // Bouncing effect: Move thumb a bit, for better UX
//
//            UIView.animate(withDuration: 0.15, animations: {
//
//                // Bounce to the position
//                var thumbFrame = self.switchThumb.frame
//                thumbFrame.origin.x = self.thumbOffPosition
//                self.switchThumb.frame = thumbFrame
//            }, completion: { (finish) in
//                self.isUserInteractionEnabled = true
//            })
//        }
        
        
    }
    
    //change thumb state when touchUpInside action is detected
    @objc func switchThumbTapped() {
//            print("touch up inside")
        
        //Delegate method
        if self.isOn {
            self.delegate?.switchStateChanged(.off)
        } else {
            self.delegate?.switchStateChanged(.on)
        }
        
        self.changeThumbState()
    }
    
    //why不會觸發?
    @objc func onTouchUpOutsideOrCanceled(btn: UIButton, withEvent event: UIEvent) {
        print("Touch released at outside")
        if let touch = event.touches(for: btn)?.first {
            
            let prevPos = touch.previousLocation(in: btn)
            let pos = touch.location(in: btn)
            
            /** 剩下的code暫不寫*/
        }
    }
    
    //MARk: - Event Actions
    @objc func onTouchDown(btn: UIButton, withEvent event: UIEvent)
    {
//         print("touchDown called")
        if self.isRippleEnabled {
            self.initializeRipple();
            
            // Animate for apperaing ripple circle when tap and hold the switch thumb
             CATransaction.begin()
            
             let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
             scaleAnimation.fromValue = 0.0
             scaleAnimation.toValue = 1.0
            
             let alphaAnimation = CABasicAnimation(keyPath: "opacity")
             alphaAnimation.fromValue = 0
             alphaAnimation.toValue = 0.2
            
             // Do above animations at the same time with proper duration
             let animation = CAAnimationGroup()
             animation.animations = [scaleAnimation, alphaAnimation]
             animation.duration = 0.4
             animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseOut)
             rippleLayer.add(animation, forKey: nil)
             CATransaction.commit()
        }
    }
    
    // Initialize and appear ripple effect
    func initializeRipple() {
        // Ripple size is twice as large as switch thumb
        
        let rippleScale : CGFloat = 2
        var rippleFrame = CGRect.zero
        rippleFrame.origin.x = -self.switchThumb.frame.size.width / (rippleScale * 2)
        rippleFrame.origin.y = -self.switchThumb.frame.size.height / (rippleScale * 2)
        rippleFrame.size.height = self.switchThumb.frame.size.height * rippleScale
        rippleFrame.size.width = rippleFrame.size.height
        
        let path = UIBezierPath.init(roundedRect: rippleFrame, cornerRadius: self.switchThumb.layer.cornerRadius * 2)
        
        // Set ripple layer attributes
        rippleLayer = CAShapeLayer()
        rippleLayer.path = path.cgPath
        rippleLayer.frame = rippleFrame
        rippleLayer.opacity = 0.2
        rippleLayer.strokeColor = UIColor.clear.cgColor
        rippleLayer.fillColor = self.rippleFillColor.cgColor
        rippleLayer.lineWidth = 0
        
        self.switchThumb.layer.insertSublayer(rippleLayer, below: self.switchThumb.layer)
    }
}
