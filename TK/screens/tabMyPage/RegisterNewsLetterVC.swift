//
//  RegisterNewsLetterVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/08/27.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit
import Alamofire
class RegisterNewsLetterVC: UIViewController {
    
    var imageSelected : Bool = false
    
    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tfURL: UITextField!
    @IBOutlet weak var tfExplain: UITextView!
    
    
    
    
    @IBOutlet weak var btnPublic: UIButton!
    @IBOutlet weak var btnStartup: UIButton!
    @IBOutlet weak var btnNGO: UIButton!
    @IBOutlet weak var btnEducate: UIButton!
    @IBOutlet weak var btnNews: UIButton!
    @IBOutlet weak var btnIt: UIButton!
    @IBOutlet weak var btnBank: UIButton!
    @IBOutlet weak var btnMoview: UIButton!
    @IBOutlet weak var btnArt: UIButton!
    @IBOutlet weak var btnDesign: UIButton!
    @IBOutlet weak var btnMusic: UIButton!
    @IBOutlet weak var btnTravel: UIButton!
    @IBOutlet weak var btnLifeStyle: UIButton!
    @IBOutlet weak var btnPublish: UIButton!
    @IBOutlet weak var btnFood: UIButton!
    @IBOutlet weak var btnMedia: UIButton!
    @IBOutlet weak var btnBusiness: UIButton!
    @IBOutlet weak var btnEssay: UIButton!
    @IBOutlet weak var btnLaw: UIButton!
    @IBOutlet weak var btnFasion: UIButton!
    @IBOutlet weak var btnEnviorment: UIButton!
    @IBOutlet weak var btnCommunity: UIButton!
    
    @IBOutlet weak var btnRegister: UIButton!
    @IBOutlet weak var imageViewLogo: UIImageView!
    @IBOutlet weak var btnAddPhoto: UIButton!
    
    var selectedTag : [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    private func setupUI(){
        tfExplain.delegate = self
        self.hideKeyboardWhenTappedAround()
        
        btnRegister.layer.cornerRadius = 5
        imageViewLogo.layer.cornerRadius = 5
        
        btnPublic.layer.cornerRadius = 5
        btnStartup.layer.cornerRadius = 5
        btnNGO.layer.cornerRadius = 5
        btnEducate.layer.cornerRadius = 5
        btnNews.layer.cornerRadius = 5
        btnIt.layer.cornerRadius = 5
        btnBank.layer.cornerRadius = 5
        btnMoview.layer.cornerRadius = 5
        btnArt.layer.cornerRadius = 5
        btnDesign.layer.cornerRadius = 5
        btnMusic.layer.cornerRadius = 5
        btnTravel.layer.cornerRadius = 5
        btnLifeStyle.layer.cornerRadius = 5
        btnPublish.layer.cornerRadius = 5
        btnFood.layer.cornerRadius = 5
        btnMedia.layer.cornerRadius = 5
        btnBusiness.layer.cornerRadius = 5
        btnEssay.layer.cornerRadius = 5
        btnLaw.layer.cornerRadius = 5
        btnFasion.layer.cornerRadius = 5
        btnEnviorment.layer.cornerRadius = 5
        btnCommunity.layer.cornerRadius = 5
        
        btnPublic.layer.borderWidth = 1
        btnStartup.layer.borderWidth = 1
        btnNGO.layer.borderWidth = 1
        btnEducate.layer.borderWidth = 1
        btnNews.layer.borderWidth = 1
        btnIt.layer.borderWidth = 1
        btnBank.layer.borderWidth = 1
        btnMoview.layer.borderWidth = 1
        btnArt.layer.borderWidth = 1
        btnDesign.layer.borderWidth = 1
        btnMusic.layer.borderWidth = 1
        btnTravel.layer.borderWidth = 1
        btnLifeStyle.layer.borderWidth = 1
        btnPublish.layer.borderWidth = 1
        btnFood.layer.borderWidth = 1
        btnMedia.layer.borderWidth = 1
        btnBusiness.layer.borderWidth = 1
        btnEssay.layer.borderWidth = 1
        btnLaw.layer.borderWidth = 1
        btnFasion.layer.borderWidth = 1
        btnEnviorment.layer.borderWidth = 1
        btnCommunity.layer.borderWidth = 1
        
        btnPublic.layer.borderColor = UIColor.lightGray.cgColor
        btnStartup.layer.borderColor = UIColor.lightGray.cgColor
        btnNGO.layer.borderColor = UIColor.lightGray.cgColor
        btnEducate.layer.borderColor = UIColor.lightGray.cgColor
        btnNews.layer.borderColor = UIColor.lightGray.cgColor
        btnIt.layer.borderColor = UIColor.lightGray.cgColor
        btnBank.layer.borderColor = UIColor.lightGray.cgColor
        btnMoview.layer.borderColor = UIColor.lightGray.cgColor
        btnArt.layer.borderColor = UIColor.lightGray.cgColor
        btnDesign.layer.borderColor = UIColor.lightGray.cgColor
        btnMusic.layer.borderColor = UIColor.lightGray.cgColor
        btnTravel.layer.borderColor = UIColor.lightGray.cgColor
        btnLifeStyle.layer.borderColor = UIColor.lightGray.cgColor
        btnPublish.layer.borderColor = UIColor.lightGray.cgColor
        btnFood.layer.borderColor = UIColor.lightGray.cgColor
        btnMedia.layer.borderColor = UIColor.lightGray.cgColor
        btnBusiness.layer.borderColor = UIColor.lightGray.cgColor
        btnEssay.layer.borderColor = UIColor.lightGray.cgColor
        btnLaw.layer.borderColor = UIColor.lightGray.cgColor
        btnFasion.layer.borderColor = UIColor.lightGray.cgColor
        btnEnviorment.layer.borderColor = UIColor.lightGray.cgColor
        btnCommunity.layer.borderColor = UIColor.lightGray.cgColor
        
        btnPublic.isSelected = false
        btnStartup.isSelected = false
        btnNGO.isSelected = false
        btnEducate.isSelected = false
        btnNews.isSelected = false
        btnIt.isSelected = false
        btnBank.isSelected = false
        btnMoview.isSelected = false
        btnArt.isSelected = false
        btnDesign.isSelected = false
        btnMusic.isSelected = false
        btnTravel.isSelected = false
        btnLifeStyle.isSelected = false
        btnPublish.isSelected = false
        btnFood.isSelected = false
        btnMedia.isSelected = false
        btnBusiness.isSelected = false
        btnEssay.isSelected = false
        btnLaw.isSelected = false
        btnFasion.isSelected = false
        btnEnviorment.isSelected = false
        btnCommunity.isSelected = false
        
        btnPublic.tag = 1
        btnStartup.tag = 9
        btnNGO.tag = 8
        btnEducate.tag = 2
        btnNews.tag = 10
        btnIt.tag = 17
        btnBank.tag = 3
        btnMoview.tag = 11
        btnArt.tag = 19
        btnDesign.tag = 4
        btnMusic.tag = 12
        btnTravel.tag = 21
        btnLifeStyle.tag = 5
        btnPublish.tag = 13
        btnFood.tag = 16
        btnMedia.tag = 6
        btnBusiness.tag = 18
        btnEssay.tag = 20
        btnLaw.tag = 7
        btnFasion.tag = 15
        btnEnviorment.tag = 22
        btnCommunity.tag = 14
        
    }
    private func selector(_ btn : UIButton) {
        let count = selectedTag.count

        if btn.isSelected == true {
            //de select
            btn.isSelected = false
            btn.backgroundColor = .clear
            if let index = selectedTag.firstIndex(of: btn.tag){
                selectedTag.remove(at: index)
            }
        }else{
            //select
            if count < 3 {
                btn.isSelected = true
                btn.backgroundColor = UIColor(named: "color_pink_main")
                if selectedTag.contains(btn.tag) == false {
                    self.selectedTag.append(btn.tag)
                }
            }
        }
        print(selectedTag)
    }
    
    @IBAction func actionClose(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func actionAddPhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func actionRegistor(_ sender: Any) {
        updateProfileImage(imageViewLogo.image!)
    }
    
    @IBAction func actionPublic(_ sender: Any) {
        selector(btnPublic)
    }
    @IBAction func actionStart(_ sender: Any) {
        selector(btnStartup)
    }
    @IBAction func actionNGO(_ sender: Any) {
        selector(btnNGO)
    }
    @IBAction func actionEdu(_ sender: Any) {
        selector(btnEducate)
    }
    @IBAction func actionNews(_ sender: Any) {
        selector(btnNews)
    }
    @IBAction func actionIt(_ sender: Any) {
        selector(btnIt)
    }
    @IBAction func actionBank(_ sender: Any) {
        selector(btnBank)
    }
    @IBAction func actionMoview(_ sender: Any) {
        selector(btnMoview)
    }
    @IBAction func actionArt(_ sender: Any) {
        selector(btnArt)
    }
    @IBAction func actionDesign(_ sender: Any) {
        selector(btnDesign)
    }
    @IBAction func actionMusic(_ sender: Any) {
        selector(btnMusic)
    }
    @IBAction func actionTravel(_ sender: Any) {
        selector(btnTravel)
    }
    @IBAction func actionLifeStyle(_ sender: Any) {
        selector(btnLifeStyle)
        
    }
    @IBAction func actionPublish(_ sender: Any) {
        selector(btnPublish)
        
    }
    @IBAction func actionFood(_ sender: Any) {
        selector(btnFood)
        
    }
    @IBAction func actionMedia(_ sender: Any) {
        selector(btnMedia)
        
    }
    @IBAction func actionBusniess(_ sender: Any) {
        selector(btnBusiness)
        
    }
    @IBAction func actionEssay(_ sender: Any) {
        selector(btnEssay)
        
    }
    @IBAction func actionLaw(_ sender: Any) {
        selector(btnLaw)
        
    }
    @IBAction func actionFashion(_ sender: Any) {selector(btnFasion)}
    @IBAction func actionEnviorment(_ sender: Any) {selector(btnEnviorment)}
    @IBAction func actionCommunity(_ sender: Any) {selector(btnCommunity)}
    
    
    //API
    private func updateProfileImage(_ image : UIImage){
        if tfTitle.text == "" {
            self.alert(title: "뉴스레터 이름을 입력해 주세요.")
            return
        }
        if tfURL.text == "" {
            self.alert(title: "뉴스레터 구독 URL을 입력해 주세요.")
            return
        }
        if tfExplain.text == "" {
            self.alert(title: "뉴스레터 설명을 입력해 주세요.")
            return
        }
        
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
        
        
        let parameters : Parameters = [
            "newsletter_name": tfTitle.text ?? "",
            "newsletter_explain" : tfExplain.text ?? "",
            "newsletter_tags" : str,
            "register_url" : tfURL.text ?? ""
        ]
        
        let imageData = image.jpegData(compressionQuality: 1)!
        let url = "\(ApiService.baseURL)/newsletters/post/"
        
        upload(image: imageData, to: url, params: parameters)
        
    }//end of function
    func upload(image: Data, to url: String, params: [String: Any]) {
        
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data"
        ]
        AF.upload(multipartFormData: { multiPart in
            for (key, value) in params {
                if let temp = value as? String {
                    multiPart.append(temp.data(using: .utf8)!, withName: key)
                }
                if let temp = value as? Int {
                    multiPart.append("\(temp)".data(using: .utf8)!, withName: key)
                }
                if let temp = value as? NSArray {
                    temp.forEach({ element in
                        let keyObj = key + "[]"
                        if let string = element as? String {
                            multiPart.append(string.data(using: .utf8)!, withName: keyObj)
                        } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multiPart.append(value.data(using: .utf8)!, withName: keyObj)
                        }
                    })
                }
            }
            multiPart.append(image, withName: "newsletter_image", fileName: "\(self.tfTitle.text ?? "")_logo.png", mimeType: "image/jpeg")
        }, to: url
            , headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                print("Upload Progress: \(progress.fractionCompleted)")
            })
            .responseJSON(completionHandler: { data in
                switch data.result{
                case .success(_):
                    do {
                        let res = try JSONDecoder().decode(StringResponse.self, from : data.data!)
                        if res.status == "S00" {
                            DispatchQueue.main.async {
                                self.alert(title: "등록성공", message: "뉴스레터 등록에 성공했습니다.", okTitle: "확인", okHandler: nil, cancelTitle: "확인", cancelHandler: { (action) in
                                    
                                    self.dismiss(animated: true, completion: nil)
                                }, completion: nil)
                            }
                        }else{
                            Utils.showAlertMessage(vc: self, titleStr: "등록오류", messageStr: res.message ?? "")
                        }
                    }catch{
                        
                        print(data.description)
                        print("error")
                    }
                    
                case .failure(let error):
                    
                    print(error.errorDescription ?? "error")
                }
                //Do what ever you want to do with response
            })
    }
    
}
extension RegisterNewsLetterVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        self.imageViewLogo.image = image
        
        self.dismiss(animated: true) {
            //completion code
            self.btnAddPhoto.isHidden = true
            self.imageSelected = true
        }
    }
    
}
extension RegisterNewsLetterVC : UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return textView.text.count + (text.count - range.length) <= 80
    }
}
