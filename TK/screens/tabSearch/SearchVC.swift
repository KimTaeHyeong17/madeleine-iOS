//
//  SearchVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices

class SearchVC: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var newsletterArray : [SubscribeModel]? = []
    var tagArray : [TagModel]? = []
    var episodeArray : [EpisodeModel]? = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.isHidden = true
        setupSearchBar()
        self.hideKeyboardWhenTappedAround()
        setupTableView()
        setupUI()
        
    }
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupTableView(){
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
    }
    private func showNewsLetterCategoryVC(_ title : String){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let newsLetterCategoryVC = storyboard.instantiateViewController(identifier: "NewsLetterCategoryVC") as? NewsLetterCategoryVC
        newsLetterCategoryVC?.categoryTitle = title
        self.navigationController?.pushViewController(newsLetterCategoryVC!, animated: true)
    }
    private func showPreferenceVC(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let healthInfoVC = storyboard.instantiateViewController(identifier: "PreferenceVC") as? PreferenceVC
        present(healthInfoVC!,animated: true)
    }
    private func showCuratingDetailVC(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "CuratingDetailVC") as? CuratingDetailVC
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    private func setupSearchBar(){
        searchBar.delegate = self
    }

    
    //뉴수레터
    private func showNewsLetterDetailVC(_ newsLetter_pk : Int) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsLetterDetailVC") as? NewsLetterDetailVC
        vc?.newsLetter_pk = newsLetter_pk
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    //태그
    private func showNewsLetterCategoryVC(_ title : String, _ data : [SubscribeModel]){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let newsLetterCategoryVC = storyboard.instantiateViewController(identifier: "NewsLetterCategoryVC") as? NewsLetterCategoryVC
        newsLetterCategoryVC?.categoryTitle = title
        newsLetterCategoryVC?.newsArray = data
        self.navigationController?.pushViewController(newsLetterCategoryVC!, animated: true)
    }
    //에피소드
    private func showEpisode(_ urStr : String){
        
        DispatchQueue.main.async {
            guard let url = URL(string: urStr), UIApplication.shared.canOpenURL(url) else { return }
            let svc = SFSafariViewController(url: url)
            svc.configuration.entersReaderIfAvailable = true
            self.present(svc,animated: true,completion: nil)
        }
        
    }
    //API
    private func searchNewsLetter(_ keyword : String){
        let parameters : Parameters = [
            "query":keyword
        ]
        ApiService.shared.searchNewsLetter(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(SearchResponseModel.self, from : data)
                if res.status == "S00" {
                    self.newsletterArray = res.value?.newsletters
                    self.tagArray = res.value?.tags
                    self.episodeArray = res.value?.episodes
                    
                    if self.newsletterArray?.count == 0 {
                        self.newsletterArray?.append(SubscribeModel(newsletter_pk: 0, newsletter_name: "검색결과가 없습니다.", newsletter_image: "", register_url: "", newsletter_explain: "", newsletter_tags: [TagModel](), followers: 0))
                    }
                    
                    if self.tagArray?.count == 0 {
                        self.tagArray?.append(TagModel(tag_pk: 0, tag_name: "검색결과가 없습니다.", tag_image: ""))
                    }
                    if self.episodeArray?.count == 0{
                        self.episodeArray?.append(EpisodeModel(episode_pk: 0, newsletter_pk: 0, episode_title: "검색결과가 없습니다.", episode_date: "", episode_url: ""))
                    }
                    
                    
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                    
                }else{
                    print(res.message)
                }
            }catch {
                print(error)
                print("getNewsLetterByRanking Parsing Error")
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
    
    
}
extension SearchVC : UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "뉴스레터 결과"
        case 1:
            return "태그 결과"
        case 2:
            return "에피소드 결과"
        default:
            return ""
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return newsletterArray?.count ?? 0
        case 1:
            return tagArray?.count ?? 0
        case 2:
            return episodeArray?.count ?? 0
        default:
            break
        }
        return 3
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell {
            cell.selectionStyle = .none
            switch indexPath.section {
            case 0:
                cell.lbTitle.text = newsletterArray?[indexPath.row].newsletter_name
                return cell
            case 1:
                cell.lbTitle.text = tagArray?[indexPath.row].tag_name
                return cell
            case 2:
                cell.lbTitle.text = episodeArray?[indexPath.row].episode_title
                return cell
            default:
                break
            }
        }
        return UITableViewCell()

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            showNewsLetterDetailVC(newsletterArray?[indexPath.row].newsletter_pk ?? 0)
            break
        case 1:
            let item = tagArray?[indexPath.row]
            getNewsLetterByTag(Tag: item?.tag_pk ?? 0,TagName: item?.tag_name ?? "")
            break
        case 2:
            showEpisode(episodeArray?[indexPath.row].episode_url ?? "")
            break
        default:
            break
        }
    }
}
extension SearchVC : UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    }
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        tableView.isHidden = false
    }
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if searchBar.text == ""{
            tableView.isHidden = true
        }
        searchNewsLetter(searchBar.text ?? "")
        
    }
    
}

