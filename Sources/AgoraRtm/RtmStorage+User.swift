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
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func setUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.setUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                guard let completion else { return }
                if let resp {
                    completion(.success(.init(resp)))
                    return
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            }
        )
    }

    /// Sets the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be set for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains ``RtmCommonResponse``. On failure, it contains ``RtmBaseErrorInfo``.
    @available(iOS 13.0.0, *)
    public func setUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (resp, err) = await storage.setUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Updates the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be updated for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func updateUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.updateUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                guard let completion else { return }
                if let resp {
                    completion(.success(.init(resp)))
                    return
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            })
    }

    /// Updates the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be updated for the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 15.0.0, *)
    public func updateUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (resp, err) = await storage.updateUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Removes the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be removed from the user.
    ///   - options: The options for operating the metadata. Default is nil.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func removeUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        guard let metadata = data.agoraMetadata else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")))
            return
        }
        let agoraOptions = options?.objcVersion
        storage.removeUserMetadata(
            userId,
            data: metadata,
            options: agoraOptions,
            completion: { resp, err in
                guard let completion else { return }
                if let resp {
                    completion(.success(.init(resp)))
                    return
                }
                completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
            })
    }

    /// Removes the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - data: The metadata data to be removed from the user.
    ///   - options: The options for operating the metadata. Default is nil.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 13.0.0, *)
    public func removeUserMetadata(
        userId: String,
        data: RtmMetadata,
        options: RtmMetadataOptions? = nil
    ) async throws -> RtmCommonResponse {
        guard let metadata = data.agoraMetadata else {
            throw RtmBaseErrorInfo(errorCode: .storageInvalidMetadataItem, operation: #function, reason: "bad metadata")
        }
        let (resp, err) = await storage.removeUserMetadata(
            userId,
            data: metadata,
            options: options?.objcVersion
        )
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Retrieves the metadata of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmGetMetadataResponse, RtmBaseErrorInfo>`.
    public func getUserMetadata(
        userId: String,
        completion: @escaping (Result<RtmGetMetadataResponse, RtmBaseErrorInfo>) -> Void
    ) {
        storage.getUserMetadata(userId) { metadata, err in
            if let metadata {
                completion(.success(.init(metadata)))
                return
            }
            completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
        }
    }

    /// Gets the metadata of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains an optional `RtmMetadata`. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 13.0.0, *)
    public func getUserMetadata(
        userId: String
    ) async throws -> RtmGetMetadataResponse? {
        let (metadata, err) = await storage.userMetadata(userId)
        guard let metadata else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return RtmGetMetadataResponse(metadata)
    }

    /// Subscribes to the metadata update event of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func subscribeUserMetadata(
        userId: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        storage.subscribeUserMetadata(userId) { resp, err in
            guard let completion else { return }
            if let resp {
                completion(.success(.init(resp)))
                return
            }
            completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
        }
    }

    /// Subscribes to the metadata update event of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 13.0.0, *)
    public func subscribeUserMetadata(
        userId: String
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await storage.subscribeUserMetadata(userId)
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Unsubscribes from the metadata update event of a specified user.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    ///   - completion: The completion handler to be called with the operation result, `Result<RtmCommonResponse, RtmBaseErrorInfo>`.
    public func unsubscribeUserMetadata(
        userId: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        storage.unsubscribeUserMetadata(userId) { resp, err in
            guard let completion else { return }
            if let resp {
                completion(.success(.init(resp)))
                return
            }
            completion(.failure(.init(from: err) ?? .noKnownError(operation: #function)))
        }
    }

    /// Unsubscribes from the metadata update event of a specified user asynchronously.
    ///
    /// - Parameters:
    ///   - userId: The user ID of the specified user.
    /// - Returns: A `Result` indicating the operation's success or failure. On success, it contains `RtmCommonResponse`. On failure, it contains `RtmBaseErrorInfo`.
    @available(iOS 13.0.0, *)
    public func unsubscribeUserMetadata(
        userId: String
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await storage.unsubscribeUserMetadata(userId)
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

}
