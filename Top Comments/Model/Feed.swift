//
//  Feed.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Feed: Decodable {
    let items: [Item]
    let groups: [Group]
    let profiles: [Profile]
    let next_from: String
}
