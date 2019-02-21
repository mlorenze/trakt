//
//  MoviesTableViewHandler.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/21/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

protocol MoviesPaginationDelegate {
    func scrollTableViewReachedTop()
    func scrollTableViewReachedEnd()
}

class MoviesTableViewHandler: NSObject, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView
    private var movies: [Movie]
    private var paginationDelegate: MoviesPaginationDelegate!
    
    
    init(_ tableView: UITableView, paginationDelegate: MoviesPaginationDelegate) {
        self.movies = [Movie]()
        self.tableView = tableView
        self.paginationDelegate = paginationDelegate
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(GenericTableViewCell.nib, forCellReuseIdentifier: GenericTableViewCell.reuseIdentifier)
    }
    
    func setMovies(_ movies: [Movie]){
        self.movies = movies
    }
    
    func hasMovies() -> Bool {
        return self.movies.count > 0
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
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
        return UISettings.cellHeight.cgFloat
    }

}

extension MoviesTableViewHandler {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.hasMovies() {
            return
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            print(" you reached end of the table")
//            if !self.isFetching {
//                self.tableView.isScrollEnabled = false
//                self.actualPage += 1
//                self.fetchItems(completion: {
//                    self.scrollToFirstRow()
//                    self.isFetching = false
//                    self.tableView.isScrollEnabled = true
//                })
//            }
        }
        
//        if (scrollView.contentOffset.y <= 0) && self.actualPage > 1 {
//            print(" you reached top of the table")
//            if !self.isFetching {
//                self.tableView.isScrollEnabled = false
//                self.actualPage -= 1
//                self.fetchItems(completion: {
//                    self.scrollToLastRow()
//                    self.isFetching = false
//                    self.tableView.isScrollEnabled = true
//                })
//            }
//        }
        
        if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y < (scrollView.contentSize.height - scrollView.frame.size.height)){
            //not top and not bottom
        }
        
    }
    
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func scrollToLastRow() {
        let indexPath = IndexPath(row: 9, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}
