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
    
    weak var delegate: JZMaterialSwitchDelegate? = nil
    
    
    
    
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
    
    fileprivate var thumbOffPosition: CGFloat!
    
    
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
            //test//
            //        self.isEnabled = false;
        
        /*
        print("frame.x : " + frame.origin.x.description)
        print("frame.y : " + frame.origin.y.description)
        print("before -- trackFrame.x : " + trackFrame.origin.x.description)
        print("before -- trackFrame.y : " + trackFrame.origin.y.description)
        */
        trackFrame.size.height = self.trackThickness
        trackFrame.size.width = frame.size.width
        trackFrame.origin.x = 0.0
        trackFrame.origin.y = (frame.size.height - trackFrame.size.height) / 2
        
        /*
        print("after -- trackFrame.x : " + trackFrame.origin.x.description)
        print("after -- trackFrame.y : " + trackFrame.origin.y.description)
        */
        
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
        
        self.addSubview(self.switchThumb)
        
        //Add events for user action
        self.switchThumb.addTarget(self, action: #selector(self.onTouchDown(btn:withEvent:)), for: UIControlEvents.touchDown)
    }
    
    //MARk: - Event Actions
    @objc func onTouchDown(btn: UIButton, withEvent event: UIEvent)
    {
        // print("touchDown called")
        if self.isRippleEnabled {
            self.initializeRipple();
        }
    }
    
    // Initialize and appear ripple effect
    func initializeRipple() {
        
    }
}
