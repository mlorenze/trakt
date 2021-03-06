//
//  MovieCardView.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

class MovieCardView: UIView {

    static let nib = UINib(nibName: "MovieCardView", bundle: nil)

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var pictureImageView: UIImageView!
    @IBOutlet weak var overviewTextView: UITextView!
    
    @IBOutlet weak var pictureHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var overviewHeightConstraint: NSLayoutConstraint!

    static func create(rank: Int, title: String?, year: Int?, overview: String?, posters: [Poster]) -> MovieCardView {
        let view = MovieCardView.commonInit(title: title, year: year, overview: overview, posters: posters)
        view.titleLabel.text = String(format: "%d - %@", rank, title ?? "")
        return view
    }
    
    static func create(title: String?, year: Int?, overview: String?, posters: [Poster]) -> MovieCardView {
        let view = MovieCardView.commonInit(title: title, year: year, overview: overview, posters: posters)
        view.titleLabel.text = title
        return view
    }

    private static func commonInit(title: String?, year: Int?, overview: String?, posters: [Poster]) -> MovieCardView {
        let view = nib.instantiate(withOwner: nil, options: nil).first as! MovieCardView
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.layer.masksToBounds = true
        
        view.yearLabel.text = year?.string
        view.overviewTextView.text = overview
        view.overviewTextView.sizeToFit()
        view.overviewHeightConstraint.constant = view.overviewTextView.contentSize.height
        
        do {
            if posters.count > 0 {
                let poster = posters[0]
                let imageURL = String(format: "%@%@", TmbdApi.tmbdImagesUrl.rawValue , poster.filePath )
                let url = URL(string: imageURL)
                let data = try Data(contentsOf: url!)
                view.pictureImageView.image = UIImage(data: data)
                
                view.pictureHeightConstraint.constant = view.pictureImageView.width / CGFloat(poster.aspectRatio)
                
            }else{
                view.pictureImageView.image = UIImage(named: "icSearch")
            }
        }catch ( _) {
            view.pictureImageView.image = UIImage(named: "icSearch")
        }
        view.pictureImageView.contentMode = .scaleAspectFit
        
        return view
    }
}
