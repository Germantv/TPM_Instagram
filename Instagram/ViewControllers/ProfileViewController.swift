//
//  ProfileViewController.swift
//  Instagram
//
//  Created by German Flores on 3/5/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    var userPostsArray = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        let user = PFUser.current()
        nameLabel.text = user?.username
        bioLabel.text = user?.value(forKey: "bio") as? String
        userPostsArray = HomeViewController.postsArray
        profileImageView.image = UIImage(named: "profile_tab")
        profileImageView.layer.cornerRadius = profileImageView.frame.height/2
        profileImageView.clipsToBounds = true
        collectionView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userPostsArray = HomeViewController.postsArray
        collectionView.reloadData()
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProfileCollectionViewCell", for: indexPath) as! ProfileCollectionViewCell
        cell.postForCell = userPostsArray[indexPath.row]
        if let postPFFile = cell.postForCell.value(forKey: "media") as? PFFile {
            postPFFile.getDataInBackground(block: { (imageData: Data?, error: Error?) -> Void in
                if error == nil {
                    let imageSize = round((collectionView.contentSize.width - 9)/3)
                    cell.cellImageView.image = PhotoPick.resize(image: UIImage(data: imageData!)!, newSize: CGSize(width: imageSize, height: imageSize))
                }
            })
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return userPostsArray.count
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        let imageSize = round((collectionView.contentSize.width - 9)/3)
        return CGSize(width: imageSize, height: imageSize);
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
