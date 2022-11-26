//
//  OnboardViewController.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 25/11/22.
//

import UIKit
import SwiftyOnboard
import CoreData

class OnboardViewController: UIViewController {
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
    var first = [PrimeiraVez]()
    
    let arquivo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("meds.plist")
     
    var swiftyOnboard: SwiftyOnboard!
        
    var titles = ["Bem vindo", "Adicionar Medicamento", "Controlar Vencimentos"]
    var subTitles = ["Seja bem vindo ao MyMeds!\nSua caixa de remédios na palma da mão!", "Adicione, edite, delete e controle a quantidade dos seus medicamentos em segundos!\nCadastre quantos medicamentos quiser!", "Chega de surpresas quando abrir sua caixa de remédios!\nO MyMeds te informa quais medicamentos venceram sempre que você entra no app!"]

    override func viewDidLoad() {
        super.viewDidLoad()
        carregar()
        if first.count == 0 {
            swiftyOnboard = SwiftyOnboard(frame: view.frame)
            view.addSubview(swiftyOnboard)
            swiftyOnboard.dataSource = self
            swiftyOnboard.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        notFirst()
    }
    
    func carregar(_ filtro: String? = nil) {
        let request: NSFetchRequest<PrimeiraVez> = PrimeiraVez.fetchRequest()
        
        do {
            first = try contexto.fetch(request)
        } catch {
            fatalError()
        }
    }
    
    func notFirst() {
        if first.count != 0 {
            Navigation.instance.goTo("Inic")
        }
    }


    @objc func handleSkip() {
        swiftyOnboard?.goToPage(index: 2, animated: true)
    }
    
    @objc func handleContinue(sender: UIButton) {
        let index = sender.tag
        swiftyOnboard?.goToPage(index: index + 1, animated: true)
        
        if sender.titleLabel?.text == "Começar" {
            let didSee = PrimeiraVez(context: self.contexto)
            didSee.firstTime = false
            first.append(didSee)
            do {
                try self.contexto.save()
            } catch {
                fatalError()
            }
            
            Navigation.instance.goTo("Inic")

        }
    }
    
    
}

extension OnboardViewController: SwiftyOnboardDataSource, SwiftyOnboardDelegate {
    func swiftyOnboardNumberOfPages(_ swiftyOnboard: SwiftyOnboard) -> Int {
        return 3
    }
    
    func swiftyOnboardPageForIndex(_ swiftyOnboard: SwiftyOnboard, index: Int) -> SwiftyOnboardPage? {
        let page = SwiftyOnboardPage()
        page.imageView.image = UIImage(named: "\(index)")
        page.imageView.contentMode = UIImageView.ContentMode.scaleAspectFit
        page.title.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 25.0)
        page.title.textColor = UIColor.white
        page.subTitle.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 18.0)
        page.subTitle.textColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        page.title.text = titles[index]
        page.subTitle.text = subTitles[index]
        
        return page
    }
    
    func swiftyOnboardBackgroundColorFor(_ swiftyOnboard: SwiftyOnboard, atIndex index: Int) -> UIColor? {
        return UIColor(named: "blueish")
    }
    
    func swiftyOnboardViewForOverlay(_ swiftyOnboard: SwiftyOnboard) -> SwiftyOnboardOverlay? {
        let overlay = SwiftyOnboardOverlay()
        overlay.skipButton.addTarget(self, action: #selector(handleSkip), for: .touchUpInside)
        overlay.continueButton.addTarget(self, action: #selector(handleContinue), for: .touchUpInside)
        overlay.continueButton.titleLabel?.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 18.0)
        overlay.skipButton.titleLabel?.font = UIFont(name: "Hiragino Maru Gothic ProN", size: 18.0)
        overlay.continueButton.setTitle("Continuar", for: .normal)
        overlay.skipButton.setTitle("Pular", for: .normal)
        overlay.skipButton.isHidden = false
        return overlay
    }
    
    func swiftyOnboardOverlayForPosition(_ swiftyOnboard: SwiftyOnboard, overlay: SwiftyOnboardOverlay, for position: Double) {
        let currentPage = round(position)
        overlay.pageControl.currentPage = Int(currentPage)
        overlay.continueButton.tag = Int(position)
        if currentPage == 0.0 || currentPage == 1.0 {
            overlay.continueButton.setTitle("Continuar", for: .normal)
            overlay.skipButton.setTitle("Pular", for: .normal)
            overlay.skipButton.isHidden = false
        } else {
            overlay.continueButton.setTitle("Começar", for: .normal)
            overlay.skipButton.isHidden = true
        }
    }
}
