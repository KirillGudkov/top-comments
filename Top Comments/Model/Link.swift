//
//  Link.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Link: Decodable {
    let caption: String?
    let description: String?
    let is_external: Int?
    let title: String?
    let url: String?
    let photo: Photo?
}
