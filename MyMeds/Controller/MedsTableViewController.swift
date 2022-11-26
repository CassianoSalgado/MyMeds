//
//  MedsTableViewController.swift
//  MyMeds
//
//  Created by Aluno on 29/10/22.
//

import UIKit
import CoreData

//MARK: Cell Class

class MedInformation: UITableViewCell {
    
    //MARK: Variables

    var closure: (()->())?
    
    //MARK: Outlet

    @IBOutlet weak var tomarLabel: UILabel!
    @IBOutlet weak var medQuant: UILabel!
    @IBOutlet weak var medVal: UILabel!
    @IBOutlet weak var medCat: UILabel!
    @IBOutlet weak var tomarButton: SoftButton!
    @IBOutlet weak var medBackground: SoftView!
    @IBOutlet weak var medName: UILabel!
    @IBAction func buttonAction(_ sender: SoftButton) {
        closure?()
    }
}

//MARK: Table View Class

class MedsTableViewController: UITableViewController {
    
    //MARK: Outlet

    @IBOutlet weak var goBackMedsTBV: SoftButton!
    @IBOutlet weak var search: UITextField!
    @IBOutlet weak var newMedsTBV: SoftButton!
    
    //MARK: Variables

    var medicamento = [Medicamento]()
    
    let customColor = UIColor.white
    
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let arquivo = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("meds.plist")
    
    //MARK: View Preparation

    override func viewDidLoad() {
        super.viewDidLoad()
        goBackMedsTBV.makeNeuromorphic(cornerRadius: goBackMedsTBV.bounds.height/2,  color: customColor)
        newMedsTBV.makeNeuromorphic(cornerRadius: newMedsTBV.bounds.height/2,  color: customColor)
        carregar()

    }
    
    //MARK: Functions

    func carregar(_ filtro: String? = nil) {
        let request: NSFetchRequest<Medicamento> = Medicamento.fetchRequest()
        
        if filtro != nil {
            request.predicate = NSPredicate(format: "nome contains[cd] %@", filtro!)
        }
                
        do {
            medicamento = try contexto.fetch(request)
        } catch {
            fatalError()
        }
    }

    // MARK: - Table view data source
    
    @IBAction func newMedsTBVFunc(_ sender: Any) {
        Navigation.instance.goTo("AddMed")
    }
    
    @IBAction func goBackMedsTBVFunc(_ sender: Any) {
        Navigation.instance.goTo("Inic")
    }
    
    @IBAction func searching(_ sender: Any) {
        if search.text == "" {
            carregar()
        } else {
            carregar(search.text)

        }
        self.tableView.reloadData()
    }
    
    //MARK: Sections

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    //MARK: Cells

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return medicamento.count
    }

    //MARK: Cell Contents

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MedTCell", for: indexPath) as! MedInformation
       
        let medication = medicamento[indexPath.row]
        
        var qntMaxInt = Int()
        var qntAtualInt = Int()

        if medication.quantidadeAtual == "" {
            medication.quantidadeAtual = "1"
            medication.quantidadeMaxima = "1"
            do {
                try self.contexto.save()
            } catch {
                fatalError()
            }
            self.tableView.reloadData()

        } else {
            if let qntAtualUnwrapp = medication.quantidadeAtual {
                qntAtualInt = Int(qntAtualUnwrapp)!
            }

            if let qntMaxUnwrapp = medication.quantidadeMaxima {
                qntMaxInt = Int(qntMaxUnwrapp)!
            }
        }
        
        cell.tomarButton.tag = indexPath.row
        
        if qntAtualInt == 0 {
            cell.tomarLabel.text = "Repor"
            cell.tomarLabel.textColor = UIColor.init(red: 255/255, green: 149/255, blue: 143/255, alpha: 1)

            cell.closure = {
                qntAtualInt = Int(qntMaxInt)
                medication.quantidadeAtual = String("\(qntAtualInt)")
                do {
                    try self.contexto.save()
                } catch {
                    fatalError()
                }
                self.tableView.reloadData()
            }
        } else {
            cell.tomarLabel.text = "Tomar"
            cell.tomarLabel.textColor = UIColor.white
            cell.closure = {
                qntAtualInt -= 1
                medication.quantidadeAtual = String("\(qntAtualInt)")
                do {
                    try self.contexto.save()
                } catch {
                    fatalError()
                }
                self.tableView.reloadData()
            }
        }
        
        cell.medQuant.text = "Qnt. \(qntAtualInt)-\(qntMaxInt)"
        
        if medication.nome == "" {
            medication.nome = "Medicação"
            do {
                try self.contexto.save()
            } catch {
                fatalError()
            }
            self.tableView.reloadData()
        }
        
        cell.medName.text = medication.nome
        
        if medication.categoria == "Tipo" {
            medication.categoria  = "Outro"
            do {
                try self.contexto.save()
            } catch {
                fatalError()
            }
            self.tableView.reloadData()
        }
        cell.medCat.text = medication.categoria
            
        cell.tomarButton.makeNeuromorphic(cornerRadius: cell.tomarButton.bounds.height/2,  color: UIColor.init(red: 68/255, green: 113/255, blue: 166/255, alpha: 1))
        cell.medBackground.makeSoft(cornerRadius: cell.medBackground.bounds.height/4,  color: UIColor.white)
            
        var mesUnwrapp = ""
        var anoUnwrapp = ""
        
        if let mesVal = medication.validade?.formatted(.iso8601.month()) {
            mesUnwrapp = "\(mesVal)"
        }
        if let anoVal = medication.validade?.formatted(.iso8601.year()) {
            anoUnwrapp = "\(anoVal)"
        }
        
        cell.medVal.text = "Validade: \(mesUnwrapp)/\(anoUnwrapp)"

        
        return cell
    }
    
    //MARK: Deleting Cell

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if self.medicamento.count > 0 {
                contexto.delete(self.medicamento[indexPath.row])
                do {
                    try self.contexto.save()
                } catch {
                    fatalError()
                }
                self.medicamento.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
        }
    }
    
    //MARK: Add/Editing Cell Componnents

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
  
    func editarRemedio(_ remedio : Medicamento) {
        let index = tableView.indexPathForSelectedRow?.row
        medicamento[index!].nome = remedio.nome
        medicamento[index!].categoria = remedio.categoria
        medicamento[index!].descricao = remedio.descricao
        medicamento[index!].quantidadeAtual = remedio.quantidadeAtual
        medicamento[index!].quantidadeMaxima = remedio.quantidadeMaxima
        medicamento[index!].validade = remedio.validade
        self.tableView.reloadData()
    }
    
    func addPessoa(_ remedio : Medicamento) {
        medicamento.append(remedio)
        
        let cell = IndexPath(row: medicamento.count - 1, section: 0)
        tableView.beginUpdates()
        tableView.insertRows(at: [cell], with: .bottom)
        tableView.endUpdates()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let next = segue.destination as! MedicationViewController
        next.owner = self
        if segue.identifier == "edit" {
            next.editarRemedio = medicamento[(tableView.indexPathForSelectedRow?.row)!]
        } else {
            next.editarRemedio = nil
        }
    }
    
}
