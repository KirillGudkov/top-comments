//
//  Attachment.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Attachment: Decodable {
    let type: String
    let photo: Photo?
    let link: Link?
}
