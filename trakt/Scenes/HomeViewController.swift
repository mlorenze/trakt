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
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var movies: [Movie]!
    
    private var isFetching: Bool = false
    private var lastPageFetched: Int = 1
    
    private var noTokenNeeded: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.movies = [Movie]()
        
        tableView.register(GenericTableViewCell.nib, forCellReuseIdentifier: GenericTableViewCell.reuseIdentifier)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if noTokenNeeded {
            loadInitialData()
            return
        }
        
        if (!Defaults.bool(forKey: K.Token.loadingOAuthToken)) {
            loadInitialData()
        }
    }

    private func loadInitialData() {
        
        if noTokenNeeded {
            self.fetchItems {
                self.lastPageFetched += 1
            }
            return
        }
        
        TraktAPIManager.sharedInstance.OAuthTokenCompletionHandler = {
            (error) -> Void in
            print("handlin stuff")
            if error != nil {
                print(error as Any)
                // TODO: handle error
                // Something went wrong, try again
                TraktAPIManager.sharedInstance.startOAuth2Login()
            } else {
                self.fetchItems(completion: { })
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }  else {
            self.fetchItems(completion: { })
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

        self.traktInteractor.getPopularMovies(page: self.lastPageFetched) { (movies, error) in
            
            if error != nil {
                self.revokeToken()
                self.isFetching = false
                print("finished fetching")
                completion()
                return
            }
            self.movies = movies
            
            self.tableView.reloadData()
            completion()
            self.isFetching = false
            
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
                self.isFetching = false
                print("finished fetching")
                return nil
            }
            
        }
        
    }
    
}


//MARK: - Table Delegates
extension HomeViewController : UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.reuseIdentifier, for: indexPath) as! GenericTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
        let movie = self.movies[indexPath.row]
        
        let movieCardView = MovieCardView.create(title: movie.title, year: movie.year, overview: movie.overview, imagesPath: movie.imagesPath)

        cell.addCardView(cardView: movieCardView)

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}

extension HomeViewController {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.movies.count == 0 {
            return
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            print(" you reached end of the table")
            if !self.isFetching {
                self.tableView.isScrollEnabled = false
                self.fetchItems(completion: {
                    self.scrollToFirstRow()
                    self.tableView.isScrollEnabled = true
                    self.lastPageFetched += 1
                })
            }
        }

        if (scrollView.contentOffset.y <= 0) && self.lastPageFetched > 1 {
//            print(" you reached top of the table")
//            if !self.isFetching {
//                self.tableView.isScrollEnabled = false
//
//                self.fetchItems(completion: {
//                    self.scrollToLastRow()
//                    self.tableView.isScrollEnabled = true
//                    self.lastPageFetched -= 1
//                })
//            }
        }
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }

    }
    
    func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    func scrollToLastRow() {
        let indexPath = IndexPath(row: 9, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
}
