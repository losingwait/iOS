//
//  Machine.swift
//  LosingWait
//
//  Created by Mike Choi on 4/1/19.
//  Copyright © 2019 Mike JS. Choi. All rights reserved.
//

import Foundation

enum MachineStatus: String, Codable {
    case open, queued, occupied
}

struct Machine: Decodable {
    
    let _id: String
    let name: String
    let muscle_id: String
    let machine_group_id: String
    let station_id: String
    let in_use: MachineStatus
    let user_id: String?
    let signed_in_time: Date?
    
    var sinceLastCheckIn: String {
        get {
            guard let date = signed_in_time else {
                return "-"
            }
            
            return Date().timeIntervalSince(date).humanized
        }
    }
    
    init(response: [String : Any]) {
        guard let jsonData = try? JSONSerialization.data(withJSONObject: response, options: []) else {
            fatalError("Couldn't serialize data")
        }
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601Full)
        guard let result = try? decoder.decode(Machine.self, from: jsonData) else {
            fatalError("Couldn't decode \(Machine.self) data")
        }
        
        self = result
    }
}

extension DateFormatter {
    static let iso8601Full: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.S"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

