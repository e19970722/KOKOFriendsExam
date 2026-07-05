//
//  FriendEnum.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Foundation

public enum FriendAPIDataType: String {
    /// 好友列表1
    case friend1                           = "friend1.json"
    /// 好友列表2
    case friend2                           = "friend2.json"
    /// 好友列表含邀請列表
    case friendWithInvitingList            = "friend3.json"
    /// 無資料邀請/好友列表
    case noInvitingList                    = "friend4.json"
    
    var typeName: String {
        switch self {
        case .friend1:                     return "好友列表1"
        case .friend2:                     return "好友列表2"
        case .friendWithInvitingList:      return "好友列表含邀請列表"
        case .noInvitingList:              return "無資料邀請/好友列表"
        }
    }
}

public enum InvitingStatus: Int, Codable {
    /// 0:邀請送出
    case sent           = 0
    /// 1:已完成
    case done           = 1
    /// 2:邀請中
    case inviting       = 2
}
