//
//  FeedViewController.swift
//  Storyboard
//
//  Created by Asuka Nakagawa on 2016-01-20.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

import UIKit
import Parse

class FeedViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let words:[String] = ["Hello", "my", "name", "is", "Selfigram"]
    
    var posts = [Post]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let query = Post.query() {
            query.orderByDescending("createdAt")
            query.includeKey("user")
            query.findObjectsInBackgroundWithBlock({ (posts, error) -> Void in
                if let posts = posts as? [Post] {
                    self.posts = posts
                      self.tableView.reloadData()
                }
                
            })
        }
    }
        
        // this is called to start (or restart, if needed) our task
        //task.resume()
        
       // print ("outside dataTaskWithURL")
        
            // UIImage has an initializer where you can pass in the name of an image in your project to create an UIImage
            // UIImage(named: "grumpy-cat") can return nil if there is no image called "grumpy-cat" in your project
            // Our definition of Post did not include the possibility of a nil UIImage
            // so, therefore we have to add a ! at the end of it
//        
//        
//        let me = User(aUsername: "Asuka", aProfileImage: UIImage(named: "grumpy-cat")!)
//            let post0 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 0")
//            let post1 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 1")
//            let post2 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 2")
//            let post3 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 3")
//            let post4 = Post(image: UIImage(named: "grumpy-cat")!, user: me, comment: "Grumpy Cat 4")
//        
//            posts = [post0, post1, post2, post3, post4]
    

         //Uncomment the following line to preserve selection between presentations
         //self.clearsSelectionOnViewWillAppear = false

         //Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//         self.navigationItem.rightBarButtonItem = self.editButtonItem()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 1
//    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return posts.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! SelfieCellTableViewCell
        let post = self.posts[indexPath.row]
        cell.post = post
        
        // I've added this line to prevent flickering of images
        // We are inside the cellForRowAtIndexPath method that gets called everything we layout a cell
        // Because we are reusing "postCell" cells, a reused cell might have an image already set on it.
        // This always resets the image to blank, waits for the image to download, and then sets it
        cell.selfieImageView.image = nil
        
        let imageFile = post.image
        imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
            if let data = data {
                let image = UIImage(data: data)
                cell.selfieImageView.image = image
            }
        }
//        imageFile.getDataInBackgroundWithBlock {(data, error) -> void in
//                    }
//        let task = NSURLSession.sharedSession().downloadTaskWithURL(post.imageURL) { (url, response, error) -> Void in
//            
//            if let imageURL = url,
//                let imageData = NSData(contentsOfURL: imageURL){
//                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                        
//                        cell.selfieImageView.image = UIImage(data: imageData)
//                        
//                    })
//            }
//        }
//        
//        task.resume()
        
        cell.usernameLabel.text = post.user.username
        cell.commentLabel.text = post.comment

//        
//        let post = self.posts[indexPath.row]
//        
//        //cell.imageView?.image = post.image
//        
//        cell.selfieImageView.image = post.image
//        cell.usernameLabel.text = post.user.username
//        cell.commentLabel.text = post.comment

        
//         Configure the cell...
//         cell.textLabel?.text = "This is a post\(indexPath.row)."
//         cell.textLabel?.text = words[indexPath.row]
        return cell
    }

    @IBAction func cameraButtonPressed(sender: AnyObject) {
        print("Camera Button Pressed")
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
                    
                    //2. We create a Post object from the image
                    let post = Post(image: imageFile, user: user, comment: "A Selfie")
                    
                    post.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
                            print("Post successfully saved in Parse")
                            
                            //3. Add post to our posts array, chose index 0 so that it will be added
                            //   to the top of your table instead of at the bottom (default behaviour)
                            self.posts.insert(post, atIndex: 0)
                            
                            //4. Now that we have added a post, updating our table
                            //   We are just inserting our new Post instead of reloading our whole tableView
                            //   Both method would work, however, this gives us a cool animation for free
                            
                            let indexPath =  NSIndexPath(forRow: 0, inSection: 0)
                            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                            
                            
                        }
                    })
            }
            
        }
        
        //3. We remember to dismiss the Image Picker from our screen.
        dismissViewControllerAnimated(true, completion: nil)
        
    }


//    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
//            
//            // 1. When the delegate method is returned, it passes along a dictionary called info.
//            //    This dictionary contains multiple things that maybe useful to us.
//            //    We are getting an image from the UIImagePickerControllerOriginalImage key in that dictionary
//            if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
//                
//                // setting the compression quality to 90%
//                if let imageData = UIImageJPEGRepresentation(image, 0.9),
//                   let imageFile = PFFile(data: imageData){
//                        
//                
//                //2. We create a Post object from the image
////                let me = User(aUsername: "Asuka", aProfileImage: UIImage(named: "grumpy-cat")!)
////                let post = Post(image: image, user: me, comment: "My Selfie")
//                //profileImageView.image = image
//                
//                //3.Add post to our posts array (and therefore our table, when pi)
////                posts.insert(post, atIndex: 0)
//                }
//            }
//        
//            //4. We remember to dismiss the Image Picker from our screen.
//            dismissViewControllerAnimated(true, completion: nil)
//            //5. Now that we have added a post, reload our table
//            tableView.reloadData()
//    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}
