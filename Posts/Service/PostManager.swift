//
//  PostsManager.swift
//  Posts
//
//  Created by Dmytro Ukrainskyi on 31.08.2023.
//

import Foundation

protocol PostManagerProtocol {
    
    func fetchPosts() async throws -> [Post]
    func fetchPostDetailWith(id: Int) async throws -> PostDetail
    
}

final class PostManager: PostManagerProtocol {
    
    // MARK: Private Properties
    
    private let urlSession = URLSession.shared
    private let jsonDecoder = JSONDecoder()
    
    // MARK: Public Methods
    
    func fetchPosts() async throws -> [Post] {
        guard let url = generateURLForPosts() else {
            throw generateError(description: "Bad URL")
        }
        
        do {
            let postsResponse: PostsResponse = try await fetchData(with: url)
            return postsResponse.posts
        } catch {
            throw error
        }
    }
    
    func fetchPostDetailWith(id: Int) async throws -> PostDetail {
        guard let url = generateURLForPostDetailWith(id: id) else {
            throw generateError(description: "Bad URL")
        }
        
        do {
            let postDetailResponse: PostDetailResponse = try await fetchData(with: url)
            return postDetailResponse.postDetail
        } catch {
            throw error
        }
    }
    
    // MARK: Private Methods
    
    private func fetchData<T: Decodable>(with url: URL) async throws -> T {
        let (data, response) = try await urlSession.data(from: url)
        
        guard let response = response as? HTTPURLResponse else {
            throw generateError(description: "Bad Response")
        }
        
        switch response.statusCode {
        case (200...299):
            do {
                let decodedData = try jsonDecoder.decode(T.self, from: data)
                return decodedData
            } catch {
                throw generateError(description: error.localizedDescription)
            }
        default:
            throw generateError(
                code: response.statusCode,
                description: "A server error occured"
            )
        }
    }
    
    private func generateURLForPosts() -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = "/anton-natife/jsons/master/api/main.json"
        
        return components.url
    }
    
    private func generateURLForPostDetailWith(id: Int) -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "raw.githubusercontent.com"
        components.path = "/anton-natife/jsons/master/api/posts/\(id).json"
        
        return components.url
    }
    
    private func generateError(code: Int = 1, description: String) -> Error {
        NSError(
            domain: "Posts",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: description]
        )
    }
    
}
