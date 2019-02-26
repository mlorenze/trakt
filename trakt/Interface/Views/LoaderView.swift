//
//  LoaderView.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/25/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

enum Arrow {
    case up, down
}

class LoaderView: UIView {

    static let nib = UINib(nibName: "LoaderView", bundle: nil)
    
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var title: UILabel!

    static func create(arrow: Arrow, title: String) -> LoaderView {
        let view = nib.instantiate(withOwner: nil, options: nil).first as! LoaderView
        
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.layer.masksToBounds = true
        
        view.backgroundColor = .lightBlueColor
        
        switch arrow {
        case .up:
            view.arrow.image = UIImage(named: "arrowUp")
        case .down:
            view.arrow.image = UIImage(named: "arrowDown")
        }
        
        view.title.text = title
        
        return view
    }

}
