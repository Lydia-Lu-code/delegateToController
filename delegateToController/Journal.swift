//
//  Journal.swift
//  delegateToController
//
//  Created by 維衣 on 2020/9/21.
//

import Foundation

struct Journal: Codable {
    
    var emoji: String?
    var time: String?
    var subject: String?
    var journalText: String?
    var imageName: String?
    
    static let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func readLoversFromFile() -> [Self]? {
        let propertyDecoder = PropertyListDecoder()
        let url = Self.documentsDirectory.appendingPathComponent("journal")
        if let data = try? Data(contentsOf: url),
           let journals = try? propertyDecoder.decode([Self].self, from: data) {
            return journals
        } else {
            return nil
        }
    }
    
    static func saveToFile(journals: [Self]) {
        let propertyEncoder = PropertyListEncoder()
        if let data = try? propertyEncoder.encode(journals) {
            let url = Self.documentsDirectory.appendingPathComponent("journal")
            try? data.write(to: url)
        }
    }
}
        
 

