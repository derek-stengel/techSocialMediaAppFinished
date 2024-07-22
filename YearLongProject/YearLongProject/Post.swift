//
//  Post.swift
//  YearLongProject
//
//  Created by Derek Stengel on 7/2/24.
//

import Foundation

struct Post: Codable {
    var postid: Int
    var authorUserName: String
    var createdDate: String
    var title: String
    var body: String
    var numComments: Int
    var likes: Int
    
    enum CodingKeys: String, CodingKey {
        case postid, authorUserName, createdDate, title, body, numComments, likes
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        postid = try container.decode(Int.self, forKey: .postid)
        authorUserName = try container.decode(String.self, forKey: .authorUserName)
        createdDate = try container.decode(String.self, forKey: .createdDate)
        title = try container.decode(String.self, forKey: .title)
        body = try container.decode(String.self, forKey: .body)
        
        if let numCommentsString = try? container.decode(String.self, forKey: .numComments),
           let numCommentsInt = Int(numCommentsString) {
            numComments = numCommentsInt
        } else {
            numComments = try container.decode(Int.self, forKey: .numComments)
        }
        
        if let likesString = try? container.decode(String.self, forKey: .likes),
           let likesInt = Int(likesString) {
            likes = likesInt
        } else {
            likes = try container.decode(Int.self, forKey: .likes)
        }
    }
    
    init(postid: Int, authorUserName: String, createdDate: String, title: String, body: String, numComments: Int, likes: Int) {
            self.postid = postid
            self.authorUserName = authorUserName
            self.createdDate = createdDate
            self.title = title
            self.body = body
            self.numComments = numComments
            self.likes = likes
        }
}

struct newPost: Codable {
    var userSecret: UUID
    var post: [String: String]
}

