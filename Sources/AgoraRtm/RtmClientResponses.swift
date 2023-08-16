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
    // You can add properties if needed, but this class doesn't have any specific properties in the Objective-C counterpart.
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
    public init?(_ agoraMetadata: AgoraRtmMetadata?) {
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

public class RtmGetMetadataResponse: RtmResponseProtocol {
    internal let response: AgoraRtmGetMetadataResponse

    public var data: RtmMetadata? {
        return .init(response.data)
    }

    required init(_ response: AgoraRtmGetMetadataResponse) {
        self.response = response
    }
}

public class RtmGetLocksResponse: RtmResponseProtocol {
    internal let response: AgoraRtmGetLocksResponse

    public lazy var lockDetailList: [RtmLockDetail] = {
        return response.lockDetailList.map { .init($0) }
    }()

    required internal init(_ response: AgoraRtmGetLocksResponse) {
        self.response = response
    }
}

public class RtmOnlineUsersResponse: RtmResponseProtocol {
    internal let response: AgoraRtmWhoNowResponse

    public var totalOccupancy: Int32 {
        return response.totalOccupancy
    }

    public var userStateList: [String: [String: String]] {
        response.userStateList.reduce(into: [String: [String: String]]()) { result, userState in
            var stateDict = [String: String]()
            userState.states.forEach { keyValue in
                stateDict[keyValue.key] = keyValue.value
            }
            result[userState.userId] = stateDict
        }
    }

    public var nextPage: String? {
        return response.nextPage
    }

    required internal init(_ response: AgoraRtmWhoNowResponse) {
        self.response = response
    }
}

@available(*, deprecated, renamed: "RtmOnlineUsersResponse")
public typealias RtmWhoNowResponse = RtmOnlineUsersResponse


public class RtmUserChannelsResponse: RtmResponseProtocol {
    internal let response: AgoraRtmWhereNowResponse

    public var totalChannel: Int32 {
        return response.totalChannel
    }

    public lazy var channels: [RtmChannelDetails] = {
        return response.channels.map { .init($0) }
    }()

    required internal init(_ response: AgoraRtmWhereNowResponse) {
        self.response = response
    }
}

@available(*, deprecated, renamed: "RtmUserChannelsResponse")
public typealias RtmWhereNowResponse = RtmUserChannelsResponse

public class RtmPresenceGetStateResponse: RtmResponseProtocol {
    internal let response: AgoraRtmPresenceGetStateResponse

    public var states: [String: String] {
        return response.state.states.reduce(into: [String: String]()) { result, keyValue in
            result[keyValue.key] = keyValue.value
        }
    }

    required internal init(_ response: AgoraRtmPresenceGetStateResponse) {
        self.response = response
    }
}
