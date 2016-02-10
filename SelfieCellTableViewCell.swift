//
//  SelfieCellTableViewCell.swift
//  Storyboard
//
//  Created by Asuka Nakagawa on 2016-01-21.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

import UIKit
import Parse



class SelfieCellTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var likeButton: UIButton!
    var post:Post? {
        didSet{
            if let post = post {
                // I've added this line to prevent flickering of images
                // We are inside the cellForRowAtIndexPath method that gets called everytime we lay out a cell
                // This always resets the image to blank, waits for the image to download, and then sets it
                selfieImageView.image = nil
                
                let imageFile = post.image
                imageFile.getDataInBackgroundWithBlock { (data, error) -> Void in
                    if let data = data {
                        let image = UIImage(data: data)
                        self.selfieImageView.image = image
                    }
                }
                
                usernameLabel.text = post.user.username
                commentLabel.text = post.comment
                
                // set the likeButton defaulted to false
                likeButton.selected = false
                
                // query the likes property on post
                let query = post.likes.query()
                query.findObjectsInBackgroundWithBlock({ (users, error) -> Void in
                    
                    if let users = users as? [PFUser]{
                        for user in users {
                            // If we find that the current user's objectId in our collection
                            // of likes we set the likeButton to selected
                            // objectId is a great way to compare if two objects are equal
                            if user.objectId == PFUser.currentUser()?.objectId {
                                self.likeButton.selected = true
                            }
                        }
                    }
                })
                
            }
        }
    }
    
    @IBOutlet weak var selfieImageView: UIImageView!

    @IBOutlet weak var usernameLabel: UILabel!

    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var heartAnimationView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func likeButtonClicked(sender: UIButton) {
        
        // the ! symbol means NOT
        // We are therefore setting the button's selected state to
        // the opposite of what it was. This is a great way to toggle buttons
        //
        sender.selected = !sender.selected
        
        // Get rid of Optionals
        if let post = post,
            let user = PFUser.currentUser() {
                
                // like button has been selected and we should add a like from currentUser
                if sender.selected {
                    
                    // PFRelation has a useful method called addObject that adds the unique element
                    // you are passing in as the argument. It will never add multiple copies
                    // of the same element (in this case user)
                    post.likes.addObject(user)
                    
                    // We have modified the likes property on post. We must now save it to Parse
                    post.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
                            print("like from user successfully saved")
                            
                            // Creating an row in the Activity table
                            // Saving it as a "like" type
                            let activity = Activity(type: "like", post: post, user: user)
                            activity.saveInBackgroundWithBlock({ (success, error) -> Void in
                                print("activity successfully saved")
                            })
                            
                            
                        }else{
                            print("error is \(error)")
                        }
                    })
                    
                    
                }else { // like button has been deselected and we should remove the like
                    
                    // PFRelation also has a useful method called removeObject that removes
                    // the element if there is an element to be removed.
                    post.likes.removeObject(user)
                    post.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if success {
                            print("like from user successfully removed")
                            
                            //PFQuery to find the like activity
                            if let activityQuery = Activity.query(){
                                activityQuery.whereKey("post", equalTo: post)
                                activityQuery.whereKey("user", equalTo: user)
                                activityQuery.whereKey("type", equalTo: "like")
                                activityQuery.findObjectsInBackgroundWithBlock({ (activities, error) -> Void in
                                    
                                    
                                    // You should only have one like activity from a user
                                    // but this is code is being safe and checking for one or multiple instances
                                    // and then deleting all of them
                                    if let activities = activities {
                                        for activity in activities {
                                            activity.deleteInBackgroundWithBlock({ (success, error) -> Void in
                                                print("deleted activity")
                                            })
                                        }
                                    }
                                })
                            }
                            
                        }else{
                            print("error is \(error)")
                        }
                    })
                    
                }
        }
        
    }
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func tapAnimation() {
        
        // set heartAnimationView to be very tiny and not hidden
        self.heartAnimationView.transform = CGAffineTransformMakeScale(0, 0)
        self.heartAnimationView.hidden = false
        
        //animation for 1 second, no delay
        UIView.animateWithDuration(1.0, delay: 0, options: [], animations: { () -> Void in
            
            // during our animation change heartAnimationView to be 3X what it is on storyboard
            self.heartAnimationView.transform = CGAffineTransformMakeScale(3, 3)
            
            }) { (success) -> Void in
                
                // when animation is complete set heartAnimationView to be hidden
                self.heartAnimationView.hidden = true
        }
        
        likeButtonClicked(likeButton)
        
    }

}

