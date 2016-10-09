//
//  SeaPinkGradient.swift
//  SoundBee
//
//  Created by Wellison Pereira on 10/2/16.
//  Copyright © 2016 Tora Cross. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    
    //Sets the background gradient - Copy this into the VC you want this to run in.
    //let background = CAGradientLayer().SeaPinkGradient()
    //background.frame = self.view.bounds
    //self.view.layer.insertSublayer(background, at: 0)

        func SeaPinkGradient() -> CAGradientLayer {
        let topColor = UIColor(red: (225/255.0), green: (145/255.0), blue: (129/255.0), alpha: 1) //Lighter Color
        let bottomColor = UIColor(red: (225/255.0), green: (115/255.0), blue: (129/255.0), alpha: 1) //Darker Color
        
        let gradientColors: [CGColor] = [topColor.cgColor, bottomColor.cgColor]
        let gradientLocations: [Float] = [0.0, 1.0]
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.colors = gradientColors
        gradientLayer.locations = gradientLocations as [NSNumber]?
        
        return gradientLayer
    }
}
