//
//  Posts.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import Foundation

struct Post: Decodable {
    
    // MARK: Public Properties
    let id: Int
    let timestamp: Int
    let title: String
    let previewText: String
    let likesCount: Int
    
    var datePosted: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timestamp = "timeshamp" // Fixed API's Typo
        case title
        case previewText = "preview_text"
        case likesCount = "likes_count"
    }
    
}
