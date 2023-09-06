//
//  PostDetail.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import Foundation

struct PostDetail: Decodable {
    
    // MARK: Public Properties
    let id: Int
    let timestamp: Int
    let title: String
    let text: String
    let imageURL: String
    let likesCount: Int
    
    var datePosted: Date {
        Date(timeIntervalSince1970: TimeInterval(timestamp))
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "postId"
        case timestamp = "timeshamp" // Fixed API's Typo
        case title
        case text
        case imageURL = "postImage"
        case likesCount = "likes_count"
    }
    
}
