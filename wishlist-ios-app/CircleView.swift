//
//  CircleView.swift
//  SocialMediaSample
//
//  Created by Wellison Pereira on 9/18/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit

class CircleView: UIImageView {

    override func layoutSubviews() {
        layer.cornerRadius = self.frame.width / 2
        clipsToBounds = true
    }
}
