//
//  GMProtocol.swift
//  TestingEnvironment
//
//  Created by Aidan Lovelace on 5/31/20.
//  Copyright © 2020 Aidan Lovelace. All rights reserved.
//

import Foundation
import Promises

protocol GroupMeAPIProtocol {
    // MARK: Groups
    /**
     List the authenticated user's active groups.
     */
    func getGroups() -> Promise<[GMGroup]>
    
    /**
     List the groups the authenticated user has left but can rejoin.
     */
    func getFormerGroups() -> Promise<[GMGroup]>
    
    /**
     Load a specific group
     */
    func getGroup(withId group: String) -> Promise<GMGroup>
    
    /**
     Create a new group
     
     - Parameter name: Primary name of the group. Maximum 140 characters
     - Parameter description: A subheading for the group. Maximum 255 characters
     - Parameter image_url: GroupMe Image Service URL
     - Parameter share: If you pass a true value for share, we'll generate a share URL. Anybody with this URL can join the group.
     */
    func createGroup(name: String, share: Bool, image_url: String?) -> Promise<GMGroup>
    
    /**
     Update a group after creation
     
     - Parameter group: The id of the group to update
     - Parameter name: Primary name of the group. Maximum 140 characters
     - Parameter description: A subheading for the group. Maximum 255 characters
     - Parameter image_url: GroupMe Image Service URL
     - Parameter office_mode
     - Parameter share: If you pass a true value for share, we'll generate a share URL. Anybody with this URL can join the group.
     */
    func updateGroup(withId group: String, name: String?, description: String?, image_url: String?, office_mode: Bool?, share: Bool?) -> Promise<GMGroup>
    
    /**
     Disband a group
     
     This action is only available to the group creator / owner
     
     - Parameter group: The id of the group to destroy
     */
    func destroyGroup(withId group: String) -> Promise<Data>
    
    /**
     Join a shared group
     
     - Parameter group: The id of the group to join
     - Parameter shareToken: The share token
     */
    func joinGroup(withId group: String, andShareToken shareToken: String) -> Promise<GMGroup>
    
    /**
     Rejoin a group. Only works the user had previously removed themselves.
     
     - Parameter group: The id of the group to rejoin
     */
    func rejoinGroup(withId group: String) -> Promise<GMGroup>
    
    // TODO: Implement changing group owners
    
    // MARK: Group Membership
    
    /**
     Add members to a group.
     
     Multiple members can be added in a single request, and results are fetched with a separate call (since memberships are processed asynchronously). The response includes a results_id that's used in the results request.
     
     In order to correlate request params with resulting memberships, GUIDs can be added to the members parameters. These GUIDs will be reflected in the membership JSON objects.
     
     - Parameter members: array — `nickname` is required. You must use one of the following identifiers: `user_id`, `phone_number`, or `email`.
     */
    func addMembers(_ members: [GMRequestAddMembers_NewMember], toGroup group: String) -> Promise<GMResponseAddMembers>
    
    /**
     Get the membership results from an add call.
     
     Successfully created memberships will be returned, including any GUIDs that were sent up in the add request. If GUIDs were absent, they are filled in automatically. Failed memberships and invites are omitted.
     
     Keep in mind that results are temporary -- they will only be available for 1 hour after the add request.
     
     - Parameter results_id: The results_id given by the response to an addMembers call
     - Parameter group: The group this is for
     */
    func getMembershipResults(withId results_id: String, forGroup group: String) -> Promise<Any>
    
    /**
     Remove a member (or the current user) from a group.
     
     Note: The creator of the group cannot be removed or exit.
     
     - Parameter membershipId: Please note that this isn't the same as the user ID.
     - Parameter group: The group from which to remove this member.
     */
    func removeMember(withId membershipId: String, fromGroup group: String) -> Promise<Data>
    
    /**
     Update the user's nickname in a group.
     
     - Parameter newNickname: The new nickname; Must be between 1 and 50 characters.
     - Parameter group: The group in which to change the nickname.
     */
    func updateNickname(to newNickname: String, forGroup group: String) -> Promise<GMGroupMember>
    
    // MARK: Messages
    /**
     Retrieve messages for a group.

     By default, messages are returned in groups of 20, ordered by created_at descending. This can be raised or lowered by passing a limit parameter, up to a maximum of 100 messages.

     Messages can be scanned by providing a message ID as either the before_id, since_id, or after_id parameter. If before_id is provided, then messages immediately preceding the given message will be returned, in descending order. This can be used to continually page back through a group's messages.

     The after_id parameter will return messages that immediately follow a given message, this time in ascending order (which makes it easy to pick off the last result for continued pagination).

     Finally, the since_id parameter also returns messages created after the given message, but it retrieves the most recent messages. For example, if more than twenty messages are created after the since_id message, using this parameter will omit the messages that immediately follow the given message. This is a bit counterintuitive, so take care.

     If no messages are found (e.g. when filtering with before_id) we return code 304.

     Note that for historical reasons, likes are returned as an array of user ids in the favorited_by key.
     
     - Parameter beforeMessage: Returns messages created before the given message ID
     - Parameter sinceMessage: Returns most recent messages created after the given message ID
     - Parameter afterMessage: Returns messages created immediately after the given message ID
     - Parameter limit: Number of messages returned. Default is 20. Max is 100.
     */
    func getMessages(forGroup group: String, beforeMessage: String?, sinceMessage: String?, afterMessage: String?, withLimit limit: Int) -> Promise<[GMGroupMessage]>
    
    /**
     Send a message to a group

     If you want to attach an image, you must first process it through our image service.

     Attachments of type emoji rely on data from emoji PowerUps.

     Clients use a placeholder character in the message text and specify a replacement charmap to substitute emoji characters

     The character map is an array of arrays containing rune data ([[{pack_id,offset}],...]).

     The placeholder should be a high-point/invisible UTF-8 character.
     
     - Parameter text: This can be omitted if at least one attachment is present. The maximum length is 1,000 characters.
     - Parameter attachments: A polymorphic list of attachments (locations, images, etc). You may have more than one of any type of attachment, provided clients can display it.
     */
    func createMessage(inGroup group: String, withText text: String, withAttachments attachments: [GMAttachment]) -> Promise<GMGroupMessage>
    
    // MARK: Chats
    /**
     Returns a paginated list of direct message chats, or conversations, sorted by updated_at descending.
     */
    func getChats() -> Promise<[GMPrivateChat]>
    
    // MARK: Direct Messages
    /**
     Fetch direct messages between two users.

     DMs are returned in groups of 20, ordered by created_at descending.

     If no messages are found (e.g. when filtering with since_id) we return code 304.

     Note that for historical reasons, likes are returned as an array of user ids in the favorited_by key.
     
     - Parameter user: The other participant in the conversation.
     - Parameter beforeMessage: Returns 20 messages created before the given message ID
     - Parameter sinceMessage: Returns 20 messages created after the given message ID
     */
    func getDirectMessages(forUser user: String, beforeMessage: String?, sinceMessage: String?) -> Promise<[GMDirectMessage]>
    
    /**
     Send a DM to another user

     If you want to attach an image, you must first process it through our image service.

     Attachments of type emoji rely on data from emoji PowerUps.

     Clients use a placeholder character in the message text and specify a replacement charmap to substitute emoji characters

     The character map is an array of arrays containing rune data ([[{pack_id,offset}],...]).
     
     - Parameter user: The GroupMe user ID of the recipient of this message.
     - Parameter text: This can be omitted if at least one attachment is present.
     - Parameter attachments: A polymorphic list of attachments (locations, images, etc). You may have You may have more than one of any type of attachment, provided clients can display it.
     */
    func createDirectMessage(toUser user: String, withText text: String, withAttachments attachments: [GMAttachment]) -> Promise<GMDirectMessage>
    
    // MARK: Likes
    /**
     Like a message.
     */
    func likeMessage(withId messageId: String, inConversation conversationId: String) -> Promise<Data>
    /**
     Unlike a message.
     */
    func unlikeMessage(withId messageId: String, inConversation conversationId: String) -> Promise<Data>
    
    // MARK: Leaderboard
    /**
     A list of the liked messages in the group for a given period of time. Messages are ranked in order of number of likes.
     */
    func topLikedMessages(inGroup group: String, forPeriod period: LeaderboardPeriod) -> Promise<[GMGroupMessage]>
    
    /**
     A list of messages you have liked. Messages are returned in reverse chrono-order. Note that the payload includes a liked_at timestamp in ISO-8601 format.
     */
    func currentUserLikes(inGroup group: String) -> Promise<[GMGroupMessage]>
    /**
     A list of messages others have liked.
     */
    func currentUserHits(inGroup group: String) -> Promise<[GMGroupMessage]>
    
    // MARK: Users
    /**
     Get details about the authenticated user
     */
    func getCurrentUser() -> Promise<GMCurrentUser>
    /**
     Update attributes about your own account
     */
    func updateCurrentUser(avatar: String?, name: String?, email: String?, zipCode: String?) -> Promise<GMCurrentUser>
    
    // MARK: SMS Mode
    /**
     Enables SMS mode for N hours, where N is at most 48. After N hours have elapsed, user will receive push notfications.
     */
    func enableSMS(forHours duration: Int, andDisablePushOnDeviceWithClientId registrationId: String) -> Promise<Data>
    /**
     Disables SMS mode
     */
    func disableSMS() -> Promise<Data>
    
    // MARK: Blocks
    /**
     A list of contacts you have blocked. These people cannot DM you.
     */
    func getBlockedUsers(for user: String) -> Promise<[GMBlock]>
    /**
     Asks if a block exists between you and another user id
     */
    func blockBetween(me currentUser: String, and otherUser: String) -> Promise<Bool>
    /**
     Creates a block between you and the contact
     */
    func createBlock(between currentUser: String, and otherUser: String) -> Promise<GMBlock>
    /**
     Removes block between you and other user
     */
    func removeBlock(between currentUser: String, and otherUser: String) -> Promise<Data>
}

public enum LeaderboardPeriod : String {
    case day = "day"
    case week = "week"
    case month = "month"
}
