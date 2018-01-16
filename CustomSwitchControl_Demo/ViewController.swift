//
//  ViewController.swift
//  CustomSwitchControl_Demo
//
//  Created by icm_mobile on 2018/1/10.
//  Copyright © 2018年 icm_mobile. All rights reserved.
//

import UIKit

class ViewController: UIViewController, JZMaterialSwitchDelegate {
    func switchStateChanged(_ currentState: JZMaterialSwitchState) {
//        print(currentState)
    }
    
    var androidSwitchSmall : JZMaterialSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.androidSwitchSmall = JZMaterialSwitch(withSize: .normal, state: JZMaterialSwitchState.on)
        self.androidSwitchSmall.delegate = self
        self.view.addSubview(androidSwitchSmall)
        
        self.androidSwitchSmall.center = self.view.center
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    

}

