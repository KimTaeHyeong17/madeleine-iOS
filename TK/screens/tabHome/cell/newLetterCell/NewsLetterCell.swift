//
//  NewsLetterCell.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation

protocol ShowCollectionViewItemDelegate: class {
    func collectionView(collectionviewcell: NewsLetterCollectionCell?, index: Int, didTappedInTableViewCell: NewsLetterCell, cellType: Int)
    // other delegate methods that you can define to perform action in viewcontroller
}

protocol ShowAllActionDelegate {
    func showAllPressed(CellType cellType : Int?)
}

class NewsLetterCell: UITableViewCell {
    weak var cellDelegate: ShowCollectionViewItemDelegate?
    var showAllActionDelegate : ShowAllActionDelegate?
    
    var cellType = 0
    var newsArray : [SubscribeModel] = []
  
    
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    let behavior = MSCollectionViewPeekingBehavior()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.clipsToBounds = false
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "NewsLetterCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "NewsLetterCollectionCell")
        
        behavior.cellSpacing = 6
        behavior.cellPeekWidth = 14
        behavior.numberOfItemsToShow = 2
        collectionView.configureForPeekingBehavior(behavior: behavior)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func actionShowAll(_ sender: Any) {
        showAllActionDelegate?.showAllPressed(CellType: cellType)
    }
}
extension NewsLetterCell : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if newsArray.count == 0 {
            return 0
        }
        return 4
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsLetterCollectionCell", for: indexPath) as? NewsLetterCollectionCell {
            let item = newsArray[indexPath.row]
            cell.lbTitle.text = item.newsletter_name
            cell.tagListView.removeAllTags()
            for tag in item.newsletter_tags! {
                cell.tagListView.addTag(tag.tag_name ?? "")
                if cell.tagListView.tagViews.count == 2 {break}
            }
            cell.clipsToBounds = false
            cell.imageView.sd_setImage(with: URL(string: item.newsletter_image ?? ""), completed: nil)
            
            cell.imageView.applyshadowWithCorner(containerView: cell.imageViewContainer, cornerRadious: 5)
            
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? NewsLetterCollectionCell
        self.cellDelegate?.collectionView(collectionviewcell: cell, index: indexPath.item, didTappedInTableViewCell: self, cellType: cellType)
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        behavior.scrollViewWillEndDragging(scrollView, withVelocity: velocity, targetContentOffset: targetContentOffset)
    }
    
}
