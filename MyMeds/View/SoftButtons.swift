//
//  SoftButtons.swift
//  MyMeds
//
//  Created by Aluno on 29/10/22.
//

import Foundation
import UIKit

class SoftButton: UIButton {
    
    public var bevel = 3
    
    override open var isHighlighted: Bool {
        didSet { isHighlighted ? pressed() : released() }
    }
    
    override open var isEnabled: Bool {
        didSet{ isHighlighted ? released() : pressed() }
    }
    
    func pressed() {
        self.layer.shadowOffset = CGSize(width: -bevel, height: -bevel)        
    }
    
    func released() {
        self.layer.shadowOffset = CGSize(width: bevel, height: bevel)
    }
    
    public func makeNeuromorphic(cornerRadius: CGFloat = 20.0, color: UIColor) {
        
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
