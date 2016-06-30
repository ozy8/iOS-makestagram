//
//  ParseHelper.swift
//  Makestagram
//
//  Created by Ow Zhiyin on 30/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import Foundation
import Parse

// 1
class ParseHelper {
    
    // 2
    static func timelineRequestForCurrentUser(completionBlock: PFQueryArrayResultBlock) {
        let followingQuery = PFQuery(className: "Follow")
        followingQuery.whereKey("fromUser", equalTo:PFUser.currentUser()!)
        
        let postsFromFollowedUsers = Post.query()
        postsFromFollowedUsers!.whereKey("user", matchesKey: "toUser", inQuery: followingQuery)
        
        let postsFromThisUser = Post.query()
        postsFromThisUser!.whereKey("user", equalTo: PFUser.currentUser()!)
        
        let query = PFQuery.orQueryWithSubqueries([postsFromFollowedUsers!, postsFromThisUser!])
        query.includeKey("user")
        query.orderByDescending("createdAt")
        
        // 3
        query.findObjectsInBackgroundWithBlock(completionBlock)
    }
    
}