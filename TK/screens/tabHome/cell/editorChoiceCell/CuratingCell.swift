//
//  CuratingCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation

protocol CollectionViewCellDelegate: class {
    func collectionView(collectionviewcell: CuratingCollectionCell?, index: Int, didTappedInTableViewCell: CuratingCell)
    // other delegate methods that you can define to perform action in viewcontroller
}

class CuratingCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let behavior = MSCollectionViewPeekingBehavior()
    weak var cellDelegate: CollectionViewCellDelegate?
    var curationArray : [CurationModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        let cellNib = UINib(nibName: "CuratingCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "CuratingCollectionCell")
        
        behavior.cellSpacing = 10
        behavior.cellPeekWidth = 10
        collectionView.configureForPeekingBehavior(behavior: behavior)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
}
extension CuratingCell : UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return curationArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CuratingCollectionCell", for: indexPath) as? CuratingCollectionCell {
            let item = curationArray[indexPath.row]
            cell.lbTitle.text = item.page_intro_title
            cell.imageView.sd_setImage(with: URL(string: item.page_image ?? ""), completed: nil)
          
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? CuratingCollectionCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
}
