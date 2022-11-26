//
//  ConfigViewController.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 21/11/22.
//

import UIKit
import CoreData

class ConfigViewController: UIViewController {

    @IBOutlet weak var deletaMeds: SoftButton!
    @IBOutlet weak var goBackConfig: SoftButton!
    
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var medicamento = [Medicamento]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carregar()
        goBackConfig.makeNeuromorphic(cornerRadius: goBackConfig.bounds.height/2, color: UIColor.white)
        deletaMeds.makeNeuromorphic(cornerRadius: deletaMeds.bounds.height/2, color: UIColor.red)
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
    
    @IBAction func goBack(_ sender: SoftButton) {
        Navigation.instance.goTo("Inic")
    }
    
    @IBAction func deleteAll(_ sender: SoftButton) {
        var contador = 0
        if self.medicamento.count > 0 {
            if self.medicamento.count >= contador {
                for m in medicamento {
                    contexto.delete(self.medicamento[contador])
                    do {
                        try self.contexto.save()
                    } catch {
                        fatalError()
                    }
                    self.medicamento.remove(at: contador)
                }

            }
        }
    }
}
