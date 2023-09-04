//
//  PostDetailResponse.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 02.09.2023.
//

import Foundation

struct PostDetailResponse: Decodable {
    
    let postDetail: PostDetail
    
    private enum CodingKeys: String, CodingKey {
        case postDetail = "post"
    }
}
