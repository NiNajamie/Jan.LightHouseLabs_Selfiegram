//
//  Post.swift
//  Storyboard
//
//  Created by Asuka Nakagawa on 2016-01-19.
//  Copyright © 2016 Asuka Nakagawa. All rights reserved.
//

import Foundation
import UIKit
import Parse

class Post: PFObject, PFSubclassing  {
    
    var likes: PFRelation! {
        // PFRelations are a bit different from other properties
        // This is called a “computed property”, because it’s value is computed every time instead of stored.
        // The line below specifies that our relation column on Parse.com should be called “likes”
        return relationForKey("likes")
    }
    
    @NSManaged var image : PFFile
    @NSManaged var user : PFUser
    @NSManaged var comment : String
    
    static func parseClassName() -> String {
    // Sets what the table name on Parse will be called
        return "Post"
    }
    
    // convenience init method, because it’s building on top of PFObject’s init, rather than overriding it.
    convenience init(image:PFFile, user:PFUser, comment:String){
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        self.init()
        self.image = image
        self.user = user
        self.comment = comment
    
//    init(imageURL: NSURL, user: User, comment: String) {
        // You can name the property you are passing into the function the
        // same name as the class' property. To distinguish the two
        // add "self." to the beginning of the class' property.
        // So for example we are passing in an UIImage called image and setting it as our
        // image property for Post.
        
    }
}