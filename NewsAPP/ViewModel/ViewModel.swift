//
//  ViewModel.swift
//  NewsAPP
//
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import Foundation

class ViewModel {
    var data: [Article] = []
    var searchedResult: [Article] = []
    var articleURL2Id : [String: Int] = [:]
    let service: WebAPI
    init(service: WebAPI) {
        self.service = service
    }
    
    var onError: ((Error) -> Void)?
    var onSuccess: (() -> Void)?
    let endPoint = "https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=fb1f785f985e46d6ad098ace44d65533"
    
    func getNews() {
        self.service.getDecodedData(endPoint) { (result: Result<RawNewsResponse, Error>) in
            switch result {
            case .failure(let error): self.onError?(error)
            case .success(let newsResp):
                self.data.append(contentsOf: newsResp.articles.enumerated().map({ (i, article) ->  Article in
                    Article(article: article, id: i)
                }))
                self.searchedResult = self.data
                self.onSuccess?()
            }
        }
    }
    
    func getImageData(article: Article, imageURLString: String, completion: @escaping  () -> Void) {
        self.service.getData(imageURLString) { (result) in
            switch result {
            case .success(let data):
                article.data = data
                completion()
            case .failure(let error):
                self.onError?(error)
            }
        }
    }
    
    
}
