//
//  ProfileViewController.swift
//  Storyboard
//
//  Created by Asuka Nakagawa on 2016-01-12.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

import UIKit
import Parse

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var userNameLabel: UILabel!

    // Do any additional setup after loading the view.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.titleView = UIImageView(image: UIImage(named: "Selfigram-logo"))

        
        }
        //userNameLabel.text = "Asuka"

    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let user = PFUser.currentUser(){
            userNameLabel.text = user.username
            
            if let imageFile = user["avatarImage"] as? PFFile {
                
                imageFile.getDataInBackgroundWithBlock({ (data, error) -> Void in
                    if let imageData = data {
                        self.profileImageView.image = UIImage(data: imageData)
                    }
                })
            }
        }    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cameraButtonPressed(sender: UIButton) {
        print("Camera Button Pressed")

            // 1: Create an ImagePickerController
        let pickerController = UIImagePickerController()
        
        // 2: Self in this line refers to this View Controller
        //    Setting the Delegate Property means you want to receive a message
        //    from pickerController when a specific event is triggered.
        pickerController.delegate = self
        
        if TARGET_OS_SIMULATOR == 1 {
            // 3. We check if we are running on a Simulator
            //    If so, we pick a photo from the simulator’s Photo Library
            // We need to do this because the simulator does not have a camera
            pickerController.sourceType = .PhotoLibrary
        } else {
            // 4. We check if we are running on an iPhone or iPad (ie: not a simulator)
            //    If so, we open up the pickerController's Camera (Front Camera, for selfies!)
            pickerController.sourceType = .Camera
            pickerController.cameraDevice = .Front
            pickerController.cameraCaptureMode = .Photo
        }
        
        // Preset the pickerController on screen
        self.presentViewController(pickerController, animated: true, completion: nil)
    

    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        
        // 1. When the delegate method is returned, it passes along a dictionary called info.
        //    This dictionary contains multiple things that maybe useful to us.
        //    We are getting the image from the UIImagePickerControllerOriginalImage key in that dictionary
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
                        
            // setting the compression quality to 90%
            if let imageData = UIImageJPEGRepresentation(image, 0.9),
            let imageFile = PFFile(data: imageData),
            let user = PFUser.currentUser() {
                
                user["avatarImage"] = imageFile
                
                user.saveInBackground()
                
                self.profileImageView.image = image
                
//                //2. We create a Post object from the image
//                let post = Post(image: imageFile, user: user, comment: "A Selfie")
//                
//                post.saveInBackgroundWithBlock({ (success, error) -> Void in
//                    if success {
//                        print("Post successfully saved in Parse")
//                        
//                        //3. Add post to our posts array, chose index 0 so that it will be added
////                        //   to the top of your table instead of at the bottom (default behaviour)
////                        user.posts.insert(post, atIndex: 0)
////                        
////                        //4. Now that we have added a post, updating our table
////                        //   We are just inserting our new Post instead of reloading our whole tableView
////                        //   Both method would work, however, this gives us a cool animation for free
////                        
////                        let indexPath =  NSIndexPath(forRow: 0, inSection: 0)
////                        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//                        
//                        
//                        }
//                })
            }
            
        }
        
        //3. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
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
