//
//  RtmClientDelegate.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// A delegate protocol for receiving Real-Time Messaging (RTM) events and notifications from the AgoraRtmKit.
public protocol RtmClientDelegate: AnyObject {
    /// Called when a message event is received.
    ///
    /// Use this method to receive and handle real-time messages from the AgoraRtmKit.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance that received the message event.
    ///   - event: The ``RtmMessageEvent`` representing the received message event.
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveMessageEvent event: RtmMessageEvent)

    /// Called when a presence event is received.
    ///
    /// Use this method to receive and handle presence events from the AgoraRtmKit.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance that received the presence event.
    ///   - event: The `RtmPresenceEvent` representing the received presence event.
    func rtmClient(_ rtmClient: RtmClientKit, didReceivePresenceEvent event: RtmPresenceEvent)

    /// Called when a lock event is received.
    ///
    /// Use this method to receive and handle lock events from the AgoraRtmKit.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance that received the lock event.
    ///   - event: The `RtmLockEvent` representing the received lock event.
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveLockEvent event: RtmLockEvent)

    /// Called when a storage event is received.
    ///
    /// Use this method to receive and handle storage events from the AgoraRtmKit.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance that received the storage event.
    ///   - event: The `RtmStorageEvent` representing the received storage event.
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveStorageEvent event: RtmStorageEvent)

    /// Called when a topic event is received.
    ///
    /// Use this method to receive and handle topic events from the AgoraRtmKit.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance that received the topic event.
    ///   - event: The `RtmTopicEvent` representing the received topic event.
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveTopicEvent event: RtmTopicEvent)

    /// Called when the token privilege is about to expire.
    ///
    /// Use this method to handle token privilege expiration. You can generate a new token and call the `renewToken` method to renew the token.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance for which the token privilege will expire.
    ///   - channel: The name of the channel where the token privilege will expire. It can be nil if the token privilege applies to the whole app.
    func rtmClient(_ rtmClient: RtmClientKit, tokenPrivilegeWillExpire channel: String?)

    /// Called when the connection state of the `RtmClientKit` changes.
    ///
    /// Use this method to handle changes in the connection state, such as connecting, reconnecting, or disconnection.
    ///
    /// - Parameters:
    ///   - rtmClient: The `RtmClientKit` instance for which the connection state changed.
    ///   - channel: The name of the channel where the connection state changed. It can be nil if the connection state applies to the whole app.
    ///   - state: The new connection state of the `RtmClientKit`.
    ///   - reason: The reason for the connection state change.
    func rtmClient(
        _ rtmClient: RtmClientKit, channel: String,
        connectionStateChanged state: RtmClientConnectionState,
        changeReason reason: RtmClientConnectionChangeReason
    )
}

// Provide default implementations for optional methods using protocol extensions
public extension RtmClientDelegate {
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveMessageEvent event: RtmMessageEvent) {}
    func rtmClient(_ rtmClient: RtmClientKit, didReceivePresenceEvent event: RtmPresenceEvent) {}
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveLockEvent event: RtmLockEvent) {}
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveStorageEvent event: RtmStorageEvent) {}
    func rtmClient(_ rtmClient: RtmClientKit, didReceiveTopicEvent event: RtmTopicEvent) {}
    func rtmClient(_ rtmClient: RtmClientKit, tokenPrivilegeWillExpire channel: String?) {}
    func rtmClient(
        _ rtmClient: RtmClientKit, channel: String,
        connectionStateChanged state: RtmClientConnectionState,
        changeReason reason: RtmClientConnectionChangeReason
    ) {}
}

extension RtmClientKit: AgoraRtmClientDelegate {
    public func rtmKit(_ rtmKit: AgoraRtmClientKit, on event: AgoraRtmMessageEvent) {
        delegate?.rtmClient(self, didReceiveMessageEvent: RtmMessageEvent(event))
    }

    public func rtmKit(_ rtmKit: AgoraRtmClientKit, on event: AgoraRtmPresenceEvent) {
        delegate?.rtmClient(self, didReceivePresenceEvent: RtmPresenceEvent(event))
    }

    public func rtmKit(_ rtmKit: AgoraRtmClientKit, on event: AgoraRtmLockEvent) {
        delegate?.rtmClient(self, didReceiveLockEvent: RtmLockEvent(event))
    }

    public func rtmKit(_ rtmKit: AgoraRtmClientKit, on event: AgoraRtmStorageEvent) {
        delegate?.rtmClient(self, didReceiveStorageEvent: RtmStorageEvent(event))
    }
//
    public func rtmKit(_ rtmKit: AgoraRtmClientKit, on event: AgoraRtmTopicEvent) {
        delegate?.rtmClient(self, didReceiveTopicEvent: RtmTopicEvent(from: event))
    }

    public func rtmKit(_ rtmKit: AgoraRtmClientKit, onTokenPrivilegeWillExpire channel: String?) {
        delegate?.rtmClient(self, tokenPrivilegeWillExpire: channel)
    }

    public func rtmKit(
        _ kit: AgoraRtmClientKit, channel channelName: String,
        connectionStateChanged state: AgoraRtmClientConnectionState,
        reason: AgoraRtmClientConnectionChangeReason
    ) {
        delegate?.rtmClient(
            self,
            channel: channelName,
            connectionStateChanged: RtmClientConnectionState(rawValue: state.rawValue) ?? .unknown,
            changeReason: RtmClientConnectionChangeReason(rawValue: reason.rawValue) ?? .unknown
        )
    }
}
