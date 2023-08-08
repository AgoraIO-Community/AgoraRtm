//
//  File.swift
//  
//
//  Created by Max Cobb on 08/08/2023.
//

import AgoraRtmKit

@available(iOS 13.0, *)
public extension RtmPresence {
    /// Asynchronously queries who is currently in a specified channel.
    ///
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    ///   - options: Options for the query, including what information to include in the result.
    /// - Returns: A `Result` object with either the query response or an error.
    func whoNow(
        inChannel channel: RtmChannelDetails,
        options: RtmPresenceOptions? = nil
    ) async throws -> RtmWhoNowResponse {
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await self.presence.whoNow(
            channelName, channelType: channelType,
            options: options?.objcVersion
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Asynchronously queries which channels a user is currently in.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    /// - Returns: A `Result` object with either the query response or an error.
    func whereNow(userId: String) async throws -> RtmWhereNowResponse {
        let (resp, err) = await self.presence.whereNow(userId)
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Asynchronously sets user state.
    ///
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    ///   - items: The state items of the user.
    /// - Returns: A `Result` object with either the operation response or an error.
    func setState(
        ofChannel channel: RtmChannelDetails,
        items: [String: String]
    ) async throws -> RtmCommonResponse {
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await self.presence.setState(
            channelName, channelType: channelType,
            items: items.map {
                let stateItem = AgoraRtmStateItem()
                stateItem.key = $0.key
                stateItem.value = $0.value
                return stateItem
            }
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Asynchronously deletes user state.
    ///
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    ///   - keys: The keys of the state items to delete.
    /// - Returns: A `Result` object with either the operation response or an error.
    func removeState(
        channelName channel: RtmChannelDetails,
        keys: [String]
    ) async throws -> RtmCommonResponse {
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await self.presence.removeState(
            channelName, channelType: channelType,
            items: keys
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Asynchronously gets user state for a specified user in a channel.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - channel: The type and name of the channel.
    /// - Returns: A `Result` object with either the query response or an error.
    func getState(
        ofUser userId: String,
        fromChannel channel: RtmChannelDetails
    ) async throws -> RtmPresenceGetStateResponse {
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await self.presence.state(
            channelName, channelType: channelType,
            userId: userId
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }
}

