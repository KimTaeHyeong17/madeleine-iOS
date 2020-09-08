//
//  CategoryCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import SDWebImage

protocol CategoryCellSelectDelegate: class {
    func collectionView(collectionviewcell: CategoryCollectionCell?, index: Int, didTappedInTableViewCell: CategoryCell, cellType: Int)
    // other delegate methods that you can define to perform action in viewcontroller
}

class CategoryCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var tagsArray : [TagModel] = []
    var cellType : Int = 0
    weak var cellDelegate: CategoryCellSelectDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CategoryCollectionCell")
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
extension CategoryCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tagsArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategoryCollectionCell {
            cell.containerView.backgroundColor = .darkGray
            cell.containerView.layer.cornerRadius = 5
            cell.lbTitle.textColor = .white
            cell.imageView.layer.cornerRadius = 5
            let item = tagsArray[indexPath.row]
            cell.lbTitle.text = item.tag_name
            cell.imageView.sd_setImage(with: URL(string: item.tag_image ?? ""), completed: nil)
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self, cellType: cellType)
    }
}
extension CategoryCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = self.collectionView.frame.height/3-4
        return CGSize(width: width, height: width)
    }
}

