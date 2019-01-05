//
//  Item.swift
//  Top Comments
//
//  Created by Kirill Gudkov on 26/12/2018.
//  Copyright © 2018 Kirill Gudkov. All rights reserved.
//

import Foundation

public struct Item: Decodable {
    let type: String
    let text: String
    let date: Double
    let attachments: [Attachment]?
    let copy_history: [History]?
    let post_type: String
    let source_id: Double
    let reposts: Repost
    let comments: Comments
    let likes: Likes
}
