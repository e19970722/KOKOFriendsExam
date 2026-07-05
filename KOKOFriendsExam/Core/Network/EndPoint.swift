//
//  EndPoint.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Foundation

enum HTTPMethod: String {
    case GET
    case POST
    case PUT
    case DELETE
}

struct EndPoint {
    let baseURL: URL
    let path: String?
    let header: [String:String]?
    let body: Data?
    let queryItems: [URLQueryItem]?
    let method: HTTPMethod
    
    init(baseURL: URL,
         path: String? = nil,
         header: [String : String]? = nil,
         body: Data? = nil,
         queryItems: [URLQueryItem]? = nil,
         method: HTTPMethod = .GET)
    {
        self.baseURL = baseURL
        self.path = path
        self.header = header
        self.body = body
        self.queryItems = queryItems
        self.method = method
    }
    
    func urlRequest() throws -> URLRequest {
        var requestURL = baseURL
        if let path = path {
            requestURL = baseURL.appending(path: path)
        }
        
        var components = URLComponents(url: requestURL, resolvingAgainstBaseURL: false)
        components?.queryItems = queryItems
        guard let finalURL = components?.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue

        if let header = header {
            header.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        }
        if let body = body {
            request.httpBody = body
        }
        
        #if DEBUG
        print("**** request url: \(finalURL.absoluteString)")
        #endif
        
        return request
    }
}
