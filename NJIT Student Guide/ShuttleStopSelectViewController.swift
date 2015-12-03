//
//  ShuttleStopSelectViewController.swift
//  NJIT Student Guide
//
//  Created by Ishani Chatterjee on 11/9/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class ShuttleStopSelectViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {
    var selectedMap = String()
    @IBOutlet weak var picker: UIPickerView!
    var pickerData = [String]()
    override func viewDidLoad() {
        pickerData = ["Kearney/Harrison","Penn Station Local","Campus Connect"]
        selectedMap = "Kearney/Harrison"
        self.picker.delegate = self
        self.picker.dataSource = self
        super.viewDidLoad()
    }
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        let pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.whiteColor()
        pickerLabel.text = pickerData[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 25) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        selectedMap = pickerData[row]
        print("\(selectedMap)")
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var destVC = segue.destinationViewController as! ShuttleMapViewController
        destVC.mapSelect = selectedMap
        //print("\(selectedMap)")
    }
}
