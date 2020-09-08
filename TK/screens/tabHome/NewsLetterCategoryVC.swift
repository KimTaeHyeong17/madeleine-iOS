//
//  NewsLetterCategoryVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/05.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit

class NewsLetterCategoryVC: UIViewController {
    
    
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var categoryTitle = "카테고리"
    var newsArray : [SubscribeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
    }
    private func setupUI(){
        lbTitle.text = categoryTitle
    }
    private func setupCollectionView(){
        collectionView.delegate = self
        collectionView.dataSource = self
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left:30, bottom: 0, right: 30)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        collectionView.collectionViewLayout = layout
        
        // Register the xib for collection view cell
        let cellNib = UINib(nibName: "NewsLetterCollectionCell", bundle: nil)
        self.collectionView.register(cellNib, forCellWithReuseIdentifier: "NewsLetterCollectionCell")
    }
    private func showNewsLetterDetailVC(_ newsLetter_pk : Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsLetterDetailVC") as? NewsLetterDetailVC
        vc?.newsLetter_pk = newsLetter_pk
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
}
extension NewsLetterCategoryVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return newsArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsLetterCollectionCell", for: indexPath) as? NewsLetterCollectionCell {
            let item = newsArray[indexPath.row]
            cell.clipsToBounds = false
            cell.imageView.applyshadowWithCorner(containerView: cell.imageViewContainer, cornerRadious: 5)
            
            cell.lbTitle.text = item.newsletter_name
            cell.imageView.sd_setImage(with: URL(string: item.newsletter_image ?? ""), completed: nil)
            
            cell.tagListView.removeAllTags()
            
            for tag in item.newsletter_tags! {
                cell.tagListView.addTag(tag.tag_name ?? "")
                if cell.tagListView.tagViews.count == 2 {break}
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        showNewsLetterDetailVC(newsArray[indexPath.row].newsletter_pk ?? -1)
        
    }
}
extension  NewsLetterCategoryVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //150
        let width = 150
        return CGSize(width: width, height: 210)
    }
    
}
