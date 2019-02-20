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

    static func create(title: String, year: Int, overview: String, imagesPath: [String]) -> MovieCardView {
        
        let view = nib.instantiate(withOwner: nil, options: nil).first as! MovieCardView
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.layer.masksToBounds = true
        
        view.titleLabel.text = title
        view.yearLabel.text = year.string
        view.overviewTextView.text = overview
        
        do {
            if imagesPath.count > 0 {
                let imageURL = String(format: "%@%@", TmbdClient.tmbdImagesUrl.rawValue , imagesPath[0] )
                let url = URL(string: imageURL)
                let data = try Data(contentsOf: url!)
                view.pictureImageView.image = UIImage(data: data)
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
