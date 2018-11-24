//
//  ProfileCollectionViewCell.swift
//  Instagram
//
//  Created by German Flores on 3/5/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse

class ProfileCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellImageView: UIImageView!
    var postForCell: PFObject!
}
