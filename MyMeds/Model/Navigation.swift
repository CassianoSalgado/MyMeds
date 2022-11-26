//
//  Navigation.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 08/11/22.
//

import Foundation
import UIKit

class Navigation {
    static let instance = Navigation()
    
    private init() { }
    
    func goTo(_ whereTo: String) {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let destinationViewController = storyboard.instantiateViewController(identifier: whereTo)

        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        windowScene?.keyWindow?.rootViewController = destinationViewController
        
    }
}
