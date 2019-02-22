//
//  SearchViewController.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/9/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var moviesTableViewHandler: MoviesTableViewHandler!
    
    private let traktInteractor: TraktInteractor! = TraktInteractorImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Search"

        self.moviesTableViewHandler = MoviesTableViewHandler(self.tableView, paginationDelegate: self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}

extension SearchViewController: MoviesPaginationDelegate {
    func changeToNextPage(completion: @escaping () -> Void) {
        
    }
    
    func changeToPreviousPage(completion: @escaping () -> Void) {
        
    }

}
