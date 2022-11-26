//
//  AboutViewController.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 25/11/22.
//

import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var goBack: SoftButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "Versão: \(version)"
        }
        goBack.makeNeuromorphic(cornerRadius: goBack.bounds.height/2,  color: UIColor.white)
        
    }
    @IBAction func goBackToMain(_ sender: SoftButton) {
        Navigation.instance.goTo("Inic")
    }

}
