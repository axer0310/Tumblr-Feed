//
//  PhotoCell.swift
//  Tumblr Feed
//
//  Created by Arthur on 2017/2/1.
//  Copyright © 2017年 Kuan-Ting Wu (Arthur Wu). All rights reserved.
//

import UIKit

class PhotoCell: UITableViewCell {

    
    @IBOutlet var poster: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
