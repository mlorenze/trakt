//
//  ShadowView.swift
//  trakt
//
//  Created by Manuel Lorenze Alagna on 2/19/19.
//  Copyright © 2019 Manuel Lorenze Alagna. All rights reserved.
//

import UIKit

class ShadowView: UIView {
    
    struct setup {
        static let color: CGColor = UIColor.black.cgColor
        static let alpha: Float = 0.20
        static let x: CGFloat = 0
        static let y: CGFloat = 0
        static let blur: CGFloat = 15
        static let spread: CGFloat = 0
    }
    
    override var bounds: CGRect {
        didSet {
            setupShadow()
            self.backgroundColor = UIColor.clear
        }
    }
    
    private func setupShadow() {
        self.layer.masksToBounds = false
        
        self.layer.shadowColor = ShadowView.setup.color
        self.layer.shadowOpacity = ShadowView.setup.alpha
        self.layer.shadowOffset = CGSize(width: ShadowView.setup.x, height: ShadowView.setup.y)
        self.layer.shadowRadius = ShadowView.setup.blur / 2.0
        
        if (ShadowView.setup.spread == 0) {
            self.layer.shadowPath = nil
        } else {
            let dx = -ShadowView.setup.spread
            let rect = self.layer.bounds.insetBy(dx: dx, dy: dx)
            self.layer.shadowPath = UIBezierPath(roundedRect: rect,
                                                 byRoundingCorners: .allCorners,
                                                 cornerRadii: CGSize(width: 8, height: 8)).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
    }
}
