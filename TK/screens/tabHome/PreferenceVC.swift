//
//  HealthInfoVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/23.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import RxDataSources
import Alamofire
import SDWebImage


class PreferenceVC: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var btnConfirm: UIButton!
    
    var tagArray : [TagModel] = []
    var selectedTag : [Int] = []
    var buttonTitle : String = "\"마들렌\" 시작하기"
    
    private let spacing:CGFloat = 5
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupCollectionView()
        
    }
    private func setupUI(){
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.setTitle(buttonTitle, for: .normal)
    }
    private func setupCollectionView(){
        
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        collectionView.collectionViewLayout = layout
        
        let categoryCellNib = UINib(nibName: "CategoryCollectionCell", bundle: nil)
        self.collectionView.register(categoryCellNib, forCellWithReuseIdentifier: "CategoryCollectionCell")
    }
    
    @IBAction func actionBtnConfirm(_ sender: Any) {
        self.savePreferenceAPI()
    }
    
    //API
    private func savePreferenceAPI() {
        if selectedTag.count == 0 {
            self.alert(title: "하나 이상의 태그를 선택해 주세요.")
            return
        }
        var str = "{ \"value\" : ["
        for i in 0..<selectedTag.count {
            if i == selectedTag.count-1 {
                str.append("\(selectedTag[i])] }")
                break
            }
            str.append("\(selectedTag[i]),")
        }
        print(str)
        let parameters : Parameters = [
            "username": UserDefaults.standard.string(forKey: "username") ?? "",
            "tags" : str
        ]
        ApiService.shared.setUserTags(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(StringResponse.self, from : data)
                if res.status == "S00" {
                    DispatchQueue.main.async {
                        self.alert(title: "등록성공", message: "관심 태그가 설정되었습니다.", okTitle: "확인", okHandler: nil, cancelTitle: "확인", cancelHandler: { (action) in
                            UserDefaults.standard.set(true, forKey: "first_launch")
                            
                            self.dismiss(animated: true, completion: nil)
                        }, completion: nil)
                    }
                }else{
                    Utils.showAlertMessage(vc: self, titleStr: "태그오류", messageStr: "하나 이상의 태그를 선택해 주세요")
                }
            }catch{
                print(data.description)
                print("error")
            }
        })
    }
    
    
    
}
extension PreferenceVC : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 22
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionCell", for: indexPath) as? CategoryCollectionCell {
            cell.isCellSelected = false
            cell.containerView.layer.cornerRadius = 5
            cell.imageView.layer.cornerRadius = 5
            
            cell.lbTitle.textColor = .white
            let item = tagArray[indexPath.row]
            cell.lbTitle.text = item.tag_name
            cell.imageView.sd_setImage(with: URL(string: item.tag_image ?? ""), completed: nil)
            
            if selectedTag.contains(item.tag_pk ?? -1) {
                let color = UIColor(named: "color_pink_transparent")
                cell.isCellSelected = true
                cell.lbTitle.backgroundColor = color
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? CategoryCollectionCell {
            if cell.isCellSelected == false {
                cell.isCellSelected = true
                let color = UIColor(named: "color_pink_transparent")
                cell.lbTitle.backgroundColor = color
                cell.layer.cornerRadius = 5
                
                if selectedTag.contains(tagArray[indexPath.row].tag_pk ?? -1) == false {
                    selectedTag.append(tagArray[indexPath.row].tag_pk ?? -1)
                }
            }else{
                cell.isCellSelected = false
                cell.layer.cornerRadius = 5
                cell.lbTitle.backgroundColor = .clear
                
                if let index = selectedTag.firstIndex(of: tagArray[indexPath.row].tag_pk ?? -1) {
                    selectedTag.remove(at: index)
                }
            }
        }
        print(selectedTag)
    }
    
}
extension PreferenceVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let numberOfItemsPerRow:CGFloat = 4
        let spacingBetweenCells:CGFloat = 5
        let totalSpacing = (2 * self.spacing) + ((numberOfItemsPerRow - 1) * spacingBetweenCells) //Amount of total spacing in a row
        if let collection = self.collectionView{
            let width = (collection.bounds.width - totalSpacing)/numberOfItemsPerRow - 8
            return CGSize(width: width, height: width)
        }else{
            return CGSize(width: 0, height: 0)
        }
    }
}


