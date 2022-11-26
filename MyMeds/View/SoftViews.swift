//
//  SoftViews.swift
//  MyMeds
//
//  Created by Aluno on 29/10/22.
//

import Foundation
import UIKit

class SoftView: UIView {
    
    public var bevel = 3
    
    public func makeSoft(cornerRadius: CGFloat = 20.0, color: UIColor) {
        
        let colorLight = color
        let lightShadow = UIColor.black
        
        self.layer.shadowOffset = CGSize(width: bevel, height: bevel)

        let shadowLayer = CAShapeLayer()
        
        self.layer.cornerRadius = cornerRadius
        self.layer.cornerCurve = .continuous
        shadowLayer.cornerRadius = cornerRadius
        shadowLayer.cornerCurve = .continuous

        self.layer.shadowRadius = 5
        shadowLayer.shadowRadius = 5

        self.layer.shadowOpacity = 0.3
        shadowLayer.shadowOpacity = 0.3

        shadowLayer.frame = bounds
        self.layer.backgroundColor = colorLight.cgColor
        shadowLayer.backgroundColor = colorLight.cgColor

    }
}
