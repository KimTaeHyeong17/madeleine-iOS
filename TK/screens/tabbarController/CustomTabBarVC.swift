//
//  CustomTabBarVC.swift
//  TK
//
//  Created by TaeHyeong Kim on 2020/07/16.
//  Copyright © 2020 TaeHyeong Kim. All rights reserved.
//

import UIKit

class CustomTabBarVC: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabBarStyle()
        setupViewControllers()

    }
    
    private func setupTabBarStyle(){
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor.lightText], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor : UIColor(named: "color_pink_main")!], for: .selected)
    }
    
    private func setupViewControllers(){
        let homeStoryboard = UIStoryboard(name: "Home", bundle: nil)
        let homeVC = homeStoryboard.instantiateViewController(identifier: "HomeVC")
        let homeVCNav = UINavigationController(rootViewController: homeVC)
        homeVCNav.tabBarItem = UITabBarItem(title: "둘러보기",
                                            image: UIImage(named: "ic_home_unselected"),
                                            selectedImage: UIImage(named: "ic_home_selected"))


        
        //Subscription tab
        let subscrptionStoryboard = UIStoryboard(name: "Subscription", bundle: nil)
        let subscrptionVC = subscrptionStoryboard.instantiateViewController(identifier: "SubscriptionVC")
        let subscriptionVCNav = UINavigationController(rootViewController: subscrptionVC)
        subscriptionVCNav.tabBarItem = UITabBarItem(title: "구독",
                                                image: UIImage(named: "ic_subscription_unselected") ,
                                                selectedImage: UIImage(named: "ic_subscription_selected"))
        //Search tab
        let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let searchVC = searchStoryboard.instantiateViewController(identifier: "SearchVC")
        let searchVCNav = UINavigationController(rootViewController: searchVC)
        searchVCNav.tabBarItem = UITabBarItem(title: "검색",
                                           image: UIImage(named: "ic_search_unselected"),
                                           selectedImage: UIImage(named: "ic_search_selected"))
        //my page tab
        let myPageStoryboard = UIStoryboard(name: "MyPage", bundle: nil)
        let myPageVC = myPageStoryboard.instantiateViewController(identifier: "MyPageVC")
        let myPageVCNav = UINavigationController(rootViewController: myPageVC)
        myPageVCNav.tabBarItem = UITabBarItem(title: "마이페이지",
                                           image: UIImage(named: "ic_mypage_unselected"),
                                           selectedImage: UIImage(named: "ic_mypage_selected"))
        
        let tabBarList = [homeVCNav, subscriptionVCNav , searchVCNav ,myPageVCNav]
        
        viewControllers = tabBarList
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
