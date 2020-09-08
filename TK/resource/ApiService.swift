//
//  ApiService.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/15.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire
import RxAlamofire

struct StringResponse : Decodable {
    let status : String?
    let message : String?
    let value : String?
}


class ApiService {
    static let shared = ApiService()
    class var baseURL : String {
        return ""
    }
    static var sessionManager: Session = {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = [:]
        configuration.httpAdditionalHeaders?["Accept"] = "application/json"
        configuration.httpAdditionalHeaders?["referer"] = "https://ttakeum.shop"
        return Alamofire.Session(configuration: configuration)
    }()
    
    
    func login(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/login/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
            }
        }
    }
    func sendValidationMail(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/mail/send/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
            }
        }
    }
    func confirmEmail(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/mail/confirm/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters, encoding: URLEncoding.default).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
            }
        }
    }
    func signUp(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/create/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getAllTags(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/newsletters/tags/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func setUserTags(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/register_tags/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getUserInfo(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/user/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getSubscribeInfo(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/subscribes/get/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getRecommendNewsLetter(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/tag_recommend/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getNewsLetterDetail(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/newsletters/get/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getNewsLetterByTag(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/newsletters/have_tag/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getNewsLetterByRanking(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/newsletters/famous/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func subscribeNewsLetter(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/subscribes/post/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func cancelSubscription(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/accounts/subscribes/delete/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getCurationInfo(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/curation/all/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getCurationDetail(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
        let url = "/curation/get/"
        let parameters : Parameters = parameters
        ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
            switch response.result{
            case .success(_):
                completion(response.data!)
                break
            case .failure(let error):
                print(response.response ?? "error")
                print(error.errorDescription ?? "error")
                break
            }
        }
    }
    func getNewsLetterEpisode(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
         let url = "/newsletters/episode/get/"
         let parameters : Parameters = parameters
         ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
             switch response.result{
             case .success(_):
                 completion(response.data!)
                 break
             case .failure(let error):
                 print(response.response ?? "error")
                 print(error.errorDescription ?? "error")
                 break
             }
         }
     }
    func searchNewsLetter(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
         let url = "/newsletters/search/"
         let parameters : Parameters = parameters
         ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
             switch response.result{
             case .success(_):
                 completion(response.data!)
                 break
             case .failure(let error):
                 print(response.response ?? "error")
                 print(error.errorDescription ?? "error")
                 break
             }
         }
     }
    func registorNewsLetter(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
         let url = "/newsletters/post/"
         let parameters : Parameters = parameters
         ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
             switch response.result{
             case .success(_):
                 completion(response.data!)
                 break
             case .failure(let error):
                 print(response.response ?? "error")
                 print(error.errorDescription ?? "error")
                 break
             }
         }
     }
    func findID(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
         let url = "/accounts/find_username/"
         let parameters : Parameters = parameters
         ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
             switch response.result{
             case .success(_):
                 completion(response.data!)
                 break
             case .failure(let error):
                 print(response.response ?? "error")
                 print(error.errorDescription ?? "error")
                 break
             }
         }
     }
    func changePassword(parameters : Parameters, completion : @escaping(_ result : Data) -> (Void)){
         let url = "/accounts/change_password/"
         let parameters : Parameters = parameters
         ApiService.sessionManager.request(ApiService.baseURL + url, method: .post, parameters:  parameters).responseJSON { (response) in
             switch response.result{
             case .success(_):
                 completion(response.data!)
                 break
             case .failure(let error):
                 print(response.response ?? "error")
                 print(error.errorDescription ?? "error")
                 break
             }
         }
     }

    
    
    //
    //    func getNewsFeed(){
    //        let parameters : Parameters = [:]
    //        ApiService.shared.getNewsFeed(parameters: parameters, completion: { (data) -> (Void) in
    //            do{
    //                let res = try JSONDecoder().decode(NewsFeedResponseModel.self,from: data)
    //                if res.status == "S00"{
    //                    self.newsFeedArray = res.value
    //                    self.tableView.reloadData()
    //                }else{
    //                    self.view.makeToast(res.message, duration: 3.0, position: .bottom)
    //                }
    //            }catch {
    //                print("error")
    //            }
    //        })
    //    }
    
    
    
    
}
