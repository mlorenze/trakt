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
import SVProgressHUD

enum FetchingPageAction {
    case previous, next, actual
}

class HomeViewController: UIViewController {

    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isFetching: Bool = false
    
    
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
                self.fetchItems(fetchingAction: .actual, completion: {
                    self.isFetching = false
                })
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }  else {
            self.fetchItems(fetchingAction: .actual, completion: {
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
//        self.refreshButton.isUserInteractionEnabled = false
//        self.fetchItems {
//            self.refreshButton.isUserInteractionEnabled = true
//        }
    }
    
    private func fetchItems(fetchingAction: FetchingPageAction, completion:  @escaping () -> Void) {
        SVProgressHUD.show()
        self.isFetching = true
        print("FETCH MOVIES: is fetching page \(self.moviesTableViewHandler.getActualPage())")

        self.traktInteractor.getPopularMovies(page: self.moviesTableViewHandler.getActualPage()) { (movies, error) in
            if error != nil {
                self.revokeToken()
                completion()
                print("FETCH MOVIES: finished fetching (with error)")
                SVProgressHUD.dismiss()
                return
            }
            
            self.moviesTableViewHandler.setMovies(movies!, action: fetchingAction)
            
            var tasks:[Task<TaskResult>] = []
            for movie in movies! {
                tasks.append(
                    self.traktInteractor.getMovieImages(movieId: Int(movie.ids["tmdb"] as! Int).string, completion: { (posters, error) in
                        if error != nil {
                            return
                        }
                        movie.posters = posters!
                    })
                )
            }
            Task.whenAll(tasks).continueWith { (_) -> Any? in
                completion()
                self.tableView.reloadData()
                print("FETCH MOVIES: finished fetching (successfuly)")
                SVProgressHUD.dismiss()
                return nil
            }
        }
    }
}

extension HomeViewController: MoviesPaginationDelegate {
    
    func changeToNextPage(completion:  @escaping () -> Void) {
        if !self.isFetching{
            self.moviesTableViewHandler.updateActualPage(action: .next)
            self.fetchItems(fetchingAction: .next, completion: {
                self.isFetching = false
                completion()
            })
        }
    }
    
    func changeToPreviousPage(completion:  @escaping () -> Void) {
        if !self.isFetching{
            self.moviesTableViewHandler.updateActualPage(action: .previous)
            self.fetchItems(fetchingAction: .previous, completion: {
                self.isFetching = false
                completion()
            })
        }
    }
}
