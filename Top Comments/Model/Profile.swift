//
//  Profile.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 27/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Profile: Decodable {
    let first_name: String
    let id: Double
    let last_name: String
    let online: Int
    let photo_50: String
    let photo_100: String
    let screen_name: String
    let sex: Int
}
