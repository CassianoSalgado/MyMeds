//
//  BarCodeScannerExtensions.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 09/11/22.
//

import Foundation
import BarcodeScanner
import UIKit

//MARK: Use BarcodeScannerCodeDelegate when you want to get the captured code back.
extension MedicationViewController: BarcodeScannerCodeDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didCaptureCode code: String, type: String) {
        
        DAOFirebase.loadMed(with: code){ medicacao in
            controller.dismiss(animated: true)
            
            if medicacao!.nome == "" {
                let alert = UIAlertController(title: "Não encontramos seu remédio!", message: "Infelizmente não temos registro do remédio buscado. Por favor, digite manualmente as informações.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alert, animated: true)
            } else {
                self.MedNameField.text = medicacao?.nome
                self.descricaoLabel.text = medicacao?.descricao
            }
        }
    }
}

//MARK: Use BarcodeScannerErrorDelegate when you want to handle session errors.
extension MedicationViewController: BarcodeScannerErrorDelegate {
    func scanner(_ controller: BarcodeScannerViewController, didReceiveError error: Error) {
        print(error)
    }
}

//MARK: Use BarcodeScannerDismissalDelegate to handle "Close button" tap. Please note that BarcodeScannerViewController doesn't dismiss itself if it was presented initially.
extension MedicationViewController: BarcodeScannerDismissalDelegate {
    func scannerDidDismiss(_ controller: BarcodeScannerViewController) {
        controller.dismiss(animated: true, completion: nil)
        controller.reset()
    }
}
