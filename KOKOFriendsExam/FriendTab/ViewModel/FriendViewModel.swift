//
//  FriendViewModel.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Combine
import Foundation

class FriendViewModel {
    
    @Published var mainInfo: FriendMainInfo?
    @Published var invitedFriends: [Friend] = []
    @Published private(set) var displayFriends: [Friend] = []
    @Published private(set) var friends: [Friend] = []
    
    private let service: FriendServiceProtocol
    
    init(service: FriendServiceProtocol = FriendService()) {
        self.service = service
    }
    
    func fetchItems(type: FetchCase) async throws {
        await withTaskGroup { [weak self] group in
            guard let self = self else { return }
            group.addTask {
                if let mainInfoResponse = try? await self.service.fetchFriendMainInfo() {
                    await MainActor.run {
                        self.mainInfo = mainInfoResponse.response?.first
                    }
                }
            }
            
            switch type {
            case .noFriend:
                group.addTask {
                    if let friendResponse = try? await self.service.fetchFriends(type: .noInvitingList) {
                        await MainActor.run {
                            self.displayFriends = friendResponse.response ?? []
                        }
                    }
                }
                
            case .friendListNoInvitation, .friendListWithFriends:
                var responseFriends: [Friend] = []
                group.addTask {
                    if let friendResponse = try? await self.service.fetchFriends(type: .friend1),
                       let friends = friendResponse.response {
                        responseFriends.append(contentsOf: friends)
                    }
                    if let friendResponse = try? await self.service.fetchFriends(type: .friend2),
                       let friends = friendResponse.response {
                        for friend in friends {
                            if let existFidFriend = responseFriends.filter({ $0.fid == friend.fid }).first,
                               let existUpdateDate = existFidFriend.updateDate,
                               let NewUpdateDate = friend.updateDate,
                               NewUpdateDate > existUpdateDate {
                                responseFriends.removeAll(where: { $0.fid == friend.fid })
                                responseFriends.append(friend)
                            }
                        }
                    }
                    await MainActor.run {
                        self.displayFriends = responseFriends
                        self.friends = responseFriends
                    }
                }
                
                if type == .friendListWithFriends {
                    group.addTask {
                        if let friendResponse = try? await self.service.fetchFriends(type: .friendWithInvitingList) {
                            await MainActor.run {
                                self.invitedFriends = friendResponse.response ?? []
                            }
                        }
                    }
                }
            }
        }
    }
    
    func search(text: String) {
        if text.isEmpty {
            displayFriends = friends
            
        } else {
            displayFriends = friends.filter{ friend in
                if let name = friend.name {
                    return name.contains(text)
                }
                return false
            }
        }
    }
}
