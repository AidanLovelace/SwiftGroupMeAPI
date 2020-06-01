//
//  GMRequests.swift
//  TestingEnvironment
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation
import Promises

protocol GMRequest : Codable {
    func toData() -> Promise<Data>
}

extension GMRequest {
    func toData() -> Promise<Data> {
        return Promise { try JSONEncoder().encode(self) }
    }
}

struct GMRequestCreateGroup : GMRequest {
    var name: String
    var share: Bool?
    var image_url: String?
}

struct GMRequestUpdateGroup : GMRequest {
    var name: String?
    var description: String?
    var image_url: String?
    var office_mode: Bool?
    var share: Bool?
}

struct GMRequestRejoinGroup : GMRequest {
    var group_id: String
}

struct GMRequestAddMembers : GMRequest {
    var members: [GMRequestAddMembers_NewMember]
}

public struct GMRequestAddMembers_NewMember : GMRequest {
    var nickname: String
    var user_id: String?
    var phone_number: String?
    var email: String?
    var guid: String?
}

struct GMRequestUpdateMembership: GMRequest {
    let membership: GMMembership
}

struct GMMembership: GMRequest {
    let nickname: String
}

struct GMRequestCreateMessage : GMRequest {
    var message: GMRequestCreateMessage_message
}

struct GMRequestCreateMessage_message : GMRequest {
    var source_guid: String
    var text: String
    var attachments: [GMAttachment]
}

struct GMRequestCreateDirectMessage : GMRequest {
    var direct_message: GMRequestCreateMessage_message
}

struct GMRequestCreateDirectMessage_directmessage : GMRequest {
    var source_guid: String
    var recipient_id: String
    var text: String
    var attachments: [GMAttachment]
}

struct GMRequestUpdateUser : GMRequest {
    var avatar_url: String?
    var name: String?
    var email: String?
    var zip_code: String?
}

struct GMRequestEnableSMSMode : GMRequest {
    var duration: Int
    var registration_id: String?
}
