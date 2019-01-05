//
//  FeedCell.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 23/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import UIKit
import Nuke

class FeedCell: UITableViewCell {
    @IBOutlet weak var cellTitle: UILabel!
    @IBOutlet weak var cellText: UILabel!
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var likes: UILabel!
    @IBOutlet weak var date: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.layer.masksToBounds = false
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        
        let shadowPath = UIBezierPath(rect: bounds)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
    }
    
    func setDate(unixDate: Double) {
        let date = Date(timeIntervalSince1970: unixDate)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        self.date.text = dateFormatter.string(from: date)
    }
    
    func setImage(url: URL!) {
        if(url != nil) {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    placeholder: UIImage(named: "postPlaceholder"),
                    transition: .fadeIn(duration: 0.33)
            ), into: self.photo)
        }
    }
    
    func setAvatar(url: URL!) {
        if(url != nil) {
            Nuke.loadImage(
                with: url,
                options: ImageLoadingOptions(
                    placeholder: nil,
                    transition: .fadeIn(duration: 0.33)
            ), into: self.avatar)
        }
    }
}
