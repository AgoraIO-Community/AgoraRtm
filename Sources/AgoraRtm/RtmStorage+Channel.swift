//
//  File.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

extension RtmStorage {
    /// Sets the metadata of a specified channel.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be set for the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func setMetadata(
        forChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let (channelName, channelType) = channel.objcVersion
        storage.setChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: options?.objcVersion,
            lock: lock) { resp, err in
                guard let completion else { return }
                if let resp {
                    completion(.success(.init(resp)))
                    return
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            }
    }

    /// Sets the metadata of a specified channel asynchronously.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be set for the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    /// - Throws: If the operation encounters an error, it throws an `RtmBaseErrorInfo`.
    /// - Returns: The operation result, an instance of `RtmCommonResponse`.
    @available(iOS 13.0.0, *)
    public func setMetadata(
        forChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await storage.setChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: options?.objcVersion,
            lock: lock
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Updates the metadata of a specified channel.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be updated for the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func updateMetadata(
        forChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let (channelName, channelType) = channel.objcVersion
        let agoraOptions = options?.objcVersion
        storage.updateChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: agoraOptions,
            lock: lock,
            completion: { resp, err in
                guard let completion else { return }
                if let resp {
                    completion(.success(.init(resp)))
                    return
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            })
    }

    /// Updates the metadata of a specified channel asynchronously.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be set for the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains ``RtmCommonResponse``. On failure, it contains ``RtmBaseErrorInfo``.
    @available(iOS 13.0.0, *)
    public func updateMetadata(
        forChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await storage.updateChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: options?.objcVersion,
            lock: lock
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Removes the metadata of a specified channel.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be removed from the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func removeMetadata(
        fromChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let (channelName, channelType) = channel.objcVersion
        let agoraOptions = options?.objcVersion
        storage.removeChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: agoraOptions,
            lock: lock,
            completion: { resp, err in
                guard let completion else { return }
                if let resp {
                    return completion(.success(.init(resp)))
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            })
    }

    /// Removes the metadata of a specified channel asynchronously.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - data: The metadata data to be removed from the channel.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - lock: The lock for operating channel metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains ``RtmCommonResponse``. On failure, it contains ``RtmBaseErrorInfo``.
    @available(iOS 13.0.0, *)
    public func removeMetadata(
        fromChannel channel: RtmChannelDetails,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        lock: String? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (channelName, channelType) = channel.objcVersion
        let (resp, err) = await storage.removeChannelMetadata(
            channelName, channelType: channelType,
            data: metadata,
            options: options?.objcVersion,
            lock: lock
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Retrieves the metadata of a specified channel.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel.
    ///   - channelType: The channel type, either RTM_CHANNEL_TYPE_STREAM or RTM_CHANNEL_TYPE_MESSAGE.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmGetMetadataResponse, RtmBaseErrorInfo>`.
    public func getMetadata(
        forChannel channel: RtmChannelDetails,
        completion: @escaping (Result<RtmGetMetadataResponse, RtmBaseErrorInfo>) -> Void
    ) {
        let (channelName, channelType) = channel.objcVersion
        storage.getChannelMetadata(
            channelName, channelType: channelType
        ) { metadata, err in
            if let metadata {
                return completion(.success(.init(metadata)))
            }
            completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
        }
    }

    /// Gets the metadata of a specified channel asynchronously.
    ///
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains an optional ``RtmGetMetadataResponse``. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 13.0.0, *)
    public func getMetadata(
        forChannel channel: RtmChannelDetails
    ) async throws -> RtmGetMetadataResponse {
        let (channelName, channelType) = channel.objcVersion
        let (metadata, err) = await storage.channelMetadata(
            channelName, channelType: channelType
        )
        guard let metadata else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(metadata)
    }

}
