//
//  Friend.swift
//  KOKOFriendsExam
//
//  Created by Yen Lin on 2026/7/5.
//

import Foundation
import Combine

struct FriendMainInfoResponse: Codable {
    let response: [FriendMainInfo]?
}

struct FriendMainInfo: Codable {
    let name: String?
    let kokoid: String?
}

struct FriendResponse: Codable {
    let response: [Friend]?
}

struct Friend: Codable {
    /// 姓名
    let name: String?
    /// 0:邀請送出, 1:已完成 2:邀請中
    let status: InvitingStatus
    /// 是否出現星星
    let isTop: Bool?
    /// 好友id
    let fid: String?
    /// 資料更新時間
    let updateDate: Int?
    
    enum CodingKeys: String, CodingKey {
        case name, status, isTop, fid, updateDate
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)
        status = try container.decode(InvitingStatus.self, forKey: .status)
        
        let topValue = try container.decode(String.self, forKey: .isTop)
        isTop = (topValue == "1")
        
        fid = try container.decode(String.self, forKey: .fid)
        
        let updateDateValue = try container.decode(String.self, forKey: .updateDate).replacingOccurrences(of: "/", with: "")
        updateDate = Int(updateDateValue) ?? 0
    }
}

struct FriendSegment {
    let title: String
    let number: Int
}
