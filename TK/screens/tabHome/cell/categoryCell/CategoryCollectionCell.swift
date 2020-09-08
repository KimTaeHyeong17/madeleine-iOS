//
//  CategoryCollectionCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit

class CategoryCollectionCell: UICollectionViewCell {
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    
    var isCellSelected : Bool = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
