//
//  NewsLetterCollectionCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import TagListView

class NewsLetterCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        tagListView.setCustomStyleNoBackground()
        // Initialization code
    }
}
