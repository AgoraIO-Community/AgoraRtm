//
//  File.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

extension RtmStorage {
    /// Sets the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be set for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmErrorInfo>`.
    public func setUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.setUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
            }
        )
    }

    /// Sets the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be set for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains ``RtmCommonResponse``. On failure, it contains ``RtmErrorInfo``.
    @available(iOS 13.0.0, *)
    public func setUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        return try RtmClientKit.handleCompletion(await storage.setUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        ),operation: #function)
    }

    /// Updates the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be updated for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmErrorInfo>`.
    public func updateUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.updateUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
            })
    }

    /// Updates the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be updated for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmErrorInfo`.
    @available(iOS 15.0.0, *)
    public func updateUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        return try RtmClientKit.handleCompletion(await storage.updateUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        ) ,operation: #function)
    }

    /// Removes the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be removed from the user.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmErrorInfo>`.
    public func removeUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.removeUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
            })
    }

    /// Removes the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be removed from the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmErrorInfo`.
    @available(iOS 13.0.0, *)
    public func removeUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        return try RtmClientKit.handleCompletion(await storage.removeUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        ), operation: #function)
    }

    /// Retrieves the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmGetMetadataResponse, RtmErrorInfo>`.
    public func getUserMetadata(
        userId: String,
        completion: @escaping (Result<RtmGetMetadataResponse, RtmErrorInfo>) -> Void
    ) {
        storage.getUserMetadata(userId) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Gets the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains an optional `RtmMetadata`. On failure, it contains `RtmErrorInfo`.
    @available(iOS 13.0.0, *)
    public func getUserMetadata(
        userId: String
    ) async throws -> RtmGetMetadataResponse? {
        return try RtmClientKit.handleCompletion(
            await storage.userMetadata(userId), operation: #function
        )
    }

    /// Subscribes to the metadata update event of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmErrorInfo>`.
    public func subscribeUserMetadata(
        userId: String,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        storage.subscribeUserMetadata(userId) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Subscribes to the metadata update event of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmErrorInfo`.
    @available(iOS 13.0.0, *)
    public func subscribeUserMetadata(
        userId: String
    ) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await storage.subscribeUserMetadata(userId), operation: #function)
    }

    /// Unsubscribes from the metadata update event of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmErrorInfo>`.
    public func unsubscribeUserMetadata(
        userId: String,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        storage.unsubscribeUserMetadata(userId) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Unsubscribes from the metadata update event of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmErrorInfo`.
    @available(iOS 13.0.0, *)
    public func unsubscribeUserMetadata(
        userId: String
    ) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await storage.unsubscribeUserMetadata(userId), operation: #function)
    }

}
