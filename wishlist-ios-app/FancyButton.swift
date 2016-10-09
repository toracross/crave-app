//
//  FancyButton.swift
//  SocialMediaSample
//
//  Created by Wellison Pereira on 9/18/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit

class FancyButton: UIButton {
    
    let SHADOW_GRAY: CGFloat = 120.0 / 255.0

    override func awakeFromNib() {
        super.awakeFromNib()
        
        layer.shadowColor = UIColor(red: SHADOW_GRAY, green: SHADOW_GRAY, blue: SHADOW_GRAY, alpha: SHADOW_GRAY).cgColor
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 5.0
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.cornerRadius = 12.0
        //layer.borderWidth = 1.0
        //layer.borderColor = UIColor.blue.cgColor
    }
}
