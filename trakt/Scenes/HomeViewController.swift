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

class HomeViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var popularMoviesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isFetching: Bool = false
    private var lastMoviesFetched: [Movie] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.popularMoviesLabel.text = "Popular Movies"
        
        self.moviesTableViewHandler = MoviesTableViewHandler(self.tableView, paginationDelegate: self, type: .populars)
        
        self.updateLoadersUI(view: self.topView)
        self.updateLoadersUI(view: self.bottomView)
        
        self.topViewHeightConstraint.constant = 0
        self.bottomViewHeightConstraint.constant = 0
        
        let topViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleTopViewTap(_:)))
        topViewTap.delegate = self
        self.topView.addGestureRecognizer(topViewTap)

        let bottomViewTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBottomViewTap(_:)))
        bottomViewTap.delegate = self
        self.bottomView.addGestureRecognizer(bottomViewTap)
    }
    
    private func updateLoadersUI(view: UIView){
        let loaderView = LoaderView.create(arrow: view == self.topView ? .up : .down,
                                           title: view == self.topView ? "Previous movies" : "Next movies")
        loaderView.frame = view.bounds
        view.addSubview(loaderView)
    }
    
    private func updateTapView(heightConstraint: NSLayoutConstraint, disable: Bool) {
        self.view.layoutIfNeeded()
        heightConstraint.constant = disable ? 0 : 50
        
        UIView.animate(withDuration: 0.2, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    @objc func handleTopViewTap(_ sender: UITapGestureRecognizer) {
        self.moviesTableViewHandler.setMovies(self.lastMoviesFetched, after: .previous)
        self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: true)
    }
    
    @objc func handleBottomViewTap(_ sender: UITapGestureRecognizer) {
        self.moviesTableViewHandler.setMovies(self.lastMoviesFetched, after: .next)
        self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lastMoviesFetched = [Movie]()
        
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
                TraktAPIManager.sharedInstance.startOAuth2Login()
            } else {
                self.fetchMovies(page: self.moviesTableViewHandler.getActualPage(), completion: { movies, fetchingMessage  in
                    print(fetchingMessage)
                    self.moviesTableViewHandler.setMovies(movies, after: .actual)
                    self.isFetching = false
                })
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()
        } else {
            self.fetchMovies(page: self.moviesTableViewHandler.getActualPage(), completion: { movies, fetchingMessage in
                print(fetchingMessage)
                self.moviesTableViewHandler.setMovies(movies, after: .actual)
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
    
    private func fetchMovies(page: Int, completion:  @escaping (_ movies: [Movie], _ fetchingMessage: String) -> Void) {
        SVProgressHUD.show()
        self.isFetching = true
        print("FETCH MOVIES: is fetching page \(self.moviesTableViewHandler.getActualPage())")

        self.traktInteractor.getPopularMovies(page: page) { (movies, error) in
            if error != nil {
                self.revokeToken()
                completion([Movie](), " FETCH MOVIES: finished fetching (with error)")
                SVProgressHUD.dismiss()
                return
            }
            
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
                completion(movies!, " FETCH MOVIES: finished fetching (successfuly)")
                SVProgressHUD.dismiss()
                return nil
            }
        }
    }
}

extension HomeViewController: MoviesPaginationDelegate {
    
    func disableLastFetching() {
        if self.topViewHeightConstraint.constant > 0 {
            self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: true)
        }
        if self.bottomViewHeightConstraint.constant > 0 {
            self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: true)
        }
    }
    
    func fetchingForNextPage(nextPage: Int, completion:  @escaping () -> Void) {
        self.executeMoviesFetching(page: nextPage, completion: {
            if self.lastMoviesFetched.count > 0 {
                self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: false)
            }
            completion()
        })
    }
    
    func fetchingForPreviousPage(previousPage: Int, completion:  @escaping () -> Void) {
        self.executeMoviesFetching(page: previousPage, completion: {
            if self.lastMoviesFetched.count > 0 {
                self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: false)
            }
            completion()
        })
    }
    
    private func executeMoviesFetching(page: Int, completion:  @escaping () -> Void) {
        if !self.isFetching{
            self.fetchMovies(page: page, completion: { movies, fetchingMessage in
                print(fetchingMessage)
                self.lastMoviesFetched = movies
                self.isFetching = false
                completion()
            })
        }
    }
}
