//
//  SearchViewController.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit
import BoltsSwift
import SVProgressHUD

class SearchViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomViewHeightConstraint: NSLayoutConstraint!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isSearching: Bool = false
    private var lastMoviesSearched: [Movie] = []
    
    private var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"
        
        self.searchBar.delegate = self

        self.moviesTableViewHandler = MoviesTableViewHandler(self.tableView, paginationDelegate: self, type: .searched)
        
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
        self.moviesTableViewHandler.setMovies(self.lastMoviesSearched, after: .previous)
        self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: true)
    }
    
    @objc func handleBottomViewTap(_ sender: UITapGestureRecognizer) {
        self.moviesTableViewHandler.setMovies(self.lastMoviesSearched, after: .next)
        self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.lastMoviesSearched = [Movie]()
    }

    private func searchMovies(page: Int, completion:  @escaping (_ movies: [Movie], _ fetchingMessage: String) -> Void) {
        SVProgressHUD.show()
        self.isSearching = true
        print("FETCH MOVIES: is fetching page \(self.moviesTableViewHandler.getActualPage())")
        
        self.traktInteractor.searchMovies(query: self.query, page: page) { (movies, error) in
            if error != nil {
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
                self.moviesTableViewHandler.reloadData()
                completion(movies!, " FETCH \(movies?.count ?? 0) MOVIES: finished fetching (successfuly)")
                SVProgressHUD.dismiss()
                return nil
            }
        }
    }
}

extension SearchViewController: UISearchBarDelegate {

    func searchBar(_ searchBar: UISearchBar, textDidChange textSearched: String) {
        SVProgressHUD.dismiss()
        self.query = textSearched
        self.moviesTableViewHandler.resetActualPage()
        self.moviesTableViewHandler.reloadData()
        if !query.isEmpty {
            self.searchMovies(page: 1) { movies, fetchingMessage  in
                print(fetchingMessage)
                self.lastMoviesSearched = movies
                self.moviesTableViewHandler.setMovies(movies, after: .actual)
                self.isSearching = false
            }
        }
    }
}

extension SearchViewController: MoviesPaginationDelegate {
    func disableLastFetching() {
        if self.topViewHeightConstraint.constant > 0 {
            self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: true)
        }
        if self.bottomViewHeightConstraint.constant > 0 {
            self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: true)
        }
    }
    
    func fetchingForNextPage(nextPage: Int, completion: @escaping () -> Void) {
        self.executeMoviesSearching(page: nextPage, completion: {
            if self.lastMoviesSearched.count > 0 {
                self.updateTapView(heightConstraint: self.bottomViewHeightConstraint, disable: false)
            }
            completion()
        })
    }
    
    func fetchingForPreviousPage(previousPage: Int, completion: @escaping () -> Void) {
        self.executeMoviesSearching(page: previousPage, completion: {
            if self.lastMoviesSearched.count > 0 {
                self.updateTapView(heightConstraint: self.topViewHeightConstraint, disable: false)
            }
            completion()
        })
    }

    private func executeMoviesSearching(page: Int, completion:  @escaping () -> Void) {
        if !self.isSearching{
            self.searchMovies(page: page, completion: { movies, searchingMessage in
                print(searchingMessage)
                self.lastMoviesSearched = movies
                self.isSearching = false
                completion()
            })
        }
    }
}
