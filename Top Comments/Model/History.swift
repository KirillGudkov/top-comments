//
//  History.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct History: Decodable {
    let attachments: [Attachment]?
    let text: String
    let owner_id: Double
}
