//
//  Model.swift
//  NewsAPP
//
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import Foundation

final class Article: Codable {
    var id: Int?
    var data: Data?
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
    
    init(article: RawArticle) {
        source = article.source
        author = article.author
        title = article.title
        description = article.description
        url = article.url
        urlToImage = article.urlToImage
        let date = DateManipulator.getInstance().decodeToDateFormatter.date(from:  article.publishedAt)
        publishedAt = DateManipulator.getInstance().encodeToStringFormatter.string(from: date ?? Date())
        content = article.content
    }
    
    convenience init(article: RawArticle, id: Int) {
        self.init(article: article)
        self.id = id
    }
    
}


struct RawNewsResponse: Codable {
    let status: String
    let totalResults: Int
    let articles: [RawArticle]
}


struct RawArticle: Codable {
    let source: Source
    let author: String
    let title: String
    let description: String
    let url: String
    let urlToImage: String
    let publishedAt: String
    let content: String
}

struct Source: Codable {
    let id: String
    let name: String
}
