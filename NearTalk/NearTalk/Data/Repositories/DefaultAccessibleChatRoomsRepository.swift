//
//  DefaultAccessibleChatRoomsRepository.swift
//  NearTalk
//
//  Created by lymchgmk on 2022/11/24.
//

import Foundation
import RxSwift

final class DefaultAccessibleChatRoomsRepository {
    
    struct Dependencies {
        let firestoreService: FirestoreService
        let apiDataTransferService: StorageService
        let imageDataTransferService: StorageService
    }
    
    private let dependencies: Dependencies
    
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

extension DefaultAccessibleChatRoomsRepository: AccessibleChatRoomsRepository {
    
    func fetchAccessibleAllChatRooms(in region: NCMapRegion) -> Single<[ChatRoom]> {
        let centerLocation = region.centerLocation
        let southWest = centerLocation.add(latitudeDelta: -(region.latitudeDelta / 2), longitudeDelta: -(region.longitudeDelta / 2))
        let northEast = centerLocation.add(latitudeDelta: (region.latitudeDelta / 2), longitudeDelta: (region.longitudeDelta / 2))

        let service = self.dependencies.firestoreService
        let queryList: [FirebaseQueryDTO] = [
            .init(key: "latitude", value: southWest.latitude, queryKey: .isGreaterThan),
            .init(key: "latitude", value: northEast.latitude, queryKey: .isLessThan)
        ]
        let latitudeFilteredChatRooms: Single<[ChatRoom]> = service.fetchList(dataKey: .chatRoom, queryList: queryList)

        return latitudeFilteredChatRooms
            .map { chatRooms in
                chatRooms.filter {
                    guard let chatRoomLongitude = $0.longitude
                    else {
                        return false
                    }
                    return southWest.longitude..<northEast.longitude ~= chatRoomLongitude
                }
            }
    }
    
    func fetchAccessibleGroupChatRooms(in region: NCMapRegion) -> Single<[GroupChatRoomListData]> {
        return self.fetchAccessibleAllChatRooms(in: region)
        .map { $0.filter { $0.roomType == "group" } }
        .map { $0.map { GroupChatRoomListData(data: $0) } }
    }
    
    func fetchAccessibleDMChatRooms(in region: NCMapRegion) -> Single<[DMChatRoomListData]> {
        return self.fetchAccessibleAllChatRooms(in: region)
        .map { $0.filter { $0.roomType == "dm" } }
        .map { $0.map { DMChatRoomListData(data: $0) } }
    }
    
    // 더미
    func fetchDummyChatRooms() -> Single<[ChatRoom]> {
        let dummyChatRooms: [ChatRoom] = [
            ChatRoom(uuid: "1",
                     userList: [],
                     roomImagePath: nil,
                     roomType: "group",
                     roomName: "1번방",
                     roomDescription: "1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다1번방 입니다",
                     latitude: 37.358,
                     longitude: 127.1045,
                     accessibleRadius: 1,
                     recentMessageID: nil,
                     recentMessageText: nil,
                     recentMessageDateTimeStamp: nil,
                     maxNumberOfParticipants: nil,
                     messageCount: nil),
            ChatRoom(uuid: "2",
                     userList: [],
                     roomImagePath: nil,
                     roomType: "group",
                     roomName: "2번방",
                     roomDescription: "2번방 입니다",
                     latitude: 37.359,
                     longitude: 127.1050,
                     accessibleRadius: 2,
                     recentMessageID: nil,
                     recentMessageText: nil,
                     recentMessageDateTimeStamp: nil,
                     maxNumberOfParticipants: nil,
                     messageCount: nil),
            ChatRoom(uuid: "3",
                     userList: [],
                     roomImagePath: nil,
                     roomType: "group",
                     roomName: "3번방",
                     roomDescription: "3번방 입니다",
                     latitude: 37.3585,
                     longitude: 127.1050,
                     accessibleRadius: 3,
                     recentMessageID: nil,
                     recentMessageText: nil,
                     recentMessageDateTimeStamp: nil,
                     maxNumberOfParticipants: nil,
                     messageCount: nil),
            ChatRoom(uuid: "4",
                     userList: [],
                     roomImagePath: nil,
                     roomType: "dm",
                     roomName: "4번방",
                     roomDescription: "4번방 입니다",
                     latitude: 37.3595,
                     longitude: 127.1060,
                     accessibleRadius: 4,
                     recentMessageID: nil,
                     recentMessageText: nil,
                     recentMessageDateTimeStamp: nil,
                     maxNumberOfParticipants: nil,
                     messageCount: nil),
            ChatRoom(uuid: "5",
                     userList: [],
                     roomImagePath: nil,
                     roomType: "dm",
                     roomName: "5번방",
                     roomDescription: "5번방 입니다",
                     latitude: 37.35,
                     longitude: 127.1059,
                     accessibleRadius: 5,
                     recentMessageID: nil,
                     recentMessageText: nil,
                     recentMessageDateTimeStamp: nil,
                     maxNumberOfParticipants: nil,
                     messageCount: nil)
            ]

        return Single.just(dummyChatRooms)
    }
}
