//
//  GroupMeAPI.swift
//  GroupMe
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation
import Promises

public class GroupMeAPI : GroupMeAPIProtocol {
    
    let token: String
    
    public init(token: String) {
        self.token = token
    }
    
    // MARK: Groups
    public func getGroups() -> Promise<[GMGroup]> {
        let request = URLRequest(url: genURI(endpoint: "/groups"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<[GMGroup]>.self, from: $0) }
            .then { $0.response! }
    }
    public func getFormerGroups() -> Promise<[GMGroup]> {
        let request = URLRequest(url: genURI(endpoint: "/groups/former"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<[GMGroup]>.self, from: $0) }
            .then { $0.response! }
    }
    public func getGroup(withId group: String) -> Promise<GMGroup> {
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMGroup>.self, from: $0) }
            .then { $0.response! }
    }
    public func createGroup(name: String, share: Bool = false, image_url: String? = nil) -> Promise<GMGroup> {
        let requestBody = GMRequestCreateGroup(name: name, share: share, image_url: image_url)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMGroup>.self, from: $0) }
            .then { $0.response! }
    }
    public func updateGroup(withId group: String, name: String? = nil, description: String? = nil, image_url: String? = nil, office_mode: Bool? = nil, share: Bool? = nil) -> Promise<GMGroup> {
        let requestBody = GMRequestUpdateGroup(name: name, description: description, image_url: image_url, office_mode: office_mode, share: share)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups/\(group)/update"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMGroup>.self, from: $0) }
            .then { $0.response! }
    }
    public func destroyGroup(withId group: String) -> Promise<Data> {
        var request = URLRequest(url: genURI(endpoint: "/groups/\(group)/destroy"))
        request.httpMethod = "POST"
        
        return promiseRequest(request: request)
    }
    public func joinGroup(withId group: String, andShareToken shareToken: String) -> Promise<GMGroup> {
        var request = URLRequest(url: genURI(endpoint: "/groups/\(group)/join/\(shareToken)"))
        request.httpMethod = "POST"
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseJoinGroup>.self, from: $0) }
            .then { $0.response! }
            .then { $0.group }
    }
    public func rejoinGroup(withId group: String) -> Promise<GMGroup> {
        let requestBody = GMRequestRejoinGroup(group_id: group)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups/join"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMGroup>.self, from: $0) }
            .then { $0.response! }
    }
    
    // TODO: Implement changing group owners
    
    // MARK: Group Membership
    public func addMembers(_ members: [GMRequestAddMembers_NewMember], toGroup group: String) -> Promise<GMResponseAddMembers> {
        let requestBody = GMRequestAddMembers(members: members)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups/join"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseAddMembers>.self, from: $0) }
            .then { $0.response! }
    }
    public func getMembershipResults(withId results_id: String, forGroup group: String) -> Promise<Any> {
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)/members/results/\(results_id)"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseAddMembers/*DOES NOT WORK; CREATE RESULTS!!!!!!!*/>.self, from: $0) }
    }
    public func removeMember(withId membershipId: String, fromGroup group: String) -> Promise<Data> {
        var request = URLRequest(url: genURI(endpoint: "/groups/\(group)/members/\(membershipId)/remove"))
        request.httpMethod = "POST"
        
        return promiseRequest(request: request)
    }
    public func updateNickname(to newNickname: String, forGroup group: String) -> Promise<GMGroupMember> {
        let requestBody = GMRequestUpdateMembership(membership: GMMembership(nickname: newNickname))
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups/\(group)/memberships/update"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMGroupMember>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response! }
    }
    
    // MARK: Messages
    public func getMessages(forGroup group: String, beforeMessage: String?, sinceMessage: String?, afterMessage: String?, withLimit limit: Int) -> Promise<[GMGroupMessage]> {
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)/messages"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GroupMessagesResponse>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response!.messages }
    }
    public func createMessage(inGroup group: String, withText text: String, withAttachments attachments: [GMAttachment]) -> Promise<GMGroupMessage> {
        let requestBody = GMRequestCreateMessage(message: GMRequestCreateMessage_message(
            source_guid: UUID().uuidString,
            text: text,
            attachments: attachments
        ))
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/groups/\(group)/messages"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseCreateMessage>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response!.messsage }
        
    }
    
    // MARK: Chats
    public func getChats() -> Promise<[GMPrivateChat]> {
        let request = URLRequest(url: genURI(endpoint: "/chats"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<[GMPrivateChat]>.self, from: $0) }
            .then { $0.response! }
    }
    
    // MARK: Direct Messages
    public func getDirectMessages(forUser user: String, beforeMessage: String?, sinceMessage: String?) -> Promise<[GMDirectMessage]> {
        var queryItems = [ URLQueryItem(name: "other_user_id", value: user) ]
        if let beforeMessage = beforeMessage {
            queryItems.append(URLQueryItem(name: "before_id", value: beforeMessage))
        }
        if let sinceMessage = sinceMessage {
            queryItems.append(URLQueryItem(name: "since_id", value: sinceMessage))
        }
        let request = URLRequest(url: genURI(endpoint: "/direct_messages", queryItems: queryItems))
        
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<[GMDirectMessage]>.self, from: $0) }
            .then { $0.response! }
    }
    public func createDirectMessage(toUser user: String, withText text: String, withAttachments attachments: [GMAttachment]) -> Promise<GMDirectMessage> {
        let requestBody = GMRequestCreateDirectMessage(direct_message: GMRequestCreateMessage_message(
            source_guid: UUID().uuidString,
            text: text,
            attachments: attachments
        ))
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/direct_messages"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseCreateDirectMessage>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response!.messsage }
    }
    
    // MARK: Likes
    public func likeMessage(withId messageId: String, inConversation conversationId: String) -> Promise<Data> {
        var request = URLRequest(url: genURI(endpoint: "/messages/\(conversationId)/\(messageId)/like"))
        request.httpMethod = "POST"
        
        return promiseRequest(request: request)
    }
    public func unlikeMessage(withId messageId: String, inConversation conversationId: String) -> Promise<Data> {
        var request = URLRequest(url: genURI(endpoint: "/messages/\(conversationId)/\(messageId)/like"))
        request.httpMethod = "POST"
        
        return promiseRequest(request: request)
    }
    
    // MARK: Leaderboard
    public func topLikedMessages(inGroup group: String, forPeriod period: LeaderboardPeriod) -> Promise<[GMGroupMessage]> {
        let queryItems = [ URLQueryItem(name: "period", value: period.rawValue) ]
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)/likes", queryItems: queryItems))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseLeaderboard>.self, from: $0) }
            .then { $0.response!.messages }
    }
    public func currentUserLikes(inGroup group: String) -> Promise<[GMGroupMessage]> {
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)/likes/mine"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseLeaderboard>.self, from: $0) }
            .then { $0.response!.messages }
    }
    public func currentUserHits(inGroup group: String) -> Promise<[GMGroupMessage]> {
        let request = URLRequest(url: genURI(endpoint: "/groups/\(group)/likes/for_me"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseLeaderboard>.self, from: $0) }
            .then { $0.response!.messages }
    }
    
    // MARK: Users
    public func getCurrentUser() -> Promise<GMCurrentUser> {
        let request = URLRequest(url: genURI(endpoint: "/users/me"))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMCurrentUser>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response! }
        
    }
    public func updateCurrentUser(avatar: String?, name: String?, email: String?, zipCode: String?) -> Promise<GMCurrentUser> {
        let requestBody = GMRequestUpdateUser(avatar_url: avatar, name: name, email: email, zip_code: zipCode)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/users/update"), body: $0) }
            .then { promiseRequest(request: $0) }
            .then { try JSONDecoder().decode(GMJSONResponse<GMCurrentUser>.self, from: $0) }
            .then ( groupmeResponseErrorCheck )
            .then { $0.response! }
    }
    
    // MARK: SMS Mode
    public func enableSMS(forHours duration: Int, andDisablePushOnDeviceWithClientId registrationId: String) -> Promise<Data> {
        let requestBody = GMRequestEnableSMSMode(duration: duration, registration_id: registrationId)
        return Promise
            { try JSONEncoder().encode(requestBody) }
            .then { jsonPostRequest(self.genURI(endpoint: "/users/sms_mode"), body: $0) }
            .then { promiseRequest(request: $0) }
    }
    public func disableSMS() -> Promise<Data> {
        var request = URLRequest(url: genURI(endpoint: "/users/sms_mode/delete"))
        request.httpMethod = "POST"
        
        return promiseRequest(request: request)
    }
    
    // MARK: Blocks
    public func getBlockedUsers(for user: String) -> Promise<[GMBlock]> {
        let queryItems = [ URLQueryItem(name: "user", value: user) ]
        let request = URLRequest(url: genURI(endpoint: "/blocks", queryItems: queryItems))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseBlocks>.self, from: $0) }
            .then { $0.response!.blocks }
    }
    public func blockBetween(me currentUser: String, and otherUser: String) -> Promise<Bool> {
        let queryItems = [
            URLQueryItem(name: "user", value: currentUser),
            URLQueryItem(name: "otherUser", value: otherUser)
        ]
        let request = URLRequest(url: genURI(endpoint: "/blocks", queryItems: queryItems))
        
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseBlockBetween>.self, from: $0) }
            .then { $0.response!.between }
    }
    public func createBlock(between currentUser: String, and otherUser: String) -> Promise<GMBlock> {
        let queryItems = [
            URLQueryItem(name: "user", value: currentUser),
            URLQueryItem(name: "otherUser", value: otherUser)
        ]
        var request = URLRequest(url: genURI(endpoint: "/blocks", queryItems: queryItems))
        request.httpMethod = "POST"
        return promiseRequest(request: request)
            .then { try JSONDecoder().decode(GMJSONResponse<GMResponseCreateBlock>.self, from: $0) }
            .then { $0.response!.block }
    }
    public func removeBlock(between currentUser: String, and otherUser: String) -> Promise<Data> {
        let queryItems = [
            URLQueryItem(name: "user", value: currentUser),
            URLQueryItem(name: "otherUser", value: otherUser)
        ]
        var request = URLRequest(url: genURI(endpoint: "/blocks/delete", queryItems: queryItems))
        request.httpMethod = "POST"
        return promiseRequest(request: request)
    }
}

// MARK: Utility functions
extension GroupMeAPI {
    func genURI(endpoint: String, queryItems: [URLQueryItem] = []) -> URL {
        var queryItems = queryItems
        queryItems.append(URLQueryItem(name: "token", value: self.token))
        var urlComps = URLComponents(string: endpoint)!
        urlComps.queryItems = queryItems
        urlComps.path = "/v3\(endpoint)"
        urlComps.host = "api.groupme.com"
        urlComps.scheme = "https"
        return urlComps.url!
    }
}

fileprivate func groupmeResponseErrorCheck<T : Codable>(_ response: GMJSONResponse<T>) -> Promise<GMJSONResponse<T>> {
    return Promise { () -> GMJSONResponse<T> in
        if response.meta.errors != nil {
            throw GroupMeAPIError.groupMeErrors(errors: response.meta.errors!)
        }
        return response
    }
}

fileprivate func jsonPostRequest(_ url: URL, body: Data) -> Promise<URLRequest> {
    return Promise { () -> URLRequest in
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}

public enum GroupMeAPIError: Error {
    case noResponseData
    case groupMeErrors(errors: [String])
}

// MARK: GM Response Structures
struct GMJSONResponse<T : Codable> : Codable {
    var meta: GMResponseMeta
    var response: T?
}

struct GMResponseMeta : Codable {
    var code: Int
    var errors: [String]?
}

struct GMResponseCreateMessage : Codable {
    var messsage: GMGroupMessage
}

struct GMResponseCreateDirectMessage : Codable {
    var messsage: GMDirectMessage
}

struct GMResponseLeaderboard : Codable {
    var messages: [GMGroupMessage]
}

struct GMResponseBlocks : Codable {
    var blocks: [GMBlock]
}

struct GMResponseBlockBetween : Codable {
    var between: Bool
}

struct GMResponseCreateBlock : Codable {
    var block: GMBlock
}
