//
//  GMJSONStructs.swift
//  TestingEnvironment
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation

// MARK: - Group
struct GMGroup: Codable {
    let id, groupID, name, phoneNumber: String
    let type: GMGroupType
    let groupDescription: String?
    let imageURL: String?
    let creatorUserID: String
    let createdAt, updatedAt: Int
    let mutedUntil: Int?
    let officeMode: Bool
    let shareURL, shareQrCodeURL: String?
    let members: [GMGroupMember]
    let messages: GMGroup_Messages
    let maxMembers: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case groupID = "group_id"
        case name
        case phoneNumber = "phone_number"
        case type
        case groupDescription = "description"
        case imageURL = "image_url"
        case creatorUserID = "creator_user_id"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case mutedUntil = "muted_until"
        case officeMode = "office_mode"
        case shareURL = "share_url"
        case shareQrCodeURL = "share_qr_code_url"
        case members, messages
        case maxMembers = "max_members"
    }
}

enum GMGroupType: String, Codable {
    case closed = "closed"
    case typePrivate = "private"
}

struct GMGroupMember: Codable {
    let userID, nickname: String
    let imageURL: String?
    let id: String
    let muted, autokicked: Bool
    let roles: [GMGroupMember_Role]
    let name: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname
        case imageURL = "image_url"
        case id, muted, autokicked, roles, name
    }
}

enum GMGroupMember_Role: String, Codable {
    case admin = "admin"
    case owner = "owner"
    case user = "user"
}

struct GMGroup_Messages: Codable {
    let count: Int
    let lastMessageID: String?
    let lastMessageCreatedAt: Int?
    let preview: GMGroup_Preview
    
    enum CodingKeys: String, CodingKey {
        case count
        case lastMessageID = "last_message_id"
        case lastMessageCreatedAt = "last_message_created_at"
        case preview
    }
}

struct GMGroup_Preview: Codable {
    let nickname, text: String?
    let imageURL: String?
    let attachments: [GMAttachment]
    
    enum CodingKeys: String, CodingKey {
        case nickname, text
        case imageURL = "image_url"
        case attachments
    }
}


// MARK: - Group Messages
struct GMResponseGroupMessages: Codable {
    let count: Int
    let messages: [GMGroupMessage]
}

struct GMGroupMessage: Codable {
    let attachments: [GMAttachment]
    let avatarURL: String?
    let createdAt: Int
    let favoritedBy: [String]
    let groupID, id: String
    let name: String
    let senderID: String
    let senderType: GMSenderType
    let sourceGUID: String
    let system: Bool
    let text: String?
    let userID: String
    let platform: String
    let event: GMGroupMessage_Event?
    
    enum CodingKeys: String, CodingKey {
        case attachments
        case avatarURL = "avatar_url"
        case createdAt = "created_at"
        case favoritedBy = "favorited_by"
        case groupID = "group_id"
        case id, name
        case senderID = "sender_id"
        case senderType = "sender_type"
        case sourceGUID = "source_guid"
        case system, text
        case userID = "user_id"
        case platform, event
    }
}

enum GMSenderType: String, Codable {
    case system = "system"
    case user = "user"
    case service = "service"
}

// MARK: - GMAttachment
struct GMAttachment: Codable {
    let charmap: [[Int]]?
    let placeholder: String?
    let type: String
    let eventID, view, pollID: String?
    let url: String?
    let lat, lng, name: String?
    
    enum CodingKeys: String, CodingKey {
        case charmap, placeholder, type
        case eventID = "event_id"
        case view
        case pollID = "poll_id"
        case url, lat, lng, name
    }
}

// MARK: - Special Attachments (events)
struct GMGroupMessage_Event: Codable {
    let type: String
    let data: GMGroupMessage_Event_Data
}

struct GMGroupMessage_Event_Data: Codable {
    let event: GMGroupMessageEventTypeEvent?
    let user: GMUser
    let conversation: GMGroupMessage_Event_Data_Conversation?
    let poll: GMGroupMessageEventTypePoll?
    let url: String?
}

struct GMUser: Codable {
    let id: String
    let nickname: String
}

struct GMGroupMessage_Event_Data_Conversation: Codable {
    let id: String
}

// Event Attachment
struct GMGroupMessageEventTypeEvent: Codable {
    let id, name: String
}

// Poll Attachment
struct GMGroupMessageEventTypePoll: Codable {
    let id, subject: String
}

struct GroupMessagesResponse : Codable {
    var count: Int
    var messages: [GMGroupMessage]
}


// MARK: - Private Chats
struct GMPrivateChat: Codable {
    let createdAt: Int
    let lastMessage: GMPrivateChat_LastMessage
    let messagesCount: Int
    let otherUser: GMPrivateChat_OtherUser
    let updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case messagesCount = "messages_count"
        case otherUser = "other_user"
        case updatedAt = "updated_at"
    }
}

struct GMPrivateChat_LastMessage: Codable {
    let attachments: [GMAttachment]
    let avatarURL: String
    let conversationID: String
    let createdAt: Int
    let favoritedBy: [String]
    let id, name, recipientID, senderID: String
    let senderType, sourceGUID, text, userID: String
    
    enum CodingKeys: String, CodingKey {
        case attachments
        case avatarURL = "avatar_url"
        case conversationID = "conversation_id"
        case createdAt = "created_at"
        case favoritedBy = "favorited_by"
        case id, name
        case recipientID = "recipient_id"
        case senderID = "sender_id"
        case senderType = "sender_type"
        case sourceGUID = "source_guid"
        case text
        case userID = "user_id"
    }
}

struct GMPrivateChat_OtherUser: Codable {
    let avatarURL: String
    let id, name: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case id, name
    }
}

// MARK: - DirectMessages
struct GMDirectMessagesResponse: Codable {
    let count: Int
    let directMessages: [GMDirectMessage]
    let readReceipt: GMReadReceipt

    enum CodingKeys: String, CodingKey {
        case count
        case directMessages = "direct_messages"
        case readReceipt = "read_receipt"
    }
}

// MARK: - GMDirectMessage
struct GMDirectMessage: Codable {
    let attachments: [GMAttachment]
    let avatarURL: String
    let conversationID: String
    let createdAt: Int
    let favoritedBy: [String]
    let id: String
    let name: String
    let recipientID, senderID: String
    let senderType: GMSenderType
    let sourceGUID: String
    let text: String?
    let userID: String
    let event: GMGroupMessage_Event?

    enum CodingKeys: String, CodingKey {
        case attachments
        case avatarURL = "avatar_url"
        case conversationID = "conversation_id"
        case createdAt = "created_at"
        case favoritedBy = "favorited_by"
        case id, name
        case recipientID = "recipient_id"
        case senderID = "sender_id"
        case senderType = "sender_type"
        case sourceGUID = "source_guid"
        case text
        case userID = "user_id"
        case event
    }
}

struct GMReadReceipt: Codable {
    let id: String
    let chatID: String
    let messageID, userID: String
    let readAt: Int

    enum CodingKeys: String, CodingKey {
        case id
        case chatID = "chat_id"
        case messageID = "message_id"
        case userID = "user_id"
        case readAt = "read_at"
    }
}


struct GMResponseJoinGroup : Codable {
    var group: GMGroup
}

struct GMResponseAddMembers : Codable {
    var results_id: String
}

struct GMResponseMembershipResults : Codable {
    var members: [GMResponseMembershipResults_Member]
}

struct GMResponseMembershipResults_Member : Codable {
    var id: String
    var user_id: String
    var nickname: String
    var muted: Bool
    var image_url: String
    var autokicked: Bool
    var app_installed: Bool
    var guid: String
}

// MARK: Current User
struct GMCurrentUser: Codable {
    let createdAt: Int
    let email: String
    let facebookConnected: Bool
    let id: String
    let imageURL: String
    let locale, name, phoneNumber: String
    let sms, twitterConnected: Bool
    let updatedAt: Int
    let userID: String
    let zipCode: String?
    let shareURL, shareQrCodeURL: String
    let mfa: GMMutliFactorAuthenticationData
    let tags: [String]
    let promptForSurvey, showAgeGate: Bool
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case email
        case facebookConnected = "facebook_connected"
        case id
        case imageURL = "image_url"
        case locale, name
        case phoneNumber = "phone_number"
        case sms
        case twitterConnected = "twitter_connected"
        case updatedAt = "updated_at"
        case userID = "user_id"
        case zipCode = "zip_code"
        case shareURL = "share_url"
        case shareQrCodeURL = "share_qr_code_url"
        case mfa, tags
        case promptForSurvey = "prompt_for_survey"
        case showAgeGate = "show_age_gate"
    }
}

struct GMMutliFactorAuthenticationData: Codable {
    let enabled: Bool
    let channels: [GMMutliFactorAuthenticationChannel]
}

struct GMMutliFactorAuthenticationChannel: Codable {
    let type: String
    let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case createdAt = "created_at"
    }
}

// MARK: Blocks
struct GMBlock: Codable {
    let userID, blockedUserID: String
    let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case blockedUserID = "blocked_user_id"
        case createdAt = "created_at"
    }
}
