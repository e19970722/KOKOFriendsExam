//
//  NetworkManager.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case timeout
    case invalidResponse
    case serverError(Int)
    case decodingError(Error)
    case unknown(Error)
}

protocol NetworkProtocol {
    func request<T: Decodable>(_ request: EndPoint) async throws -> T
}

class NetworkManager: NetworkProtocol {
    
    static let shared = NetworkManager()
    let session: URLSession
    let decoder: JSONDecoder
    let timeInterval: TimeInterval
    
    init(session: URLSession = .shared,
         decoder: JSONDecoder = .init(),
         timeInterval: TimeInterval = 30)
    {
        self.session = session
        self.decoder = decoder
        self.timeInterval = timeInterval
    }
    
    func request<T>(_ request: EndPoint) async throws -> T where T : Decodable {
        var urlRequest = try request.urlRequest()
        urlRequest.timeoutInterval = timeInterval
        
        let data: Data
        let response: URLResponse
        
        do {
            (data, response) = try await session.data(for: urlRequest)
            
        } catch let error as URLError where error.code == .timedOut {
            throw NetworkError.timeout
            
        } catch(let error) {
            throw NetworkError.unknown(error)
        }
        
        guard !data.isEmpty,
              let urlResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard (200...299).contains(urlResponse.statusCode) else {
            throw NetworkError.serverError(urlResponse.statusCode)
        }
        
        do {
            return try decoder.decode(T.self, from: data)
            
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
