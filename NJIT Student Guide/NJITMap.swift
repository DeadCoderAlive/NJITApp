//
//  NJITMap.swift
//  NJIT Student Guide
//
//  Created by Mac on 11/29/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class NJITMap: UIViewController {
    
    @IBOutlet weak var staticBtn: UIButton!
    
    @IBOutlet weak var dynBtn: UIButton!
    
    override func viewDidLoad() {
        
        let myImage =  UIImage(data: NSData(contentsOfURL: NSURL(string: "http://vignette2.wikia.nocookie.net/ben10/images/3/30/Map_icon.png/revision/latest?cb=20150316032824")!)!)
        staticBtn.frame = CGRectMake(100, 100, 100, 100)
        staticBtn.setBackgroundImage(myImage, forState: UIControlState.Normal)
        
        let myImage1 =  UIImage(data: NSData(contentsOfURL: NSURL(string: "http://ecx.images-amazon.com/images/I/618BkN3caEL.png")!)!)
        //dynBtn.frame = CGRectMake(100, 100, 100, 100)
       // dynBtn.setImage(myImage1, forState: .Normal)
        
        dynBtn.setBackgroundImage(myImage1, forState: UIControlState.Normal)
        
        
        
        
    }
    

}
