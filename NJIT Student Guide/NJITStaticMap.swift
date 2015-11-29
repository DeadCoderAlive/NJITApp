//
//  NJITStaticMap.swift
//  NJIT Student Guide
//
//  Created by Mac on 11/29/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class NJITStaticMap: UIViewController {
    
    
    @IBOutlet weak var scrollview: UIScrollView!
        {
        didSet{
            scrollview.contentSize = imageView.frame.size
        }
    }
    private var imageView = UIImageView()
    private var image : UIImage?{
        get{return imageView.image}
        set{
         imageView.image = newValue
            imageView.sizeToFit()
       scrollview?.contentSize = imageView.frame.size
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollview.addSubview(imageView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        image =  UIImage(named: "njitmap")
        
    }

}
