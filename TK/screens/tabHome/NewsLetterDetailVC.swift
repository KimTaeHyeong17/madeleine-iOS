//
//  NewsLetterDetailVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/05.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import TagListView
import Alamofire
import SafariServices


class NewsLetterDetailVC: UIViewController {
    
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleImage: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    
    @IBOutlet weak var tvDescription: UILabel!
    @IBOutlet weak var btnSubscribe: UIButton!
    
    @IBOutlet weak var imageContainerView: UIView!
    @IBOutlet weak var lbFolloweres: UILabel!
    
    @IBOutlet weak var bottomDividorView: UIView!
    @IBOutlet weak var noEpisodeView: UIView!
    var newsLetter_pk : Int = 0
    var subscribe_url : String = ""
    var episodeArray : [EpisodeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        getNewsLetterDetail()
        getNewsLetterEpisode()
        
    }
    private func setupUI(){
        titleImage.applyshadowWithCorner(containerView: imageContainerView, cornerRadious: 5)
        
        tagListView.addTags(["예시1","예시2","예시3","예시4","예시5"])
        tagListView.setCustomStyle()
        btnSubscribe.layer.cornerRadius = 5
        
        
        //        titleImage.layer.borderWidth = 5
        //        titleImage.layer.cornerRadius = 5
        //        titleImage.layer.borderColor = UIColor(named: "color_pink_main")?.cgColor
    }
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    //API
    private func getNewsLetterDetail(){
        let parameters : Parameters = [
            "newsletter_pk":newsLetter_pk
        ]
        ApiService.shared.getNewsLetterDetail(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(NewsLetterDetailModel.self, from : data)
                if res.status == "S00" {
                    self.titleImage.sd_setImage(with: URL(string: res.value?.newsletter_image ?? ""), completed: nil)
                    self.lbTitle.text = res.value?.newsletter_name
                    self.lbFolloweres.text = "\(res.value?.followers ?? 0)"
                    
                    if res.value?.newsletter_explain == "" {
                        self.tvDescription.text = "설명없음"
                    }else{
                        self.tvDescription.text = res.value?.newsletter_explain
                    }
                    self.subscribe_url = res.value?.register_url ?? ""
                    self.tagListView.removeAllTags()
                    for tag in res.value!.newsletter_tags! {
                        self.tagListView.addTag(tag.tag_name ?? "")
                        if self.tagListView.tagViews.count == 2 {break}
                    }
                    
                }else{
                    print(res.message ?? "")
                }
            }catch{
                print(error)
            }
        })
    }
    private func subscribeNewsLetter(){
        let str : String = "{\"value\" : [\(newsLetter_pk)] }"
        let parameters : Parameters = [
            "newsletter_pk" : str,
            "username" : UserDefaults.standard.string(forKey: "username") ?? ""
        ]
        ApiService.shared.subscribeNewsLetter(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(SubscribeResponseModel.self, from : data)
                if res.status == "S00" {
                    self.alert(title: "구독함에 추가했습니다.")
                }else{
                    self.alert(title: res.message)
                }
            }catch{
                print("subscribeNewsLetter parsing error")
                print(error)
            }
        })
    }
    private func getNewsLetterEpisode(){
        let parameters : Parameters = [
            "newsletter_pk" : newsLetter_pk
        ]
        ApiService.shared.getNewsLetterEpisode(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(EpisodeResponseModel.self, from : data)
                if res.status == "S00" {
                    self.episodeArray = res.value ?? [EpisodeModel]()
                    if self.episodeArray.count == 0 {
                        self.noEpisodeView.isHidden = false
                        self.bottomDividorView.isHidden = true
                    }else {
                        self.noEpisodeView.isHidden = true
                        self.bottomDividorView.isHidden = false
                    }
                    self.tableView.reloadData()
                }else{
                    self.alert(title: res.message ?? "")
                }
            }catch{
                print("subscribeNewsLetter parsing error")
                print(error)
            }
        })
    }
    
    //ACTIONS
    @IBAction func actionBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func actionSubscribe(_ sender: Any) {
        let trimmedString = subscribe_url.trimmingCharacters(in: .whitespaces)
        if trimmedString == "" {
            Utils.showAlertMessage(vc: self, titleStr: "오류", messageStr: "구독 페이지가 존재하지 않습니다.")
        }else{
            let url = URL(string: trimmedString) ?? URL(string:"https://www.naver.com")!
            let svc = SFSafariViewController(url: url)
            svc.delegate = self
            present(svc, animated: true, completion: nil)
        }
    }
    
}
extension NewsLetterDetailVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodeArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "NewsLetterHistoryListCell") as? NewsLetterHistoryListCell {
            let item = episodeArray[indexPath.row]
            cell.selectionStyle = .none
            cell.lbTitle.text = "#\(indexPath.row) \(item.episode_title ?? "")"
            cell.lbDate.text = item.episode_date
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let url = URL(string: episodeArray[indexPath.row].episode_url ?? ""), UIApplication.shared.canOpenURL(url) else { return }
        let svc = SFSafariViewController(url: url)
        svc.configuration.entersReaderIfAvailable = true
        present(svc,animated: true,completion: nil)
    }
}
extension NewsLetterDetailVC : SFSafariViewControllerDelegate {
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        self.alert(title: "구독여부", message: "구독하셨나요?", okTitle: "네", okHandler: { (action) in
            //action
            self.subscribeNewsLetter()
        }, cancelTitle: "아니오", cancelHandler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }, completion: nil)
    }
}
