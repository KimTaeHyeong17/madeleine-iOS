//
//  TestVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import Alamofire
import CRRefresh

class HomeVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var tagArray : [TagModel] = []
    var recommendArray : [SubscribeModel] = []
    var tagNewsLetterArray : [SubscribeModel] = []
    var famousNewsLetterArray : [SubscribeModel] = []
    var curationArray : [CurationModel] = []
    var name : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        getAllTags()
        getRecommendNewsLetter()
        getNewsLetterByRanking()
        getNewsLetterCuration()
    }
    override func viewDidAppear(_ animated: Bool) {
        getUserInfo()
    }
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupTableView(){
        // Register the xib for tableview cell
        tableView.delegate = self
        tableView.dataSource = self
        // #1
        let curatingCellNib = UINib(nibName: "CuratingCell", bundle: nil)
        self.tableView.register(curatingCellNib, forCellReuseIdentifier: "CuratingCell")
        // #2 #3
        let newsLetterCellNib = UINib(nibName: "NewsLetterCell", bundle: nil)
        self.tableView.register(newsLetterCellNib, forCellReuseIdentifier: "NewsLetterCell")
        // #4
        let categoryCellNib = UINib(nibName: "CategoryCell", bundle: nil)
        self.tableView.register(categoryCellNib, forCellReuseIdentifier: "CategoryCell")
        
        
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// start refresh
            /// Do anything you want...
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                self?.getUserInfo()
                self?.getRecommendNewsLetter()
                self?.getNewsLetterByRanking()
                self?.getRecommendNewsLetter()
                
            })
        }
    }
    
    
    private func showNewsLetterCategoryVC(_ title : String, _ data : [SubscribeModel]){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let newsLetterCategoryVC = storyboard.instantiateViewController(identifier: "NewsLetterCategoryVC") as? NewsLetterCategoryVC
        newsLetterCategoryVC?.categoryTitle = title
        newsLetterCategoryVC?.newsArray = data
        self.navigationController?.pushViewController(newsLetterCategoryVC!, animated: true)
    }
    private func showPreferenceVC(){
        if UserDefaults.standard.bool(forKey: "first_launch") {
            return
        }
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PreferenceVC") as? PreferenceVC
        vc?.modalPresentationStyle = .overFullScreen
        //        vc?.isModalInPresentation = true
        vc?.tagArray = tagArray
        present(vc!,animated: true)
    }
    private func showCuratingDetailVC(_ index : Int){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CuratingDetailVC") as? CuratingDetailVC
        vc?.curationInfo = curationArray[index]
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    private func showNewsLetterDetailVC(_ newsLetter_pk : Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsLetterDetailVC") as? NewsLetterDetailVC
        vc?.newsLetter_pk = newsLetter_pk
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //API
    private func getAllTags(){
        let parameters : Parameters = [:]
        ApiService.shared.getAllTags(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(TagModelResponse.self, from : data)
                if res.status == "S00" {
                    self.tagArray = res.value ?? [TagModel]()
                    self.showPreferenceVC()
                }else{
                    print(res.message ?? "")
                }
            }catch{
                print(data.description)
                print("error")
            }
        })
    }
    private func getUserInfo(){
        let parameters : Parameters = [
            "username" : UserDefaults.standard.string(forKey: "username") ?? ""
        ]
        ApiService.shared.getUserInfo(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(UserInfoResponse.self, from : data)
                if res.status == "S00" {
                    self.name = "\(res.value?.last_name ?? "")\(res.value?.first_name ?? "")"
                    print(self.name)
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                    
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getUserInfo Parsing Error")
            }
        })
    }
    private func getRecommendNewsLetter(){
        let parameters : Parameters = [
            "username" : UserDefaults.standard.string(forKey: "username") ?? ""
        ]
        ApiService.shared.getRecommendNewsLetter(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(RecommendModel.self, from : data)
                if res.status == "S00" {
                    self.recommendArray = res.value ?? [SubscribeModel]()
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                    
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getRecommendNewsLetter Parsing Error")
            }
        })
    }
    private func getNewsLetterByTag(Tag tag_pk : Int, TagName tag_name : String){
        let parameters : Parameters = [
            "tag" : tag_pk
        ]
        ApiService.shared.getNewsLetterByTag(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(RecommendModel.self, from : data)
                if res.status == "S00" {
                    self.showNewsLetterCategoryVC(tag_name, res.value ?? [SubscribeModel]())
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getRecommendNewsLetter Parsing Error")
            }
        })
    }
    private func getNewsLetterByRanking(){
        let parameters : Parameters = [:]
        ApiService.shared.getNewsLetterByRanking(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(RecommendModel.self, from : data)
                if res.status == "S00" {
                    self.famousNewsLetterArray = res.value ?? [SubscribeModel]()
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                    
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getNewsLetterByRanking Parsing Error")
            }
        })
    }
    private func getNewsLetterCuration(){
        let parameters : Parameters = [:]
        ApiService.shared.getCurationInfo(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(CurationResponseModel.self, from : data)
                if res.status == "S00" {
                    self.curationArray = res.value!
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                    
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getNewsLetterByRanking Parsing Error")
            }
        })
    }
    
    
    
}
extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return 260
        case 1:
            return 270
        case 2:
            return 270
        case 3:
            return 340
        default:
            return 80
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CuratingCell") as? CuratingCell {
                cell.cellDelegate = self
                cell.curationArray = curationArray
                cell.collectionView.reloadData()
                
                return cell
            }
        case 1:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLetterCell") as? NewsLetterCell {
                cell.lbName.text = name
                cell.newsArray = self.recommendArray
                cell.collectionView.reloadData()
                cell.cellType = 0
                cell.showAllActionDelegate = self
                cell.cellDelegate = self
                
                
                return cell
            }
        case 2:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLetterCell") as? NewsLetterCell {
                cell.lbName.text = ""
                cell.lbTitle.text = "사람들이 많이보는 뉴스레터"
                cell.newsArray = self.famousNewsLetterArray
                cell.collectionView.reloadData()
                cell.cellType = 1
                cell.showAllActionDelegate = self
                cell.cellDelegate = self
                return cell
            }
        case 3:
            if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
                cell.tagsArray = tagArray
                cell.cellType = 2
                cell.cellDelegate = self
                cell.collectionView.reloadData()
                return cell
            }
        default:
            return UITableViewCell()
        }
        
        return UITableViewCell()
        
    }
}
extension HomeVC: CollectionViewCellDelegate {
    func collectionView(collectionviewcell: CuratingCollectionCell?, index: Int, didTappedInTableViewCell: CuratingCell) {
        showCuratingDetailVC(index)
    }
}
extension HomeVC: ShowAllActionDelegate {
    func showAllPressed(CellType cellType: Int?) {
        switch cellType {
        case 0: //개인추천
            showNewsLetterCategoryVC("추천하는 뉴스레터",recommendArray)
        case 1:
            showNewsLetterCategoryVC("사람들이 많이보는 뉴스레터",recommendArray)
        default:
            break
        }
    }
}
extension HomeVC : ShowCollectionViewItemDelegate, CategoryCellSelectDelegate {
    func collectionView(collectionviewcell: CategoryCollectionCell?, index: Int, didTappedInTableViewCell: CategoryCell, cellType: Int) {
        getNewsLetterByTag(Tag: tagArray[index].tag_pk ?? -1,TagName: tagArray[index].tag_name!)
    }
    func collectionView(collectionviewcell: NewsLetterCollectionCell?, index: Int, didTappedInTableViewCell: NewsLetterCell, cellType: Int) {
        switch cellType {
        case 0: //개인추천
            showNewsLetterDetailVC(recommendArray[index].newsletter_pk ?? -1)
            break
        case 1: //사람들이 많이보는 뉴스레터
            showNewsLetterDetailVC(famousNewsLetterArray[index].newsletter_pk ?? -1)
            break
        default:
            break
        }
        
    }
}
