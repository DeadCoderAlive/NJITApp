//
//  EurekaDetailViewController.swift
//  NJIT Student Guide
//
//  Created by Venkatesh Muthukrishnan on 10/24/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class EurekaDetailViewController: UIViewController {

    @IBOutlet weak var item: UILabel!

    override func viewDidLoad() {
        
        super.viewDidLoad()
        item.text="hhhhhhhh"
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
