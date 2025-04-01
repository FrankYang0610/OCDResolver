//
//  JSONManager.swift
//  OCDResolver
//
//  Created by Frank Yang.
//

import Foundation

/// The class handles all JSON requests.
class JSONManager {
    static func load<T: Decodable>(filename: String) -> [T] {
        guard let fileURL = FileManager.default
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(filename) else {
            fatalError("CANNOT FOUND JSON FILE")
        }
        
        do {
            let JSONData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            return try decoder.decode([T].self, from: JSONData)
        } catch {
            fatalError("CANNOT DECODE JSON FILE")
        }
    }
    
    static func update<T: Encodable>(data: [T], filename: String) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let JSONData = try encoder.encode(data)
            
            guard let fileURL = FileManager.default
                .urls(for: .documentDirectory, in: .userDomainMask)
                .first?.appendingPathComponent(filename) else {
                fatalError("CANNOT FOUND JSON FILE")
            }
            
            try JSONData.write(to: fileURL, options: .atomic)
        } catch {
            fatalError("CANNOT UPDATE JSON DATA")
        } 
    }
}
