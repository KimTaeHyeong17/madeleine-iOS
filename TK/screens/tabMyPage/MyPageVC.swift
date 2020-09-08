//
//  MyPageVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import Carte
import Alamofire
import SafariServices
class MyPageVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var settings : [String] = [
        "버전",
        "오픈소스 고지항목",
        "개인정보 처리 방침",
        "문의사항",
        "",
        "뉴스레터 등록하기",
        "",
        "관심태그 수정",
        "",
        "로그아웃",
        
    ]
    var tagArray : [TagModel] = []
    var selectedTagArray : [Int] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        getAllTags()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    private func setupUI(){
        self.navigationController?.navigationBar.isHidden = true
    }
    private func setupTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
    private func showOpenSource(){
        let carteViewController = CarteViewController()
        //        present(carteViewController,animated: true)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(carteViewController, animated: true)
    }
    private func logout(){
        DispatchQueue.main.async {
            self.alert(title: "로그아웃", message: "로그아웃 하시겠습니까?", okTitle: "확인", okHandler: { (action) in
                //로그아웃
                let storyboard = UIStoryboard(name: "Login", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "LoginVC")
                (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
            }, cancelTitle: "취소", cancelHandler: { (action) in
                //취소
            }, completion: nil)
        }
    }
    private func showPreferenceVC(){
        let storyboard = UIStoryboard(name: "Home", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "PreferenceVC") as? PreferenceVC
        vc?.tagArray = tagArray
        vc?.selectedTag = selectedTagArray
        vc?.buttonTitle = "관심태그 수정완료"
        present(vc!,animated: true)
    }
    private func pushRegisterNewsLetter(){
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "RegisterNewsLetterVC") as? RegisterNewsLetterVC
        vc?.modalPresentationStyle = .fullScreen
        present(vc!,animated: true)
    }
    
    //API
    private func getUserAndShowPreference(){
        let parameters : Parameters = [
            "username" : UserDefaults.standard.string(forKey: "username") ?? ""
        ]
        ApiService.shared.getUserInfo(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(UserInfoResponse.self, from : data)
                if res.status == "S00" {
                    self.selectedTagArray.removeAll()
                    for tag in res.value!.like_tags! {
                        self.selectedTagArray.append(tag.tag_pk ?? -1)
                    }
                    self.showPreferenceVC()
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getUserInfo Parsing Error")
            }
        })
    }
    private func getAllTags(){
        let parameters : Parameters = [:]
        ApiService.shared.getAllTags(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(TagModelResponse.self, from : data)
                if res.status == "S00" {
                    self.tagArray = res.value ?? [TagModel]()
                }else{
                    print(res.message ?? "")
                }
            }catch{
                print(data.description)
                print("error")
            }
        })
    }
    
    
    
}
extension MyPageVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if settings[indexPath.row] == "" {
            return 30
        }
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell") as? SettingCell {
            cell.selectionStyle = .none
            cell.lbTitle.text = settings[indexPath.row]
            if settings[indexPath.row] == "" {
                cell.contentView.backgroundColor = UIColor(named: "color_blank")
            }
            return cell
            
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = settings[indexPath.row]
        
        switch title{
        case "":
            print(settings[indexPath.row])
        case "정보":
            print(settings[indexPath.row])
            
        case "버전":
            print(settings[indexPath.row])
            DispatchQueue.main.async {
                Utils.showAlertMessage(vc: self, titleStr: "버전", messageStr:  Utils.version())
            }
        case "오픈소스 고지항목":
            print(settings[indexPath.row])
            showOpenSource()
        case "문의사항":
            DispatchQueue.main.async {
                Utils.showAlertMessage(vc: self, titleStr: "문의사항", messageStr: "각종 문의사항은 uuzaza@naver.com 로 연락 바랍니다.")
            }
        case "개인정보 처리 방침":
            DispatchQueue.main.async {
                guard let url = URL(string: "https://ttakeum.shop/privacy/"), UIApplication.shared.canOpenURL(url) else { return }
                let svc = SFSafariViewController(url: url)
                svc.configuration.entersReaderIfAvailable = true
                self.present(svc,animated: true,completion: nil)
            }
            
        case "로그아웃":
            print(settings[indexPath.row])
            logout()
            
        case "뉴스레터 등록하기":
            print(settings[indexPath.row])
            pushRegisterNewsLetter()
        case "관심태그 수정":
            getUserAndShowPreference()
        default:
            break
        }
    }
    
    
}
