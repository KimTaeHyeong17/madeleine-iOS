//
//  CuratingDetailVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/05.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import MSPeekCollectionViewDelegateImplementation
import Alamofire
import TagListView

class CuratingDetailVC: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var lbTitle: UILabel!
    @IBOutlet weak var lbSubTitle: UILabel!
    @IBOutlet weak var lbDescription: UILabel!
    
    var behavior = MSCollectionViewPeekingBehavior()
    var curationInfo : CurationModel?
    var newsLetterPKArray : [Int] = []
    
    @IBOutlet weak var contentTitle1: UILabel!
    @IBOutlet weak var contentDescription1: UILabel!
    @IBOutlet weak var contentImage1: UIImageView!
    @IBOutlet weak var contentName1: UILabel!
    @IBOutlet weak var contentTag1: TagListView!
    @IBOutlet weak var contentImageContainer1: UIView!
    @IBOutlet weak var btnContent1: UIButton!
    
    
    @IBOutlet weak var contentTitle2: UILabel!
    @IBOutlet weak var contentDescription2: UILabel!
    @IBOutlet weak var contentImage2: UIImageView!
    @IBOutlet weak var contentName2: UILabel!
    @IBOutlet weak var contentTag2: TagListView!
    @IBOutlet weak var contentImageContainer2: UIView!
    @IBOutlet weak var btnContent2: UIButton!
    
    
    @IBOutlet weak var contentTitle3: UILabel!
    @IBOutlet weak var contentDescription3: UILabel!
    @IBOutlet weak var contentImage3: UIImageView!
    @IBOutlet weak var contentName3: UILabel!
    @IBOutlet weak var contentTag3: TagListView!
    @IBOutlet weak var contentimageContainer3: UIView!
    @IBOutlet weak var btnContent3: UIButton!
    
    @IBOutlet weak var div1: UIView!
    @IBOutlet weak var div2: UIView!
    @IBOutlet weak var div3: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCurationDetail()
        setupUI()
    }
    private func setupUI(){
        div1.layer.cornerRadius = 5
        div2.layer.cornerRadius = 5
        div3.layer.cornerRadius = 5
        
        
        contentImage1.applyshadowWithCorner(containerView: contentImageContainer1, cornerRadious: 5)
        contentImage2.applyshadowWithCorner(containerView: contentImageContainer2, cornerRadious: 5)
        contentImage3.applyshadowWithCorner(containerView: contentimageContainer3, cornerRadious: 5)
        
        contentTag1.setCustomStyle()
        contentTag2.setCustomStyle()
        contentTag3.setCustomStyle()
        
        btnContent1.layer.cornerRadius = 5
        btnContent2.layer.cornerRadius = 5
        btnContent3.layer.cornerRadius = 5
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
    
    @IBAction func actionContent1(_ sender: Any) {
        showNewsLetterDetailVC(newsLetterPKArray[0])
    }
    @IBAction func actionContent2(_ sender: Any) {
        showNewsLetterDetailVC(newsLetterPKArray[1])
    }
    @IBAction func actionContent3(_ sender: Any) {
        showNewsLetterDetailVC(newsLetterPKArray[2])
    }
    //API
    private func getCurationDetail(){
        let parameters : Parameters = [
            "curation_pk":curationInfo?.page_pk ?? 1
        ]
        ApiService.shared.getCurationDetail(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(CurationDetailResponseModel.self, from : data)
                if res.status == "S00" {
                    self.lbTitle.text = (res.value?.page_title)! + "\n" + (res.value?.page_content)!
                    self.lbSubTitle.text = res.value?.page_intro_title
                    self.lbDescription.text = res.value?.page_intro_content
                    self.imgView.sd_setImage(with: URL(string: res.value?.page_image ?? ""), completed: nil)
                    
                    let item1 = res.value?.curations?[0]
                    self.contentTitle1.text = item1?.curation_title
                    self.contentDescription1.text = item1?.curation_explain
                    self.getNewsLetterDetail(item1?.curation_newsletter_pk ?? -1, 0)
                    
                    let item2 = res.value?.curations?[1]
                    self.contentTitle2.text = item2?.curation_title
                    self.contentDescription2.text = item2?.curation_explain
                    self.getNewsLetterDetail(item2?.curation_newsletter_pk ?? -1, 1)
                    
                    let item3 = res.value?.curations?[2]
                    self.contentTitle3.text = item3?.curation_title
                    self.contentDescription3.text = item3?.curation_explain
                    self.getNewsLetterDetail(item3?.curation_newsletter_pk ?? -1, 2)
                    
                    for pk in res.value!.curations! {
                        self.newsLetterPKArray.append(pk.curation_newsletter_pk ?? -1)
                    }
                    
                }else{
                    print(res.message ?? "")
                }
            }catch {
                print(error)
                print("getNewsLetterByRanking Parsing Error")
            }
        })
    }
    private func getNewsLetterDetail(_ newsLetter_pk : Int,_ index : Int){
        let parameters : Parameters = [
            "newsletter_pk":newsLetter_pk
        ]
        ApiService.shared.getNewsLetterDetail(parameters: parameters, completion: { (data) -> (Void) in
            do {
                let res = try JSONDecoder().decode(NewsLetterDetailModel.self, from : data)
                if res.status == "S00" {
                    switch index {
                    case 0:
                        self.contentImage1.sd_setImage(with: URL(string: res.value?.newsletter_image ?? ""), completed: nil)
                        self.contentName1.text = res.value?.newsletter_name
                        for tag in res.value!.newsletter_tags! {
                            self.contentTag1.addTag(tag.tag_name!)
                            if self.contentTag1.tagViews.count == 3{
                                break
                            }
                        }
                        break
                    case 1:
                        self.contentImage2.sd_setImage(with: URL(string: res.value?.newsletter_image ?? ""), completed: nil)
                        self.contentName2.text = res.value?.newsletter_name
                        for tag in res.value!.newsletter_tags! {
                            self.contentTag2.addTag(tag.tag_name!)
                            if self.contentTag1.tagViews.count == 3{
                                break
                            }
                        }
                        break
                    case 2:
                        self.contentImage3.sd_setImage(with: URL(string: res.value?.newsletter_image ?? ""), completed: nil)
                        self.contentName3.text = res.value?.newsletter_name
                        for tag in res.value!.newsletter_tags! {
                            self.contentTag3.addTag(tag.tag_name!)
                            if self.contentTag1.tagViews.count == 3{
                                break
                            }
                        }
                        break
                        
                    default:
                        break
                    }
                    
                }else{
                    print(res.message ?? "")
                }
            }catch{
                print(error)
            }
        })
    }
    
}
