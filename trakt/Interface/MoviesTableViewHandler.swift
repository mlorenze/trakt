//
//  MoviesTableViewHandler.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/21/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

protocol MoviesPaginationDelegate {
    func changeToNextPage(completion:  @escaping () -> Void)
    func changeToPreviousPage(completion:  @escaping () -> Void)
}

enum PagingAction {
    case previous, next, actual
}

class MoviesTableViewHandler: NSObject, UITableViewDelegate, UITableViewDataSource {

    private var tableView: UITableView
    private var movies: [Movie]
    private var paginationDelegate: MoviesPaginationDelegate!
    
    private var actualPage: Int = 1
    private var isPaging: Bool = false
    
    init(_ tableView: UITableView, paginationDelegate: MoviesPaginationDelegate) {
        self.movies = [Movie]()
        self.tableView = tableView
        self.paginationDelegate = paginationDelegate
        super.init()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.register(GenericTableViewCell.nib, forCellReuseIdentifier: GenericTableViewCell.reuseIdentifier)
    }
    
    func setMovies(_ movies: [Movie], after pagingAction: PagingAction){
        switch pagingAction {
        case .actual:
            self.movies = movies
        case .previous:
            self.movies.removeLast(UISettings.maxCells)
            self.movies.insert(contentsOf: movies, at: 0)
        case .next:
            if self.actualPage > 1 {
                self.movies.removeFirst(UISettings.maxCells)
            }
            self.movies.append(contentsOf: movies)
        }
    }
    
    func hasMovies() -> Bool {
        return self.movies.count > 0
    }
    
    func reloadData() {
        self.tableView.reloadData()
    }
    
    func getActualPage() -> Int {
        return self.actualPage
    }
    
    func updateActualPage(action: PagingAction) {
        switch action {
        case .actual:
            break
        case .previous:
            self.actualPage -= 1
        case .next:
            self.actualPage += 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: GenericTableViewCell.reuseIdentifier, for: indexPath) as! GenericTableViewCell
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: UIScreen.main.bounds.width)
        
        let movie = self.movies[indexPath.row]
        
        let movieCardView = MovieCardView.create(rank: movie.rank, title: movie.title, year: movie.year, overview: movie.overview, posters: movie.posters)
        
        cell.addCardView(cardView: movieCardView)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}

extension MoviesTableViewHandler {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if !self.hasMovies() {
            return
        }
        
        if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.frame.size.height)) {
            if self.canExecutePaging(action: .next) {
                self.paginationDelegate.changeToNextPage(completion: {
                    self.scrollToFirstRow()
                    self.tableView.isScrollEnabled = true
                })
            }
        }
        
        if (scrollView.contentOffset.y <= 0) && self.actualPage > 1 {
            if self.canExecutePaging(action: .previous) {
                self.paginationDelegate.changeToPreviousPage(completion: {
                    self.scrollToLastRow()
                    self.tableView.isScrollEnabled = true
                })
            }
        }
    }
    
    private func canExecutePaging(action: PagingAction) -> Bool {
        if self.isPaging {
            return false
        }
        self.isPaging = true
        self.tableView.isScrollEnabled = false
        self.updateActualPage(action: action)
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isPaging = false
    }
    
    private func scrollToFirstRow() {
        let indexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
    }
    
    private func scrollToLastRow() {
        let indexPath = IndexPath(row: UISettings.maxCells - 1, section: 0)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }

}
