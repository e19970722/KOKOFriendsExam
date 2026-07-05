//
//  FriendService.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Foundation

protocol FriendServiceProtocol {
    func fetchFriendMainInfo() async throws -> FriendMainInfoResponse
    func fetchFriends(type: FriendAPIDataType) async throws -> FriendResponse
}

class FriendService: FriendServiceProtocol {
    
    let baseURLStr = "https://dimanyen.github.io/"
    let networkManager: NetworkProtocol
    
    init(networkManager: NetworkProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchFriendMainInfo() async throws -> FriendMainInfoResponse {
        guard let baseURL = URL(string: baseURLStr) else {
            throw NetworkError.invalidURL
        }
        let request = EndPoint(baseURL: baseURL, path: "man.json")
        let response: FriendMainInfoResponse = try await networkManager.request(request)
        return response
    }
    
    func fetchFriends(type: FriendAPIDataType) async throws -> FriendResponse {
        guard let baseURL = URL(string: baseURLStr) else {
            throw NetworkError.invalidURL
        }
        let request = EndPoint(baseURL: baseURL, path: "\(type.rawValue)")
        let response: FriendResponse = try await networkManager.request(request)
        return response
    }
}

