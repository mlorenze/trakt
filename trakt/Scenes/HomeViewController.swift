//
//  HomeViewController.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.loadInitialData()
    }
    
    func loadInitialData() {
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }
        else {
            // fetchMyRepos()
        }
    }
    
//    func loadInitialData() {
//
//        TraktAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
//            (error) -> Void in
//            print("handlin stuff")
//            if error != nil {
//                print(error as Any)
//                // TODO: handle error
//                // Something went wrong, try again
//                TraktAPIManager.sharedInstance.startOAuth2Login()
//            }
//            else {
//                //self.fetchMyRepos()
//            }
//        }
//    }
    
}

