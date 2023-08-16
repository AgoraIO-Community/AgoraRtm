//
//  RtmClientDelegate+Presence.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// Represents the type of an RTM presence event.
public enum RtmPresenceEventType: Int {
    /// Unknown event type.
    case none = 0
    /// The presence snapshot of this channel.
    case snapshot = 1
    /// The presence event triggered in interval mode.
    case interval = 2
    /// Triggered when a remote user joins the channel.
    case remoteJoinChannel = 3
    /// Triggered when a remote user leaves the channel.
    case remoteLeaveChannel = 4
    /// Triggered when a remote user's connection times out.
    case remoteConnectionTimeout = 5
    /// Triggered when a user's state changes.
    case remoteStateChanged = 6
    /// Triggered when a user joins a channel without presence service.
    case errorOutOfService = 7
}

/// Represents an interval of presence event in the Agora RTM system.
public struct RtmPresenceIntervalInfo {
    /// The list of users who joined during this interval.
    public let joinUserList: [String]
    /// The list of users who left during this interval.
    public let leaveUserList: [String]
    /// The list of users whose connection timed out during this interval.
    public let timeoutUserList: [String]
    /// The dictionary of user states changed during this interval.
    public let userStateList: [String: [String: String]]

    /// Initializes an instance of `RtmPresenceIntervalInfo`.
    /// - Parameter agoraIntervalInfo: The AgoraRtmPresenceIntervalInfo object
    ///                                to extract presence interval details from.
    internal init?(_ agoraIntervalInfo: AgoraRtmPresenceIntervalInfo?) {
        guard let agoraIntervalInfo = agoraIntervalInfo else { return nil }
        self.joinUserList = agoraIntervalInfo.joinUserList
        self.leaveUserList = agoraIntervalInfo.leaveUserList
        self.timeoutUserList = agoraIntervalInfo.timeoutUserList
        self.userStateList = agoraIntervalInfo.userStateList.reduce(
            into: [String: [String: String]]()
        ) { result, userState in
            var stateDict = [String: String]()
            userState.states.forEach { keyValue in
                stateDict[keyValue.key] = keyValue.value
            }
            result[userState.userId] = stateDict
        }
    }
}

/// Represents a user state in the Agora RTM system.
public struct RtmUserState {
    /// The user ID.
    public let userId: String
    /// The dictionary of user states.
    public let states: [String: String]

    /// Initializes an instance of `RtmUserState`.
    /// - Parameter objcUserState: The AgoraRtmUserState object to extract user state details from.
    internal init(_ objcUserState: AgoraRtmUserState) {
        userId = objcUserState.userId

        var statesDict = [String: String]()
        for stateItem in objcUserState.states {
            statesDict[stateItem.key] = stateItem.value
        }
        states = statesDict
    }
}

/// Represents a presence event in the Agora RTM system.
public struct RtmPresenceEvent {
    /// The type of the presence event.
    public let type: RtmPresenceEventType
    /// The channel type of the presence event, `message` or `stream`.
    public let channelType: RtmChannelType
    /// The channel to which the presence event was triggered.
    public let channelName: String
    /// The user who triggered this event.
    public let publisher: String?
    /// The user states associated with the presence event.
    public let states: [String: String]
    /// The presence interval information. Only valid when in interval mode.
    public let interval: RtmPresenceIntervalInfo?
    /// The snapshot of presence information. Only valid when receiving a snapshot event.
    public let snapshot: [String: [String: String]]

    /// Initializes an instance of `RtmPresenceEvent`.
    /// - Parameter presence: The AgoraRtmPresenceEvent object to extract presence event details from.
    internal init(_ presence: AgoraRtmPresenceEvent) {
        self.type = .init(rawValue: presence.type.rawValue) ?? .none
        self.channelType = .init(rawValue: presence.channelType.rawValue) ?? .none
        self.channelName = presence.channelName
        self.publisher = presence.publisher
        self.states = presence.states.reduce(into: [String: String]()) { result, stateItem in
            result[stateItem.key] = stateItem.value
        }
        self.interval = .init(presence.interval)
        self.snapshot = presence.snapshot.reduce(into: [String: [String: String]]()) { result, userState in
            var stateDict = [String: String]()
            userState.states.forEach { keyValue in
                stateDict[keyValue.key] = keyValue.value
            }
            result[userState.userId] = stateDict
        }
    }
}
