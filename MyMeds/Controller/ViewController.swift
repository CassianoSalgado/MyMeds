//
//  ViewController.swift
//  MyMeds
//
//  Created by Aluno on 28/10/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    //MARK: Outlet

    @IBOutlet weak var goToMeds: SoftButton!
    @IBOutlet weak var timeDisplay: SoftView!
    @IBOutlet weak var goToConfig: SoftButton!
    @IBOutlet weak var goToSobre: SoftButton!
    @IBOutlet weak var timeLable: UILabel!
    
    //MARK: Variables

    var medicamento = [Medicamento]()
    
    var vencidos = [String]()
    
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let arquivo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("meds.plist")
    
    //MARK: View Preparation

    override func viewDidLoad() {
        super.viewDidLoad()
        
        carregar()
        
        goToMeds.makeNeuromorphic(cornerRadius: goToMeds.bounds.height/2,  color: UIColor.white)
        
        goToConfig.makeNeuromorphic(cornerRadius: goToConfig.bounds.height/2,  color: UIColor.white)
        
        goToSobre.makeNeuromorphic(cornerRadius: goToSobre.bounds.height/2,  color: UIColor.white)
        
        let today = Date()

        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: today)
        let hour = String(format: "%02d", dateComponents.hour!)
        let minute = String(format: "%02d", dateComponents.minute!)
                
        timeLable.text = "\(hour):\(minute)"
        
        if medicamento.count > 0 {
            let today = Date()
            let month = Calendar.current.component(.month, from: today)
            let year = Calendar.current.component(.year, from: today)
            for n in medicamento {
                if let val = n.validade {
                    if val.formatted(.iso8601.month().year()) <= Date.now.formatted(.iso8601.month().year()) {
                        if let name = n.nome {
                            vencidos.append(name)
                        }
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if vencidos.count > 0 {
            alerta()
        }
    }
    
    //MARK: Functions

    func alerta() {
        
        var message = "Os seguintes medicamentos estão vencidos:\n\n"
        
        for vencido in vencidos {
            message = message + vencido + "\n"
        }
        
        let alertaVencimento = UIAlertController(title: "Alerta de vencimento!", message: message, preferredStyle: .alert)

        alertaVencimento.addAction(UIAlertAction(title: "Entendi", style: .default, handler: { _ in }))
        
        alertaVencimento.addAction(UIAlertAction(title: "Remover Remédios", style: .destructive, handler: { _ in
            for n in self.medicamento {
                if let val = n.validade {
                    if val.formatted(.iso8601.month().year()) <= Date.now.formatted(.iso8601.month().year()) {
                        self.contexto.delete(n)
                        do {
                            try self.contexto.save()
                        } catch {
                            fatalError()
                        }
                    }
                }
            }
        }))

                
        self.present(alertaVencimento, animated: true, completion: nil)
    }
    
    func carregar(_ filtro: String? = nil) {
        let request: NSFetchRequest<Medicamento> = Medicamento.fetchRequest()
        
        if filtro != nil {
            request.predicate = NSPredicate(format: "nome CONTAINS %@", filtro!)
        }
                
        do {
            medicamento = try contexto.fetch(request)
        } catch {
            fatalError()
        }
    }

    @IBAction func goToConfigFunc(_ sender: SoftButton) {
        Navigation.instance.goTo("Config")
    }
    
    @IBAction func goToMedsFunc(_ sender: SoftButton) {
        Navigation.instance.goTo("Meds")
    }
    
    @IBAction func goToAbout(_ sender: SoftButton) {
        Navigation.instance.goTo("about")
    }

}

