//
//  MedicationViewController.swift
//  MyMeds
//
//  Created by Aluno on 29/10/22.
//

import UIKit
import CoreData
import BarcodeScanner

class MedicationViewController: UIViewController {
    
    //MARK: Outlet
    
    @IBOutlet weak var descricaoTextField: UITextField!
    @IBOutlet weak var descricaoLabel: UILabel!
    @IBOutlet weak var quantidadeMax: UITextField!
    @IBOutlet weak var quantidadeAtual: UITextField!
    @IBOutlet weak var MedNameField: UITextField!
    
    @IBOutlet weak var goBackMedication: SoftButton!
    @IBOutlet weak var saveEditMed: SoftButton!
    @IBOutlet weak var categorias: SoftButton!
    @IBOutlet weak var scanCode: SoftButton!
    @IBOutlet weak var descriptionView: SoftView!
    @IBOutlet weak var doseTipo: SoftButton!
    @IBOutlet weak var validationDate: UIDatePicker!
    
    //MARK: Variables
    var contexto = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var owner : MedsTableViewController?
    
    var editarRemedio: Medicamento?
    
    var descriptionClicked  = false
    
    
    let customColor = UIColor.white
    let optionClosure = {(action: UIAction) in if ((action.index(ofAccessibilityElement: (Any).self)) != 0){}
    }
    //MARK: View Preparation

    override func viewWillAppear(_ animated: Bool) {
        
        if editarRemedio != nil {
            if let categUnwrapp = editarRemedio?.categoria {
                categorias.menu = UIMenu(children: [
                    UIAction(title: categUnwrapp, state: .on, handler: optionClosure),
                    UIAction(title: "Analgésicos", handler: optionClosure),
                    UIAction(title: "Primeiros-Socorros", handler: optionClosure),
                    UIAction(title: "Anti-Alérgico", handler: optionClosure),
                    UIAction(title: "Anti-Inflamatório", handler: optionClosure),
                    UIAction(title: "Anti-Biótico", handler: optionClosure),
                    UIAction(title: "Outro", handler: optionClosure)])
            }
            if let doseUnwrapp = editarRemedio?.dose {
                doseTipo.menu = UIMenu(children: [
                    UIAction(title: doseUnwrapp, state: .on, handler: optionClosure),
                    UIAction(title: "Comprimidos", handler: optionClosure),
                    UIAction(title: "Caixas", handler: optionClosure),
                    UIAction(title: "Usos", handler: optionClosure),
                    UIAction(title: "Unidades", handler: optionClosure),
                    UIAction(title: "Cápsulas", handler: optionClosure),
                    UIAction(title: "Outro", handler: optionClosure)])
            }
            
            MedNameField.text = editarRemedio?.nome
            descricaoLabel.text = editarRemedio?.descricao
            validationDate.date = (editarRemedio?.validade)!
            quantidadeAtual.text = editarRemedio?.quantidadeAtual
            quantidadeMax.text = editarRemedio?.quantidadeMaxima
            descricaoTextField.text = descricaoLabel.text
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        categorias.showsMenuAsPrimaryAction = true
        categorias.changesSelectionAsPrimaryAction = true
        doseTipo.showsMenuAsPrimaryAction = true
        doseTipo.changesSelectionAsPrimaryAction = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        
        view.addGestureRecognizer(tap)
        
        if editarRemedio == nil {
            setupMenus()
        }
        newmorphicItems()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK: Functions
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if descriptionClicked == true {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
    }
    
    @IBAction func clickOnTextField(_ sender: UITextField) {
        descriptionClicked = true
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func dismissKeyboard() {
        descriptionClicked = false
        view.endEditing(true)
    }
    
    
    @IBAction func escrevendoFunc(_ sender: Any) {
        descricaoLabel.text = descricaoTextField.text
    }
    
    @IBAction func goBackMedicationFunc (_ sender: SoftButton) {
        Navigation.instance.goTo("Meds")
    }
    
    @IBAction func saveEditMedFunc(_ sender: SoftButton) {
        
        if (editarRemedio != nil)  {
            if let remedioEditado = editarRemedio {
                if let categUnwrapp = categorias.titleLabel?.text {
                    remedioEditado.categoria = categUnwrapp
                }
                if let doseUnwrapp = doseTipo.titleLabel?.text {
                    remedioEditado.dose = doseUnwrapp
                }
                remedioEditado.quantidadeAtual = quantidadeAtual.text
                remedioEditado.descricao = descricaoLabel.text
                remedioEditado.quantidadeMaxima = quantidadeMax.text
                remedioEditado.validade = validationDate.date
                remedioEditado.nome = MedNameField.text
                navigationController?.popViewController(animated: true)
                
            }
        } else {
            let med = Medicamento(context: self.contexto)
            if let categUnwrapp = categorias.titleLabel?.text {
                med.categoria = categUnwrapp
            }
            if let doseUnwrapp = doseTipo.titleLabel?.text {
                med.dose = doseUnwrapp
            }
            med.quantidadeAtual = quantidadeAtual.text
            med.descricao = descricaoLabel.text
            med.quantidadeMaxima = quantidadeMax.text
            med.validade = validationDate.date
            med.nome = MedNameField.text
            owner?.addPessoa(med)
            navigationController?.popViewController(animated: true)
        }
        
        do {
            try self.contexto.save()
        } catch {
            fatalError()
        }
        
        Navigation.instance.goTo("Meds")
        
    }
    
    @IBAction func goToScanner(_ sender: SoftButton) {
        let viewController = BarcodeScannerViewController()
        viewController.codeDelegate = self as? BarcodeScannerCodeDelegate
        viewController.dismissalDelegate = self as? BarcodeScannerDismissalDelegate
        viewController.errorDelegate = self as? BarcodeScannerErrorDelegate
        viewController.headerViewController.titleLabel.text = "Escaneie o código de barras"
        viewController.headerViewController.closeButton.tintColor = .red
        viewController.headerViewController.closeButton.setTitle("Fechar", for: .normal)
        
        
        present(viewController, animated: true)
    }
    
    //MARK: Setups
    
    func setupMenus() {
        doseTipo.menu = UIMenu(children: [
            UIAction(title: "Tipo da dose", state: .on, handler: optionClosure),
            UIAction(title: "Comprimidos", handler: optionClosure),
            UIAction(title: "Caixas", handler: optionClosure),
            UIAction(title: "Usos", handler: optionClosure),
            UIAction(title: "Unidades", handler: optionClosure),
            UIAction(title: "Cápsulas", handler: optionClosure),
            UIAction(title: "Outro", handler: optionClosure)])
        
        categorias.menu = UIMenu(children: [
            UIAction(title: "Tipo", state: .on, handler: optionClosure),
            UIAction(title: "Analgésicos", handler: optionClosure),
            UIAction(title: "Primeiros-Socorros", handler: optionClosure),
            UIAction(title: "Anti-Alérgico", handler: optionClosure),
            UIAction(title: "Anti-Inflamatório", handler: optionClosure),
            UIAction(title: "Anti-Biótico", handler: optionClosure),
            UIAction(title: "Outro", handler: optionClosure)])
    }
    
    func newmorphicItems() {
        goBackMedication.makeNeuromorphic(cornerRadius: goBackMedication.bounds.height/2,  color: customColor)
        saveEditMed.makeNeuromorphic(cornerRadius: saveEditMed.bounds.height/2,  color: customColor)
        categorias.makeNeuromorphic(cornerRadius: categorias.bounds.height/2,  color: customColor)
        scanCode.makeNeuromorphic(cornerRadius: scanCode.bounds.height/2,  color: customColor)
        doseTipo.makeNeuromorphic(cornerRadius: doseTipo.bounds.height/2,  color: customColor)
        descriptionView
            .makeSoft(cornerRadius: descriptionView.bounds.height/3,  color: customColor)
    }
    
}
