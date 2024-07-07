//
//  Task.swift
//  PestoTaskApp
//
//  Created by Vineeth Gopinathan on 06/07/24.
//

import Foundation


class Task: Codable {
    
    var id: Int64?
    var title: String?
    var description: String?
    var status: String?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "title"
        case description = "description"
        case status = "status"
  
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decodeIfPresent(Int64.self, forKey: .id)!
        self.title = try container.decodeIfPresent(String.self, forKey: .title)
        self.description = try container.decodeIfPresent(String.self, forKey: .description)
        self.status = try container.decodeIfPresent(String.self, forKey: .status)
      
    }

}
