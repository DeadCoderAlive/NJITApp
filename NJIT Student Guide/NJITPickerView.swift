//
//  NJITPickerView.swift
//  NJIT Student Guide
//
//  Created by Mac on 11/28/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit

class NJITPickerView: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    var dataArr:[String]=[]
    var dataLat:[String]=[]
    var dataLong:[String]=[]
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad();
        getJSON("https://web.njit.edu/~ts336/getMapDest.php")
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getJSON(url: String) {
        let data = NSData(contentsOfURL: NSURL(string: url)!)
        do {
            
            let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
            var i = 0
            for _ in jsonResult!
            {
                
                let dd=jsonResult![i];
                dataArr.append(dd["MapDest"] as! String)
                dataLat.append(dd["MapLat"] as! String)
                dataLong.append(dd["MapLong"] as! String)
                
                i = i+1
                
                
            }
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView
    {
        var pickerLabel = UILabel()
        pickerLabel.textColor = UIColor.blackColor()
        pickerLabel.text = dataArr[row]
        // pickerLabel.font = UIFont(name: pickerLabel.font.fontName, size: 15)
        pickerLabel.font = UIFont(name: "Arial-BoldMT", size: 15) // In this use your custom font
        pickerLabel.textAlignment = NSTextAlignment.Center
        return pickerLabel
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataArr.count
    }
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return dataArr[row]
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      
        let iVal = segue.destinationViewController as! NJITMapView
        iVal.destLat = Double(dataLat[pickerView.selectedRowInComponent(0)])
        iVal.destLong = Double(dataLong[pickerView.selectedRowInComponent(0)])
        iVal.destLoc = dataArr[pickerView.selectedRowInComponent(0)]
        
   
    }
    
}
