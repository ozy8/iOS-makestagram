//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Ow Zhiyin on 27/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse
import ConvenienceKit

class TimelineViewController: UIViewController, TimelineComponentTarget {
    
    @IBOutlet weak var tableView: UITableView!
    var photoTakingHelper: PhotoTakingHelper?
//    var posts: [Post] = []
    
    let defaultRange = 0...4
    let additionalRangeSize = 5
    
    var timelineComponent: TimelineComponent<Post, TimelineViewController>!
    
    func loadInRange(range: Range<Int>, completionBlock: ([Post]?) -> Void) {
        // 1
        ParseHelper.timelineRequestForCurrentUser(range) { (result: [PFObject]?, error: NSError?) -> Void in
            //generic error handling
            if let error = error {
                ErrorHandling.defaultErrorHandler(error)
            }
            // 2
            let posts = result as? [Post] ?? []
            // 3
            completionBlock(posts)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        timelineComponent = TimelineComponent(target: self)
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        timelineComponent.loadInitialIfRequired()
        
//        ParseHelper.timelineRequestForCurrentUser {
//            (result: [PFObject]?, error: NSError?) -> Void in
//            self.posts = result as? [Post] ?? []
//            for post in self.posts {
//                do {
//                    let data = try post.imageFile?.getData()
//                    post.image = UIImage(data: data!, scale:1.0)
//                } catch {
//                    print("could not get image")
//                }
//            }
//            
//            self.tableView.reloadData()
//        }
    }

    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
//            if let image = image {
//                let imageData = UIImageJPEGRepresentation(image, 0.8)!
//                let imageFile = PFFile(name: "image.jpg", data: imageData)!
//                
//                let post = PFObject(className: "Post")
//                post["imageFile"] = imageFile
//                post.saveInBackground()
//            }

            let post = Post()
            post.image.value = image!
            post.uploadPost()
        }
    }
}

// MARK: Tab Bar Delegate

extension TimelineViewController: UITableViewDataSource {
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.timelineComponent.content.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
//        return posts.count
//        return timelineComponent.content.count
          return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        // 2
//        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell")!
//        
//        cell.textLabel!.text = "Post"
//        
//        return cell
        
        // 1
        let cell = tableView.dequeueReusableCellWithIdentifier("PostCell") as! PostTableViewCell
        
        // 2
//        cell.postImageView.image = posts[indexPath.row].image
//        let post = posts[indexPath.row]
//        let post = timelineComponent.content[indexPath.row]
        let post = timelineComponent.content[indexPath.section]
        // 1
        post.downloadImage()
        //to assess the fetchLikes() function
        post.fetchLikes()
        // 2
        cell.post = post
        
        return cell
    }
}

extension TimelineViewController: UITabBarControllerDelegate {
    
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool {
        if (viewController is PhotoViewController) {
//            print("Take Photo")
            takePhoto()
            return false
        } else {
            return true
        }
    }
}


extension TimelineViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
//        timelineComponent.targetWillDisplayEntry(indexPath.row)
          timelineComponent.targetWillDisplayEntry(indexPath.section)
    }
    
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCellWithIdentifier("PostHeader") as! PostSectionHeaderView
        
        let post = self.timelineComponent.content[section]
        headerCell.post = post
        
        return headerCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
}
