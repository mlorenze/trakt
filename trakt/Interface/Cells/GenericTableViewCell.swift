//
//  MovieTableViewCell.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

class GenericTableViewCell: UITableViewCell {
    
    static let reuseIdentifier = "GenericTableViewCell"
    static let nib = UINib(nibName: "GenericTableViewCell", bundle: nil)
    
    @IBOutlet fileprivate var containerView: ShadowView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func addCardView(cardView: UIView) {
        cardView.frame = self.containerView.bounds
        
        if containerView.subviews.count > 0 {
            containerView.removeSubviews()
        }
        containerView.addSubview(cardView)
        
        selectionStyle = UITableViewCell.SelectionStyle.none
    }

}
