//
//  File.swift
//  
//
//  Created by Max Cobb on 08/08/2023.
//

import AgoraRtmKit

@available(iOS 13.0, *)
public extension RtmPresence {

    /// Asynchronously queries users currently in a specified channel.
    ///
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    ///   - options: Options for the query, including what information to include in the result.
    /// - Returns: An ``RtmOnlineUsersResponse`` object with the currently online users and their states.
    func getOnlineUsers(
        in channel: RtmChannelDetails, options: RtmPresenceOptions? = nil
    ) async throws -> RtmOnlineUsersResponse {
        let (channelName, channelType) = channel.objcVersion
        return try RtmClientKit.handleCompletion(await self.presence.whoNow(
            channelName, channelType: channelType,
            options: options?.objcVersion
        ), operation: #function)
    }

    /// Asynchronously queries which channels a user is currently in.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    /// - Returns: A ``RtmUserChannelsResponse`` object with either the query response.
    func getUserChannels(for userId: String) async throws -> RtmUserChannelsResponse {
        return try RtmClientKit.handleCompletion(await self.presence.whereNow(userId), operation: #function)
    }

    /// > Renamed: ``getOnlineUsers(in:options:)``
    @available(*, deprecated, renamed: "getOnlineUsers(in:options:)")
    func whoNow(
        inChannel channel: RtmChannelDetails,
        options: RtmPresenceOptions? = nil
    ) async throws -> RtmOnlineUsersResponse {
        try await self.getOnlineUsers(in: channel, options: options)
    }
    /// > Renamed: ``getUserChannels(for:)``
    @available(*, deprecated, renamed: "getUserChannels(for:)")
    func whereNow(userId: String) async throws -> RtmUserChannelsResponse {
        try await self.getUserChannels(for: userId)
    }

    /// Asynchronously sets the local user's state within a specified channel.
    ///
    /// - Parameters:
    ///   - channel: The details of the channel in which the state needs to be set.
    ///   - states: A dictionary containing the states to be set for the local user within the channel.
    ///
    /// - Returns:
    ///   A `RtmCommonResponse` indicating the result of the state setting operation.
    ///
    /// Use this method to set the local user's state within a channel. Until the user subscribes or joins
    /// the specified channel, the provided state data is cached on the client-side. Once the user takes action
    /// to join or subscribe, the state data is immediately activated, which can subsequently trigger relevant
    /// event notifications.
    ///
    /// - Throws: An ``RtmErrorInfo`` error if the state update operation encounters any problems.
    func setUserState(
        inChannel channel: RtmChannelDetails,
        to states: [String: String]
    ) async throws -> RtmCommonResponse {
        let (channelName, channelType) = channel.objcVersion
        return try RtmClientKit.handleCompletion(await self.presence.setState(
            channelName, channelType: channelType,
            items: states.map {
                let stateItem = AgoraRtmStateItem()
                stateItem.key = $0.key
                stateItem.value = $0.value
                return stateItem
            }
        ), operation: #function)
    }

    /// Asynchronously removes specified state entries of the local user from a given channel.
    ///
    /// - Parameters:
    ///   - channel: The details of the channel from which state entries need to be removed.
    ///   - keys: An array of keys representing the state entries to be removed.
    ///   - completion: An optional callback that returns the result of the state removal operation.
    /// - Returns: A `Result` object with either the operation response or an error.
    func removeUserState(
        inChannel channel: RtmChannelDetails,
        keys: [String]
    ) async throws -> RtmCommonResponse {
        let (channelName, channelType) = channel.objcVersion
        return try RtmClientKit.handleCompletion(await self.presence.removeState(
            channelName, channelType: channelType,
            items: keys
        ), operation: #function)
    }

    /// Asynchronously gets user state for a specified user in a channel.
    ///
    /// - Parameters:
    ///   - userId: The ID of the user.
    ///   - channel: The type and name of the channel.
    /// - Returns: A `Result` object with either the query response or an error.
    func getState(
        ofUser userId: String,
        inChannel channel: RtmChannelDetails
    ) async throws -> RtmPresenceGetStateResponse {
        let (channelName, channelType) = channel.objcVersion
        return try RtmClientKit.handleCompletion(await self.presence.state(
            channelName, channelType: channelType,
            userId: userId
        ), operation: #function)
    }
}
