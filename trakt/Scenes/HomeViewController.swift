//
//  HomeViewController.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit
import SwiftyUserDefaults
import BoltsSwift

class HomeViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isFetching: Bool = false
    private var actualPage: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        
        self.moviesTableViewHandler = MoviesTableViewHandler(self.tableView, paginationDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if (!Defaults.bool(forKey: K.Token.loadingOAuthToken)) {
            loadInitialData()
        }
    }

    private func loadInitialData() {
        
        TraktAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
            (error) -> Void in
            print("handlin stuff")
            if error != nil {
                print(error as Any)
                // TODO: handle error
                // Something went wrong, try again
                TraktAPIManager.sharedInstance.startOAuth2Login()
            } else {
                self.fetchItems(completion: {
                    self.isFetching = false
                })
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }  else {
            self.fetchItems(completion: {
                self.isFetching = false
            })
        }
    }
    
    private func revokeToken()  {
        
        if let token = TraktAPIManager.sharedInstance.getOAuthToken() {
            self.traktInteractor.revokeToken(token: token) { (ok) in
                TraktAPIManager.sharedInstance.revokeToken()
            }
        }
        
    }
    
    @IBAction func refreshClick(_ sender: Any) {
        self.refreshButton.isUserInteractionEnabled = false
        self.fetchItems {
            self.refreshButton.isUserInteractionEnabled = true
        }
    }
    
    private func fetchItems(completion:  @escaping () -> Void ) {
        self.isFetching = true
        print("is fetching")

        self.traktInteractor.getPopularMovies(page: self.actualPage) { (movies, error) in
            if error != nil {
                self.revokeToken()
                completion()
                print("finished fetching (with error)")
                return
            }
            
            self.moviesTableViewHandler.setMovies(movies!)
            
            var tasks:[Task<TaskResult>] = []
            for movie in movies! {
                tasks.append(
                    self.traktInteractor.getMovieImages(movieId: Int(movie.ids["tmdb"] as! Int).string, completion: { (filePaths, error) in
                        if error != nil {
                            return
                        }
                        movie.imagesPath = filePaths!
                    })
                )
            }
            Task.whenAll(tasks).continueWith { (_) -> Any? in
                self.tableView.reloadData()
                completion()
                print("finished fetching (successfuly)")
                return nil
            }
        }
    }
}

extension HomeViewController: MoviesPaginationDelegate {
    
    func scrollTableViewReachedTop() {
        
    }
    
    func scrollTableViewReachedEnd() {
        
    }
}
