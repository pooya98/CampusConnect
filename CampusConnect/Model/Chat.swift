//
//  Chat.swift
//  CampusConnect
//
//  Created by 강승우 on 2023/05/26.
//

import Foundation

struct Chat {
    let id: UUID = UUID()
    let opponentName: String
    let opponentImageURL: String
    let opponentRegion: String
    let lastchat: String
}

extension Chat: Identifiable {}

let ChatSamples: [Chat] = [
    Chat(opponentName: "Lebron", opponentImageURL: "DefaultUserImage",opponentRegion: "북문", lastchat: "안녕하세요"),
    Chat(opponentName: "Curry", opponentImageURL: "DefaultUserImage",opponentRegion: "테크노문", lastchat: "끝까지 화이팅하자~"),
    Chat(opponentName: "Luka", opponentImageURL: "DefaultUserImage",opponentRegion: "동문", lastchat: "배고프다 밥먹으로 가자")
]
