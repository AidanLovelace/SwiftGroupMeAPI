//
//  GMJSONStructs.swift
//  TestingEnvironment
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation

// MARK: - Group
public struct GMGroup: Codable {
    public let id, groupID, name, phoneNumber: String
    public let type: GMGroupType
    public let groupDescription: String?
    public let imageURL: String?
    public let creatorUserID: String
    public let createdAt, updatedAt: Int
    public let mutedUntil: Int?
    public let officeMode: Bool
    public let shareURL, shareQrCodeURL: String?
    public let members: [GMGroupMember]
    public let messages: GMGroup_Messages
    public let maxMembers: Int
    
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

public enum GMGroupType: String, Codable {
    case closed = "closed"
    case typePrivate = "private"
}

public struct GMGroupMember: Codable {
    public let userID, nickname: String
    public let imageURL: String?
    public let id: String
    public let muted, autokicked: Bool
    public let roles: [GMGroupMember_Role]
    public let name: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case nickname
        case imageURL = "image_url"
        case id, muted, autokicked, roles, name
    }
}

public enum GMGroupMember_Role: String, Codable {
    case admin = "admin"
    case owner = "owner"
    case user = "user"
}

public struct GMGroup_Messages: Codable {
    public let count: Int
    public let lastMessageID: String?
    public let lastMessageCreatedAt: Int?
    public let preview: GMGroup_Preview
    
    enum CodingKeys: String, CodingKey {
        case count
        case lastMessageID = "last_message_id"
        case lastMessageCreatedAt = "last_message_created_at"
        case preview
    }
}

public struct GMGroup_Preview: Codable {
    public let nickname, text: String?
    public let imageURL: String?
    public let attachments: [GMAttachment]
    
    enum CodingKeys: String, CodingKey {
        case nickname, text
        case imageURL = "image_url"
        case attachments
    }
}


// MARK: - Group Messages
public struct GMResponseGroupMessages: Codable {
    public let count: Int
    public let messages: [GMGroupMessage]
}

public struct GMGroupMessage: Codable {
    public let attachments: [GMAttachment]
    public let avatarURL: String?
    public let createdAt: Int
    public let favoritedBy: [String]
    public let groupID, id: String
    public let name: String
    public let senderID: String
    public let senderType: GMSenderType
    public let sourceGUID: String
    public let system: Bool
    public let text: String?
    public let userID: String
    public let platform: String
    public let event: GMGroupMessage_Event?
    
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

public enum GMSenderType: String, Codable {
    case system = "system"
    case user = "user"
    case service = "service"
}

// MARK: - GMAttachment
public struct GMAttachment: Codable {
    public let charmap: [[Int]]?
    public let placeholder: String?
    public let type: String
    public let eventID, view, pollID: String?
    public let url: String?
    public let lat, lng, name: String?
    
    enum CodingKeys: String, CodingKey {
        case charmap, placeholder, type
        case eventID = "event_id"
        case view
        case pollID = "poll_id"
        case url, lat, lng, name
    }
}

// MARK: - Special Attachments (events)
public struct GMGroupMessage_Event: Codable {
    public let type: String
    public let data: GMGroupMessage_Event_Data
}

public struct GMGroupMessage_Event_Data: Codable {
    public let event: GMGroupMessageEventTypeEvent?
    public let user: GMUser
    public let conversation: GMGroupMessage_Event_Data_Conversation?
    public let poll: GMGroupMessageEventTypePoll?
    public let url: String?
}

public struct GMUser: Codable {
    public let id: String
    public let nickname: String
}

public struct GMGroupMessage_Event_Data_Conversation: Codable {
    public let id: String
}

// Event Attachment
public struct GMGroupMessageEventTypeEvent: Codable {
    public let id, name: String
}

// Poll Attachment
public struct GMGroupMessageEventTypePoll: Codable {
    public let id, subject: String
}

public struct GroupMessagesResponse : Codable {
    public var count: Int
    public var messages: [GMGroupMessage]
}


// MARK: - Private Chats
public struct GMPrivateChat: Codable {
    public let createdAt: Int
    public let lastMessage: GMPrivateChat_LastMessage
    public let messagesCount: Int
    public let otherUser: GMPrivateChat_OtherUser
    public let updatedAt: Int
    
    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case lastMessage = "last_message"
        case messagesCount = "messages_count"
        case otherUser = "other_user"
        case updatedAt = "updated_at"
    }
}

public struct GMPrivateChat_LastMessage: Codable {
    public let attachments: [GMAttachment]
    public let avatarURL: String
    public let conversationID: String
    public let createdAt: Int
    public let favoritedBy: [String]
    public let id, name, recipientID, senderID: String
    public let senderType, sourceGUID, text, userID: String
    
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

public struct GMPrivateChat_OtherUser: Codable {
    public let avatarURL: String
    public let id, name: String
    
    enum CodingKeys: String, CodingKey {
        case avatarURL = "avatar_url"
        case id, name
    }
}

// MARK: - DirectMessages
public struct GMDirectMessagesResponse: Codable {
    public let count: Int
    public let directMessages: [GMDirectMessage]
    public let readReceipt: GMReadReceipt

    enum CodingKeys: String, CodingKey {
        case count
        case directMessages = "direct_messages"
        case readReceipt = "read_receipt"
    }
}

// MARK: - GMDirectMessage
public struct GMDirectMessage: Codable {
    public let attachments: [GMAttachment]
    public let avatarURL: String
    public let conversationID: String
    public let createdAt: Int
    public let favoritedBy: [String]
    public let id: String
    public let name: String
    public let recipientID, senderID: String
    public let senderType: GMSenderType
    public let sourceGUID: String
    public let text: String?
    public let userID: String
    public let event: GMGroupMessage_Event?

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

public struct GMReadReceipt: Codable {
    public let id: String
    public let chatID: String
    public let messageID, userID: String
    public let readAt: Int

    enum CodingKeys: String, CodingKey {
        case id
        case chatID = "chat_id"
        case messageID = "message_id"
        case userID = "user_id"
        case readAt = "read_at"
    }
}


public struct GMResponseJoinGroup : Codable {
    public var group: GMGroup
}

public struct GMResponseAddMembers : Codable {
    public var results_id: String
}

public struct GMResponseMembershipResults : Codable {
    public var members: [GMResponseMembershipResults_Member]
}

public struct GMResponseMembershipResults_Member : Codable {
    public var id: String
    public var user_id: String
    public var nickname: String
    public var muted: Bool
    public var image_url: String
    public var autokicked: Bool
    public var app_installed: Bool
    public var guid: String
}

// MARK: Current User
public struct GMCurrentUser: Codable {
    public let createdAt: Int
    public let email: String
    public let facebookConnected: Bool
    public let id: String
    public let imageURL: String
    public let locale, name, phoneNumber: String
    public let sms, twitterConnected: Bool
    public let updatedAt: Int
    public let userID: String
    public let zipCode: String?
    public let shareURL, shareQrCodeURL: String
    public let mfa: GMMutliFactorAuthenticationData
    public let tags: [String]
    public let promptForSurvey, showAgeGate: Bool
    
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

public struct GMMutliFactorAuthenticationData: Codable {
    public let enabled: Bool
    public let channels: [GMMutliFactorAuthenticationChannel]
}

public struct GMMutliFactorAuthenticationChannel: Codable {
    public let type: String
    public let createdAt: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case createdAt = "created_at"
    }
}

// MARK: Blocks
public struct GMBlock: Codable {
    public let userID, blockedUserID: String
    public let createdAt: Int

    enum CodingKeys: String, CodingKey {
        case userID = "user_id"
        case blockedUserID = "blocked_user_id"
        case createdAt = "created_at"
    }
}
