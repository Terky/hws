//
//  Note.swift
//  Notes
//
//  Created by Артём Бурмистров on 5/1/20.
//  Copyright © 2020 Артём Бурмистров. All rights reserved.
//

import Foundation

struct Note: Codable, Hashable {
    var id = UUID()
    var date = Date()
    var text: String
    
    static func save(_ note: Note) {
        let jsonEncoder = JSONEncoder()
        
        if let json = try? jsonEncoder.encode(note) {
            let url = Utils.documentsUrl
                .appendingPathComponent("note_\(note.id.uuidString).json")
            try? json.write(to: url)
        }
    }
    
    static func restore(from url: URL) -> Note? {
        let jsonDecoder = JSONDecoder()
        
        if let json = try? Data(contentsOf: url) {
            return try? jsonDecoder.decode(Note.self, from: json)
        }
        
        return nil
    }
    
    static func delete(_ note: Note) {
        let path = Utils.documentsUrl
            .appendingPathComponent("note_\(note.id.uuidString).json").path
        let fileManager = FileManager.default
        
        if fileManager.fileExists(atPath: path) {
            try! fileManager.removeItem(atPath: path)
        }
    }
}
