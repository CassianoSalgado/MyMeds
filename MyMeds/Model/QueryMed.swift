//
//  QueryMed.swift
//  MyMeds
//
//  Created by Cassiano Carradore Salgado on 08/11/22.
//

import Foundation

class QueryMed {
    var nome: String
    var descricao: String
    var ean: String
    var tarja: String
    
    init(nome: String, descricao: String, ean: String, tarja: String) {
        self.nome = nome
        self.descricao = descricao
        self.ean = ean
        self.tarja = tarja
    }
    
    static func mapToObject(medData: [String: Any]) -> QueryMed {
            
        let nome: String = medData["nome"] as! String
        let descricao: String = medData["descricao"] as! String
        let ean: String = medData["ean"] as! String
        let tarja: String = medData["tarja"] as! String
        
        let medication = QueryMed(nome: nome, descricao: descricao, ean: ean, tarja: tarja)
            
        return medication
    }
}
