//
//  RtmClientDelegate+Messages.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// The type of an RTM channel.
public enum RtmChannelType: Int {
    /// Unknown channel type.
    case none = 0
    /// Message channel type.
    case message = 1
    /// Stream channel type.
    case stream = 2
}

/// The type of an RTM message.
public enum RtmMessageType: Int {
    /// The binary message type.
    case binary = 0
    /// The ASCII message type.
    case string = 1
    /// Unknown message type.
    case unknown = -1
}

/// A representation of an RTM message.
public struct RtmMessage {
    private let data: NSObject?
    /// The type of the message.
    public let type: RtmMessageType

    /// Initializes an instance of `RtmMessage`.
    ///
    /// - Parameters:
    ///   - data: The payload data of the message.
    ///   - type: The type of the message.
    internal init(data: NSObject?, type: RtmMessageType) {
        self.data = data
        self.type = type
    }

    /// Retrieves the payload data of the message as `Data` if possible.
    ///
    /// - Returns: The payload data of the message as `Data` if it is of type `Data`, otherwise `nil`.
    public func getData() -> Data? {
        return data as? Data
    }

    /// Initializes an instance of `RtmMessage` with the provided AgoraRtmMessage object.
    ///
    /// - Parameter agoraMessage: The AgoraRtmMessage object to extract message details from.
    internal init(_ agoraMessage: AgoraRtmMessage) {
        let type: RtmMessageType
        switch agoraMessage.getType() {
        case .string: type = .string
        case .binary: type = .binary
        @unknown default: type = .unknown
        }
        self.init(data: agoraMessage.getData(), type: type)
    }
}

/// A representation of a message event in the Agora RTM system.
public struct RtmMessageEvent {
    /// The type of channel for the message event.
    public let channelType: RtmChannelType

    /// The name of the channel where the message event was triggered.
    public let channelName: String

    /// If the channelType is `stream`, the topic from which the message originates.
    /// Only valid for the `stream` channel type.
    public let channelTopic: String?

    /// The payload of the message event.
    public let message: RtmMessage

    /// The publisher of the message event.
    public let publisher: String

    /// The custom type of the message event.
    public let customType: String?

    /// Initializes an instance of `RtmMessageEvent` with the provided AgoraRtmMessageEvent object.
    ///
    /// - Parameter messageEvent: The AgoraRtmMessageEvent object to extract message event details from.
    internal init(_ messageEvent: AgoraRtmMessageEvent) {
        self.channelType = .init(rawValue: messageEvent.channelType.rawValue) ?? .none
        self.channelName = messageEvent.channelName
        self.channelTopic = messageEvent.channelTopic
        self.message = .init(messageEvent.message)
        self.publisher = messageEvent.publisher
        self.customType = messageEvent.customType
    }
}
