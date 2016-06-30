//
//  TimelineViewController.swift
//  Makestagram
//
//  Created by Ow Zhiyin on 27/6/16.
//  Copyright © 2016 Make School. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var photoTakingHelper: PhotoTakingHelper?
    var posts: [Post] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.delegate = self
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        ParseHelper.timelineRequestForCurrentUser {
            (result: [PFObject]?, error: NSError?) -> Void in
            self.posts = result as? [Post] ?? []
//            for post in self.posts {
//                do {
//                    let data = try post.imageFile?.getData()
//                    post.image = UIImage(data: data!, scale:1.0)
//                } catch {
//                    print("could not get image")
//                }
//            }
            
            self.tableView.reloadData()
        }
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // 1
        return posts.count
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
        let post = posts[indexPath.row]
        // 1
        post.downloadImage()
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
