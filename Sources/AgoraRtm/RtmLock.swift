//
//  File.swift
//  
//
//  Created by Max Cobb on 08/08/2023.
//

import AgoraRtmKit

public enum RtmChannelDetails {
    case none(String)
    case message(String)
    case stream(String)
    internal var objcVersion: (channelName: String, channelType: AgoraRtmChannelType) {
        switch self {
        case .none(let name):
            return (name, .none)
        case .message(let name):
            return (name, .message)
        case .stream(let name):
            return (name, .stream)
        }
    }
    /// Initializes an instance of `RtmChannelInfo`.
    ///
    /// - Parameters:
    ///   - agoraChannelInfo: The `AgoraRtmChannelInfo` instance.
    internal init(_ agoraChannelInfo: AgoraRtmChannelInfo) {
        switch agoraChannelInfo.channelType {
        case .message: self = .message(agoraChannelInfo.channelName)
        case .stream: self = .stream(agoraChannelInfo.channelName)
        case .none: self = .none(agoraChannelInfo.channelName)
        @unknown default:
            self = .none(agoraChannelInfo.channelName)
        }
    }
}

/// Represents a lock used for synchronization in Agora Real-time Messaging SDK.
public class RtmLock {
    internal let lock: AgoraRtmLock

    /// Initializes a new instance of `RtmLock`.
    /// - Parameter lock: The underlying AgoraRtmLock instance.
    init(lock: AgoraRtmLock) {
        self.lock = lock
    }

    /// Sets a lock on a specified channel.
    /// - Parameters:
    ///   - lockName: The name of the lock.
    ///   - channel: The type and name of the channel.
    ///   - ttl: The lock time-to-live in seconds.
    ///   - completion: A completion block that will be called after the operation completes.
    public func setLock(
        named lockName: String,
        forChannel channel: RtmChannelDetails,
        ttl: Int32,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.setLock(
            channelName, channelType: channelType,
            lockName: lockName,
            ttl: ttl
        ) { resp, error in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Removes a lock from a specified channel.
    /// - Parameters:
    ///   - lockName: The name of the lock.
    ///   - channel: The type and name of the channel.
    ///   - completion: A completion block that will be called after the operation completes.
    public func removeLock(
        named lockName: String,
        fromChannel channel: RtmChannelDetails,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.remove(
            channelName, channelType: channelType,
            lockName: lockName
        ) { resp, error in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Acquires a lock on a specified channel.
    /// - Parameters:
    ///   - lockName: The name of the lock.
    ///   - channel: The type and name of the channel.
    ///   - retry: Whether to automatically retry when acquiring the lock fails.
    ///   - completion: A completion block that will be called after the operation completes.
    public func acquireLock(
        named lockName: String,
        fromChannel channel: RtmChannelDetails,
        retry: Bool = false,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.acquireLock(
            channelName, channelType: channelType,
            lockName: lockName,
            retry: retry
        ) { resp, error in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Releases a lock on a specified channel.
    /// - Parameters:
    ///   - lockName: The name of the lock.
    ///   - channel: The type and name of the channel.
    ///   - completion: A completion block that will be called after the operation completes.
    public func releaseLock(
        named lockName: String,
        fromChannel channel: RtmChannelDetails,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.release(
            channelName, channelType: channelType,
            lockName: lockName
        ) { resp, error in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Disables a lock on a specified channel.
    /// - Parameters:
    ///   - lockName: The name of the lock.
    ///   - channel: The type and name of the channel.
    ///   - userId: The user ID of the lock owner.
    ///   - completion: A completion block that will be called after the operation completes.
    public func revokeLock(
        named lockName: String,
        fromChannel channel: RtmChannelDetails,
        userId: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.revokeLock(
            channelName, channelType: channelType,
            lockName: lockName,
            userId: userId
        ) { resp, error in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Gets the locks in a specified channel.
    /// - Parameters:
    ///   - channel: The type and name of the channel.
    ///   - completion: A completion block that will be called with the result.
    public func getLocks(
        forChannel channel: RtmChannelDetails,
        completion: @escaping (Result<RtmGetLocksResponse, Error>) -> Void
    ) {
        let (channelName, channelType) = channel.objcVersion
        lock.getLocks(channelName, channelType: channelType) { locks, error in
            guard let locks else {
                completion(.failure(RtmBaseErrorInfo(from: error) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(locks)))
        }
    }
}
