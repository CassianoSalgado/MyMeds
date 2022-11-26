//
//  DAOFirebase.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 08/11/22.
//

import Foundation
import Firebase
import FirebaseFirestore
import UIKit

class DAOFirebase {
    
    static func loadMed(with code: String, completion: @escaping (QueryMed?) -> ()) {
        let db = Firestore.firestore()
        
        let medsFirebase = db.collection("remedios").whereField("ean", isEqualTo: code).getDocuments() { (querySnapshot, error) in
            
            if let error {
                print("Error getting documents: \(error)")
            } else {
                print(querySnapshot?.documents.count)
                if (querySnapshot?.documents.count)! > 0 {
                    for document in querySnapshot!.documents {
                        let medication = QueryMed.mapToObject(medData: document.data())
                        completion(medication)
                    }
                } else {
                    let medication = QueryMed(nome: "", descricao: "", ean: "", tarja: "")
                    completion(medication)
                }
            }
        }
    }
}
