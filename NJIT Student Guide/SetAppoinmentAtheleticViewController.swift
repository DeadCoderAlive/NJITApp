//
//  TestViewController.swift
//  NJIT Student Guide
//
//  Created by user113255 on 9/27/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class SetAppoinmentAtheleticViewController: UIViewController {
    
    @IBOutlet weak var myLabel: UILabel!
    var scheduleChoice = String()
    var optionChoosed = String()
    var datetime = String()
    var from = String()
    var to = String()
    @IBOutlet weak var datePick: UIDatePicker!
    //@IBOutlet weak var fromTime: UIDatePicker!
    @IBOutlet weak var toTime: UIDatePicker!
    
    
    @IBAction func btnClick(sender: UIButton) {
        myLabel.text = datetime
    }
    
    override func viewDidLoad() {
        myLabel.text = "Schedule Choice: \(scheduleChoice) Option Choosed : \(optionChoosed)"
        //datePick.addTarget(self, action: Selector("handleDatePicker:"), forControlEvents: UIControlEvents.ValueChanged)
        ////fromTime.addTarget(self, action: Selector("handleFromTimePicker"), forControlEvents: UIControlEvents.TouchUpInside)
        //toTime.addTarget(self, action: Selector("handleToTimePicker"), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    /*func handleFromTimePicker(sender : UIDatePicker){
    var timeformatter = NSDateFormatter()
        timeformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        from = timeformatter.stringFromDate(fromTime.date)
        datetime += from
        print("\(from)")
        myLabel.text = datetime
        
    
    }
    
    func handleDatePicker(sender : UIDatePicker){
        
        datePick.minimumDate = NSDate()
        let dateformatter = NSDateFormatter()
        //var timeformatter = NSDateFormatter()
        //var timeformatter1 = NSDateFormatter()

        dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
        //timeformatter.timeStyle = NSDateFormatterStyle.ShortStyle
        //timeformatter1.timeStyle = NSDateFormatterStyle.ShortStyle
        
        
        datetime = dateformatter.stringFromDate(datePick.date)
        //datetime += timeformatter.stringFromDate(fromTime.date)
        datetime += "  to  "
        //datetime = timeformatter1.stringFromDate(toTime.date)
        myLabel.text = datetime

    }*/
    
   
    
}
