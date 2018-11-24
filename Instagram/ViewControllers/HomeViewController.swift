//
//  HomeViewController.swift
//  Instagram
//
//  Created by German Flores on 3/4/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let refreshControl = UIRefreshControl()
    static var postsArray: [Post] =  []
    
    @IBAction func logoutButton(_ sender: Any) {
        NotificationCenter.default.post(name: NSNotification.Name("didLogout"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 400
        
        let dummyViewHeight = CGFloat(40)
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.bounds.size.width, height: dummyViewHeight))
        tableView.contentInset = UIEdgeInsetsMake(-dummyViewHeight, 0, 0, 0)
        
        //refreshControl stuff
        refreshControl.addTarget(self, action: #selector(refreshControlAction(_:)), for: UIControlEvents.valueChanged)
        tableView.insertSubview(refreshControl, at: 0)
        
        let logo = UIImage(named: "instagram_logo_resized")
        let imageView = UIImageView(image: logo)
        self.navigationItem.titleView = imageView
        
        performQuery()
    }
    
    @objc func refreshControlAction(_ refreshControl: UIRefreshControl){
        performQuery()
    }
    
    func performQuery(){
        let query = PFQuery(className: "Post")
        query.addDescendingOrder("createdAt")
        query.limit = 20
        
        MBProgressHUD.showAdded(to: self.view, animated: true)
        query.findObjectsInBackground { (posts: [PFObject]?, error: Error?) -> Void in
            MBProgressHUD.hide(for: self.view, animated: true)
            if posts != nil {
                HomeViewController.postsArray = posts as! [Post]
                print(HomeViewController.postsArray)
            } else {
                print(error?.localizedDescription as Any)
            }
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return HomeViewController.postsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeTableViewCell
        //cell.postForCell = HomeViewController.postsArray[indexPath.row]
        cell.post = HomeViewController.postsArray[indexPath.section]

        //cell.postCaptionLabel.text = postsArray["caption"] as! String
        //cell.postImageView.file = postsArray["media"] as! PFFile
        cell.postImageView.loadInBackground()

        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: 320, height: 80))
        headerView.backgroundColor = UIColor(white: 1, alpha: 0.9)
        
        let profileView = UIImageView(frame: CGRect(x: 15, y: 10, width: 50, height: 50))
        profileView.clipsToBounds = true
        profileView.layer.cornerRadius = 25;
        profileView.layer.borderColor = UIColor(white: 0.7, alpha: 0.8).cgColor
        profileView.layer.borderWidth = 1;
        profileView.image = UIImage(named: "profile_tab")
        
        // Set the avatar
        
        headerView.addSubview(profileView)
        
        let profileNameView = UILabel(frame: CGRect(x: 75, y: 25, width:200, height:20))
        profileNameView.adjustsFontSizeToFitWidth = true
        profileNameView.font = UIFont(name:"HelveticaNeue-Bold", size: 16.0)
        
        let post = HomeViewController.postsArray[section]

        let query = PFUser.query()
        
        do {
            let user = try query?.getObjectWithId(post.author.objectId!)
            profileNameView.text = user?.object(forKey: "username") as? String
        } catch {
            print(error)
        }
        
        
        headerView.addSubview(profileNameView)
        
        return headerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

