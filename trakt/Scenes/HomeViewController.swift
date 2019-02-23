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

class HomeViewController: UIViewController {

    @IBOutlet weak var popularMoviesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isFetching: Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.popularMoviesLabel.text = "Popular Movies"
        
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
                self.fetchMovies(pagingAction: .actual, completion: { fetchingMessage in
                    print(fetchingMessage)
                    self.isFetching = false
                })
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }  else {
            self.fetchMovies(pagingAction: .actual, completion: { fetchingMessage in
                print(fetchingMessage)
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
    
    private func fetchMovies(pagingAction: PagingAction, completion:  @escaping (_ fetchingMessage: String) -> Void) {
        SVProgressHUD.show()
        self.isFetching = true
        print("FETCH MOVIES: is fetching page \(self.moviesTableViewHandler.getActualPage())")

        self.traktInteractor.getPopularMovies(page: self.moviesTableViewHandler.getActualPage()) { (movies, error) in
            if error != nil {
                self.revokeToken()
                completion(" FETCH MOVIES: finished fetching (with error)")
                SVProgressHUD.dismiss()
                return
            }
            
            self.moviesTableViewHandler.setMovies(movies!, after: pagingAction)
            
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
                self.moviesTableViewHandler.reloadData()
                completion(" FETCH MOVIES: finished fetching (successfuly)")
                SVProgressHUD.dismiss()
                return nil
            }
        }
    }
}

extension HomeViewController: MoviesPaginationDelegate {
    
    func changeToNextPage(completion:  @escaping () -> Void) {
        self.executeMoviesFetching(pagingAction: .next, completion: completion)
    }
    
    func changeToPreviousPage(completion:  @escaping () -> Void) {
        self.executeMoviesFetching(pagingAction: .previous, completion: completion)
    }
    
    private func executeMoviesFetching(pagingAction: PagingAction, completion:  @escaping () -> Void) {
        if !self.isFetching{
            self.fetchMovies(pagingAction: pagingAction, completion: { fetchingMessage in
                print(fetchingMessage)
                self.isFetching = false
                completion()
            })
        }
    }
}
