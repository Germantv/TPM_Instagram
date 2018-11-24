//
//  HomeTableViewCell.swift
//  Instagram
//
//  Created by German Flores on 3/4/18.
//  Copyright © 2018 German Flores. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var postImageView: PFImageView!
    @IBOutlet weak var postCaptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var post: Post! {
        didSet {
            self.postCaptionLabel.text = post.caption
            self.postImageView.file = post.media as PFFile
            self.postImageView.loadInBackground()
            self.timeStampLabel.text = convertDateToTimeStamp()
        }
    }
    
    func convertDateToTimeStamp() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(abbreviation: "ET")
        dateFormatter.dateFormat = "MMM dd, HH:mm"
        let strDate = dateFormatter.string(from: post.createdAt!)
        return strDate
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
