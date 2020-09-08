//
//  SubscriptionCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/06.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import TagListView
class SubscriptionCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var imageContainerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.setCustomStyle()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
