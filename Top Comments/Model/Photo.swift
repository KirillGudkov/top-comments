//
//  Photo.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Photo: Decodable {
    let photo_604: Any
    
    enum CodingKeys: String, CodingKey {
        case photo_604
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        var decoded: Any?
        do {
            decoded = try? container.decode(String.self, forKey: .photo_604)
        }

        if (decoded is String) {
            self.photo_604 = decoded ?? ""
        } else {
            self.photo_604 = ""
        }
    }
}
