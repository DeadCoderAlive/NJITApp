//
//  StudentSceneViewController.swift
//  NJIT Student Guide
//
//  Created by Venkatesh Muthukrishnan on 11/30/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class StudentSceneViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        reachabilityStatusChanged()
 NSNotificationCenter.defaultCenter().addObserver(self, selector: "reachabilityStatusChanged", name: "ReachStatusChanged", object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
       
        
    }
    
    func reachabilityStatusChanged()
    {
        if reachabilityStatus == kNOTREACHABLE
        {
            
            var alert = UIAlertView()
            alert.delegate = self
            alert.title = "No Connectivity"
            alert.message = "The internet connectivity is lost. Please restart the application."
            alert.addButtonWithTitle("OK")
            alert.show()
            
        }
        else
        {
        }
    }
    
    func alertView(View: UIAlertView!, clickedButtonAtIndex buttonIndex: Int){
        exit(0)
    }
    deinit{
        NSNotificationCenter.defaultCenter().removeObserver(self, name: "ReachStatusChanged", object: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func OpenWhatsThatBuilding(sender: AnyObject) {
        
       schemeAvailable("wtbnjit://")
        }
    }
    func schemeAvailable(scheme: String) -> Bool {
        if let url = NSURL.init(string: scheme) {
            return UIApplication.sharedApplication().openURL(url)
        }
        return false
    }

