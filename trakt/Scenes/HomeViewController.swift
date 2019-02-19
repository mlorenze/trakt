//
//  HomeViewController.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit
import SwiftyUserDefaults

class HomeViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    private var movies: [Movie]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Home"
        self.movies = [Movie]()
        
        tableView.register(GenericTableViewCell.nib, forCellReuseIdentifier: GenericTableViewCell.reuseIdentifier)

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
                self.fetchItems()
            }
        }
        
        if (!TraktAPIManager.sharedInstance.hasOAuthToken()) {
            TraktAPIManager.sharedInstance.startOAuth2Login()

        }  else {
            self.fetchItems()
        }
    }
    
    private func fetchItems() {
        print("Token: " + (TraktAPIManager.sharedInstance.getOAuthToken() ?? "No Token!!!"))
        
        self.traktInteractor.getPopularMovies { (movies, error) in
            
            if error != nil {
                return
            }
            
            self.movies = movies
            
            self.tableView.reloadData()
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
        
        let movieCardView = MovieCardView.create(title: movie.title, year: movie.year)

        cell.addCardView(cardView: movieCardView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
}
