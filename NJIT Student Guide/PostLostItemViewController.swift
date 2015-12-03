//
//  PostLostItemViewController.swift
//  NJIT Student Guide
//
//  Created by Venkatesh Muthukrishnan on 10/25/15.
//  Copyright © 2015 Fantastic4. All rights reserved.
//

import UIKit


class PostLostItemViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate {

    @IBOutlet weak var imageWindow: UIImageView!
    @IBOutlet weak var itemDesc: UITextField!
    @IBOutlet weak var userEmail: UITextField!

    @IBOutlet weak var ItemName: UITextField!
    @IBOutlet weak var userName: UITextField!
    var url = NSURL(string: "https://web.njit.edu/~ss2773/uploads/uploads.php")
    var fileExt = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
   self.itemDesc.delegate = self
        self.ItemName.delegate = self
        self.userEmail.delegate = self
        self.userName.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    @IBAction func Save(sender: AnyObject) {
        //
        if(userName.text!.isEmpty || userEmail.text!.isEmpty || ItemName.text!.isEmpty || itemDesc.text!.isEmpty || imageWindow.image == nil) {
            let alertController = UIAlertController(title: "Incomplete form", message: "fill out the blank fields", preferredStyle: .Alert)
            let compAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(compAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else if(!isValidEmail(userEmail.text!)) {
            let alertController = UIAlertController(title: "Not a Valid Email", message: "Please Enter a valid Email address", preferredStyle: .Alert)
            let compAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alertController.addAction(compAction)
            presentViewController(alertController, animated: true, completion: nil)
        }
        else {
        postJSON(userName.text!,useremail: userEmail.text!,itemname: ItemName.text!,itemdesc: itemDesc.text!)
        imageUploadRequest(imageView: imageWindow, uploadUrl: url!,filename: userName.text!)
       //     self.performSegueWithIdentifier("toLostView", sender: self )
            
            let alert = UIAlertController(title: "Success", message: "Posted Successfully!!!", preferredStyle: .Alert)
            let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
            alert.addAction(action)
            presentViewController(alert, animated: true, completion: nil)
            self.imageWindow.image = nil
            self.imageWindow.setNeedsDisplay()
            self.itemDesc.text = ""
            self.ItemName.text = ""
            self.userEmail.text = ""
            self.userName.text = ""
            
            
            
            
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func choosePhoto(sender: UIButton) {
     let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .PhotoLibrary
        presentViewController(picker, animated: true, completion: nil)
        
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedImage =  info[UIImagePickerControllerOriginalImage] as! UIImage
        imageWindow.image = pickedImage
        dismissViewControllerAnimated(true, completion: nil)
            }
    
    
    
    func imageUploadRequest(imageView imageView: UIImageView, uploadUrl: NSURL,filename: String) {
        
       
        
        let request = NSMutableURLRequest(URL:uploadUrl);
        request.HTTPMethod = "POST"
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        let imageData = UIImageJPEGRepresentation(imageView.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters( "file", imageDataKey: imageData!, boundary: boundary,filename: filename)
        
        //myActivityIndicator.startAnimating();
        
        let task =  NSURLSession.sharedSession().dataTaskWithRequest(request,
            completionHandler: {
                (data, response, error) -> Void in
                if let data = data {
                    
                    // You can print out response object
                    print("******* response = \(response)")
                    
                    print(data.length)
                    // you can use data here
                    
                    // Print out reponse body
                    let responseString = NSString(data: data, encoding: NSUTF8StringEncoding)
                    print("****** response data = \(responseString!)")
                    
                    let json =  try!NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? NSDictionary
                    
                    print("json value \(json)")
                    
                    //var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: &err)
                    
                    dispatch_async(dispatch_get_main_queue(),{
                        //self.myActivityIndicator.stopAnimating()
                        //self.imageView.image = nil;
                    });
                    
                } else if let error = error {
                    print(error.description)
                }
        })
        task.resume()
        
        
    }
    
    
    func createBodyWithParameters( filePathKey: String?, imageDataKey: NSData, boundary: String,filename: String) -> NSData {
        let body = NSMutableData();
        
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    
}// extension for impage uploading

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
    }
}

func isValidEmail(testStr:String) -> Bool {
    // println("validate calendar: \(testStr)")
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(testStr)
}

       //
    func postJSON(username: String!,useremail: String!,itemname: String!,itemdesc: String!) {
        let myUrl = NSURL(string: "https://web.njit.edu/~ss2773/postlostfound.php")
        let imageUrl = "https://web.njit.edu/~ss2773/uploads/uploads/"+username

        let request = NSMutableURLRequest(URL:myUrl!)
        request.HTTPMethod = "POST"
        let postString = "username='\(username)'&useremail='\(useremail)'&itemname='\(itemname)'&itemdesc='\(itemdesc)'&imageurl='\(imageUrl)'"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request,completionHandler: {data,response, error ->
            Void in
            //print("data: \(data)")
            do{
    
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSArray
                //print(json)
                print(json)
            }catch _ as NSError{
                
            }


       
        })
        task.resume()
        
    }


