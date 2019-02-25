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

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var isSearching: Bool = false
    
    private var query: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"
        
        self.searchBar.delegate = self

        self.moviesTableViewHandler = MoviesTableViewHandler(self.tableView, paginationDelegate: self, type: .searched)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

    private func searchMovies(pagingAction: PagingAction, completion:  @escaping (_ fetchingMessage: String) -> Void) {
        SVProgressHUD.show()
        self.isSearching = true
        print("FETCH MOVIES: is fetching page \(self.moviesTableViewHandler.getActualPage())")
        
        self.traktInteractor.searchMovies(query: self.query, page: self.moviesTableViewHandler.getActualPage()) { (movies, error) in
            if error != nil {
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
                completion(" FETCH \(movies?.count ?? 0) MOVIES: finished fetching (successfuly)")
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
            self.searchMovies(pagingAction: .actual) { (fetchingMessage) in
                print(fetchingMessage)
                self.isSearching = false
            }
        }
    }
}

extension SearchViewController: MoviesPaginationDelegate {
    func changeToNextPage(completion: @escaping () -> Void) {
        self.executeMoviesSearching(pagingAction: .next, completion: completion)
    }
    
    func changeToPreviousPage(completion: @escaping () -> Void) {
        self.executeMoviesSearching(pagingAction: .previous, completion: completion)
    }

    private func executeMoviesSearching(pagingAction: PagingAction, completion:  @escaping () -> Void) {
        if !self.isSearching{
            self.searchMovies(pagingAction: pagingAction, completion: { searchingMessage in
                print(searchingMessage)
                self.isSearching = false
                completion()
            })
        }
    }
}
