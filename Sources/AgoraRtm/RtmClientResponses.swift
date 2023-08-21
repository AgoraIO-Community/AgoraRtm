//
//  RtmClientResponses.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

internal protocol RtmResponseProtocol {
    associatedtype ResponseType

    var response: ResponseType { get }
    init(_ response: ResponseType)
}

public class RtmCommonResponse: RtmResponseProtocol {
    internal let response: AgoraRtmCommonResponse

    required internal init(_ response: AgoraRtmCommonResponse) {
        self.response = response
    }
}

public class RtmTopicSubscriptionResponse: RtmResponseProtocol {
    internal let response: AgoraRtmTopicSubscriptionResponse

    public var succeedUsers: [String] {
        return response.succeedUsers
    }

    public var failedUsers: [String] {
        return response.failedUsers
    }

    required internal init(_ response: AgoraRtmTopicSubscriptionResponse) {
        self.response = response
    }
}

/// Represents a metadata item associated with an RTM message.
public class RtmMetadataItem {

    internal var agoraMetadataItem: AgoraRtmMetadataItem

    /// The key of the metadata item.
    public var key: String {
        get { return agoraMetadataItem.key }
        set { agoraMetadataItem.key = newValue }
    }

    /// The value of the metadata item.
    public var value: String {
        get { return agoraMetadataItem.value }
        set { agoraMetadataItem.value = newValue }
    }

    /// The User ID of the user who made the latest update to the metadata item.
    public var authorUserId: String {
        get { return agoraMetadataItem.authorUserId }
        set { agoraMetadataItem.authorUserId = newValue }
    }

    /// The revision of the metadata item.
    public var revision: Int64 {
        get { return agoraMetadataItem.revision }
        set { agoraMetadataItem.revision = newValue }
    }

    /// The timestamp when the metadata item was last updated.
    public var updateTs: UInt64 {
        get { return agoraMetadataItem.updateTs }
        set { agoraMetadataItem.updateTs = newValue }
    }

    /// Initializes an instance of `RtmMetadataItem` with an `AgoraRtmMetadataItem` object.
    ///
    /// - Parameter agoraMetadataItem: The `AgoraRtmMetadataItem` object to initialize from.
    internal init(_ agoraMetadataItem: AgoraRtmMetadataItem) {
        self.agoraMetadataItem = agoraMetadataItem
    }
}

/// Represents metadata associated with an RTM message.
public class RtmMetadata {

    internal var agoraMetadata: AgoraRtmMetadata?

    /// The major revision of metadata.
    public var majorRevision: Int64 {
        get { return agoraMetadata?.getMajorRevision() ?? 0 }
        set { agoraMetadata?.setMajorRevision(newValue) }
    }

    /// The array of metadata items of the current metadata.
    public var metadataItems: [RtmMetadataItem] {
        return agoraMetadata?.getItems().map { RtmMetadataItem($0) } ?? []
    }

    /// Initializes an instance of `RtmMetadata` with an `AgoraRtmMetadata` object.
    ///
    /// - Parameter agoraMetadata: The `AgoraRtmMetadata` object to initialize from.
    internal init?(_ agoraMetadata: AgoraRtmMetadata?) {
        guard let agoraMetadata else { return nil }
        self.agoraMetadata = agoraMetadata
    }

    /// Add or revise a metadata item to the current metadata.
    ///
    /// - Parameter item: The RtmMetadataItem to set.
    public func setMetadataItem(_ item: RtmMetadataItem) {
        agoraMetadata?.setMetadataItem(item.agoraMetadataItem)
    }

    /// Clear the array of metadata items and reset the major revision.
    public func clearMetadata() {
        agoraMetadata?.clear()
    }

    /// Destroy the metadata instance.
    ///
    /// - Returns: An integer indicating the result of the operation.
    public func destroy() -> Int32 {
        let destResp = agoraMetadata?.destroy() ?? 0
        self.agoraMetadata = nil
        return destResp
    }
}

/// Represents the response received from a metadata retrieval operation in Agora RTM.
public class RtmGetMetadataResponse: RtmResponseProtocol {
    internal let response: AgoraRtmGetMetadataResponse

    /// The metadata retrieved from the response.
    public var data: RtmMetadata? {
        return .init(response.data)
    }

    required internal init(_ response: AgoraRtmGetMetadataResponse) {
        self.response = response
    }
}

/// Represents the response received from a locks retrieval operation in Agora RTM.
public class RtmGetLocksResponse: RtmResponseProtocol {
    internal let response: AgoraRtmGetLocksResponse

    /// The list of lock details retrieved from the response.
    public lazy var lockDetailList: [RtmLockDetail] = {
        return response.lockDetailList.map { .init($0) }
    }()

    required internal init(_ response: AgoraRtmGetLocksResponse) {
        self.response = response
    }
}

/// Represents the response received from an online users retrieval operation in Agora RTM.
public class RtmOnlineUsersResponse: RtmResponseProtocol {
    internal let response: AgoraRtmWhoNowResponse

    /// The total count of online users, this may be larger than ``users`` count.
    public var totalOccupancy: Int32 {
        return response.totalOccupancy
    }

    /// A dictionary containing user IDs and their corresponding state dictionaries.
    public lazy var userStateList: [String: [String: String]] = {
        response.userStateList.reduce(into: [String: [String: String]]()) { result, userState in
            var stateDict = [String: String]()
            userState.states.forEach { keyValue in
                stateDict[keyValue.key] = keyValue.value
            }
            result[userState.userId] = stateDict
        }
    }()

    /// An array containing the user IDs of online users.
    public var users: [String] {
        Array(userStateList.keys)
    }

    /// The next page indicator for paginated responses.
    public var nextPage: String? {
        return response.nextPage
    }

    required internal init(_ response: AgoraRtmWhoNowResponse) {
        self.response = response
    }
}

/// > Renamed: ``RtmOnlineUsersResponse``
@available(*, deprecated, renamed: "RtmOnlineUsersResponse")
public typealias RtmWhoNowResponse = RtmOnlineUsersResponse

/// Represents the response received from a user's joined channel retrieval operation in Agora RTM.
public class RtmUserChannelsResponse: RtmResponseProtocol {
    internal let response: AgoraRtmWhereNowResponse

    /// The count of channels to which the user is subscribed.
    public var subscribedChannelCount: Int32 {
        return response.totalChannel
    }

    /// The list of channel details representing the user's subscribed channels.
    public lazy var channels: [RtmChannelDetails] = {
        return response.channels.map { .init($0) }
    }()

    required internal init(_ response: AgoraRtmWhereNowResponse) {
        self.response = response
    }
}

/// > Renamed: ``RtmUserChannelsResponse``
@available(*, deprecated, renamed: "RtmUserChannelsResponse")
public typealias RtmWhereNowResponse = RtmUserChannelsResponse

/// Represents the response received from a user's presence state retrieval operation in Agora RTM.
public class RtmPresenceGetStateResponse: RtmResponseProtocol {
    internal let response: AgoraRtmPresenceGetStateResponse

    /// The dictionary containing the presence states of the user.
    public var states: [String: String] {
        return response.state.states.reduce(into: [String: String]()) { result, keyValue in
            result[keyValue.key] = keyValue.value
        }
    }

    /// The user ID associated with the presence state.
    public var userId: String {
        return response.state.userId
    }

    required internal init(_ response: AgoraRtmPresenceGetStateResponse) {
        self.response = response
    }
}
