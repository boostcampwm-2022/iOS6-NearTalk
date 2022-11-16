//
//  ChattingRoomList.swift
//  NearTalk
//
//  Created by 김영욱 on 2022/11/15.
//

import Foundation

struct OpenChattingRoomListData: Hashable {
    var img: String
    var name: String
    var description: String
    var date: String
    var count: String
}

struct DMChattingRoomListData: Hashable {
    var img: String
    var name: String
    var description: String
    var date: String
}
