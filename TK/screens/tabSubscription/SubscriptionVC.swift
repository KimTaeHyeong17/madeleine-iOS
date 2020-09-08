//
//  SubscriptionVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/03.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import TagListView
import Alamofire
import CRRefresh

class SubscriptionVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyIndicatorView: UIView!
    
    var subArray : [SubscribeModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        getSubscribeInfo()
    }
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
        let SubscriptionCell = UINib(nibName: "SubscriptionCell", bundle: nil)
        self.tableView.register(SubscriptionCell, forCellReuseIdentifier: "SubscriptionCell")
        
        tableView.cr.addHeadRefresh(animator: NormalHeaderAnimator()) { [weak self] in
            /// start refresh
            /// Do anything you want...
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                self?.getSubscribeInfo()
                
            })
        }
    }
    private func showNewsLetterDetailVC(_ newsLetter_pk : Int, _ register_url : String) {
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "NewsLetterDetailVC") as? NewsLetterDetailVC
        vc?.newsLetter_pk = newsLetter_pk
        vc?.subscribe_url = register_url
        self.navigationController?.pushViewController(vc!, animated: true)
    }
    
    //API
    private func getSubscribeInfo(){
        let parameters : Parameters = [
            "username" : UserDefaults.standard.string(forKey: "username") ?? ""
        ]
        ApiService.shared.getSubscribeInfo(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(SubscribeResponseModel.self, from : data)
                if res.status == "S00" {
                    self.subArray = res.value
                    if self.subArray.count == 0{
                        self.emptyIndicatorView.isHidden = false
                    }else{
                        self.emptyIndicatorView.isHidden = true
                    }
                    self.tableView.reloadData()
                    self.tableView.cr.endHeaderRefresh()
                }else{
                    print(res.message)
                }
            }catch {
                print(error)
                print("getSubscribeInfo Parsing Error")
            }
        })
    }
    private func cancelSubscription(_ newsLetter_pk : Int){
        let string = "{ \"value\" : [\(newsLetter_pk)]}"
        let parameters : Parameters = [
            "username" : UserDefaults.standard.string(forKey: "username") ?? "",
            "newsletter_pk" : string
        ]
        ApiService.shared.cancelSubscription(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(StringResponse.self, from : data)
                if res.status == "S00" {
                    self.getSubscribeInfo()
                }else{
                    self.alert(title: res.message ?? "")
                }
            }catch {
                print(error)
                print("getSubscribeInfo Parsing Error")
            }
        })
    }
    
}
extension SubscriptionVC : UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return subArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SubscriptionCell") as? SubscriptionCell {
            
            let item = subArray[indexPath.row]
            
            cell.selectionStyle = .none
            cell.clipsToBounds = false
            cell.imgView?.applyshadowWithCorner(containerView: cell.imageContainerView, cornerRadious: 5)
            
            cell.imgView?.layer.cornerRadius = 10
            cell.imgView?.sd_setImage(with: URL(string: item.newsletter_image ?? ""), completed: nil)
            
            cell.lbTitle.text = item.newsletter_name
            cell.tagListView.removeAllTags()
            for tag in item.newsletter_tags! {
                cell.tagListView.addTag(tag.tag_name ?? "")
                if cell.tagListView.tagViews.count == 3{
                    break
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = subArray[indexPath.row]
        showNewsLetterDetailVC(item.newsletter_pk ?? -1, item.register_url ?? "")
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let filterAction = UIContextualAction(style: .normal, title: "구독취소") { (action, view, bool) in
            self.alert(title: "구독취소", message: "구독취소하시겠습니까?", okTitle: "확인", okHandler: { (action) in
                self.cancelSubscription(self.subArray[indexPath.row].newsletter_pk ?? -1)
            }, cancelTitle: "아니오", cancelHandler: { (aciont) in
                self.dismiss(animated: true, completion: nil)
            }, completion: nil)
        }
        filterAction.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [filterAction])
    }
}
