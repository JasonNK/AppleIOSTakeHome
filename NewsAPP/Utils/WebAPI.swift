//
//  WebAPI.swift
//  NewsAPP
//
//  The web service layer of the application
//  Created by Jason on 6/3/20.
//  Copyright © 2020 Jason. All rights reserved.
//

import Foundation

protocol Cancellable {
    func cancel()
}

extension URLSessionTask: Cancellable {
}

protocol URLSessionProtocol {
    @discardableResult
    func getData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable
    @discardableResult
    func getDecodedData<T: Codable>(_ urlString: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable
}

class WebAPI: URLSessionProtocol {
    
    private let session: URLSession

    init(session: URLSession) {
        self.session = session
    }

    enum ResponseError: Error {
        case badURL
        case badResponseStatusCode(Int)
        case unableToConnect(Error)
        case unknown
    }
    
    @discardableResult
    func getData(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) -> Cancellable {
        let url = URL(string: urlString)!
        let task = session.dataTask(with: url) { data, urlResponse, error in
            let result: Result<Data, Error>
            do {
                if let error = error as NSError?, error.domain == NSURLErrorDomain, error.code == NSURLErrorCannotConnectToHost {
                    throw ResponseError.unableToConnect(error)
                }
                guard let urlResponse = urlResponse as? HTTPURLResponse else {
                    throw error ?? ResponseError.unknown
                }
                guard (200 ..< 300).contains(urlResponse.statusCode) else {
                    throw ResponseError.badResponseStatusCode(urlResponse.statusCode)
                }
                result = .success(data ?? Data())
            } catch {
                result = .failure(error)
            }
            completion(result)
        }
        task.resume()
        return task
    
    }
    
    @discardableResult
    func getDecodedData<T: Codable>(_ urlString: String, completion: @escaping (Result<T, Error>) -> Void) -> Cancellable {
        
        let task = getData(urlString) { (dataResult: Result<Data, Error>) in
            let result: Result<T, Error>
            switch dataResult {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(T.self, from: data)
                    result = .success(response)
                } catch {
                    result = .failure(error)
                }
            case .failure(let error):
                result = .failure(error)
            }
            completion(result)
        }
        return task
    }
}
