//
//  RtmStreamChannel.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// A class that wraps an `AgoraRtmStreamChannel`, providing convenient methods to interact with the channel in the Agora RTM SDK.
open class RtmStreamChannel: NSObject {
    private let channel: AgoraRtmStreamChannel

    /// The name of the stream channel.
    public var channelName: String { channel.getName() }

    /// Initializes an ``RtmStreamChannel`` instance with the specified `AgoraRtmStreamChannel`.
    ///
    /// - Parameter channel: The `AgoraRtmStreamChannel` to wrap. Pass `nil` to create an `RtmStreamChannel` instance with no underlying channel.
    internal init?(channel: AgoraRtmStreamChannel?) {
        guard let channel else { return nil }
        self.channel = channel
        super.init()
    }

    /// Joins the stream channel with the provided `RtmJoinChannelOption`.
    ///
    /// - Parameters:
    ///   - option: The ``RtmJoinChannelOption`` to use for joining the channel.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful ``RtmCommonResponse`` or an error of type `RtmBaseErrorInfo`.
    public func join(
        with option: RtmJoinChannelOption,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, JoinErrorInfo>) -> Void)? = nil
    ) {
        channel.join(with: option.objcVersion) { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(JoinErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        }
    }

    @available(iOS 13.0.0, *)
    public func join(
        with option: RtmJoinChannelOption
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.join(with: option.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmSubscribeErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }


    /// Leaves the stream channel.
    ///
    /// - Parameter completion: An optional completion block that will be called with the result of the operation.
    ///                         The result will contain either a successful ``RtmCommonResponse`` or an error of type ``RtmBaseErrorInfo``.
    public func leave(
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, LeaveErrorInfo>) -> Void)? = nil
    ) {
        channel.leave { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(LeaveErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        }
    }

    @available(iOS 13.0.0, *)
    public func leave() async throws -> RtmCommonResponse {
        let (resp, err) = await channel.leave()
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw LeaveErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }


    /// Renews the token for the stream channel.
    ///
    /// - Parameters:
    ///   - token: The new token to renew.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful ``RtmCommonResponse`` or an error of type `RtmBaseErrorInfo`.
    public func renewToken(
        _ token: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmRenewTokenErrorInfo>) -> Void)? = nil
    ) {
        channel.renewToken(token, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(RtmRenewTokenErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        })
    }

    @available(iOS 13.0.0, *)
    public func renewToken(_ token: String) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.renewToken(token)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmRenewTokenErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Joins the stream channel with the provided ``RtmJoinChannelOption``.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to join.
    ///   - option: The ``RtmJoinTopicOption`` to use for joining the channel.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful `RtmCommonResponse` or an error of type `RtmBaseErrorInfo`.
    public func joinTopic(
        _ topic: String, with option: RtmJoinTopicOption?,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<RtmCommonResponse, JoinTopicErrorInfo>) -> Void)? = nil
    ) {
        channel.joinTopic(topic, with: option?.objcVersion, completion:  { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(JoinTopicErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        })
    }

    /// Asynchronously joins the stream channel with the provided ``RtmJoinTopicOption``.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to join.
    ///   - option: The ``RtmJoinTopicOption`` to use for joining the channel.
    /// - Returns: A ``RtmCommonResponse`` object representing the result of the operation.
    /// - Throws: An error of type ``RtmBaseErrorInfo`` if the operation fails.
    @available(iOS 13.0.0, *)
    public func joinTopic(
        _ topic: String, with option: RtmJoinTopicOption?
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.joinTopic(topic, with: option?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw JoinTopicErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Leaves the stream channel.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to leave.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful `RtmCommonResponse` or an error of type `RtmBaseErrorInfo`.
    func leaveTopic(
        _ topic: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, JoinErrorInfo>) -> Void)? = nil
    ) {
        channel.leaveTopic(topic, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(JoinErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        })
    }

    /// Asynchronously leaves the stream channel.
    ///
    /// - Parameter topic: The name of the stream channel to leave.
    /// - Returns: A `RtmCommonResponse` object representing the result of the operation.
    /// - Throws: An error of type `RtmBaseErrorInfo` if the operation fails.
    @available(iOS 13.0.0, *)
    func leaveTopic(
        _ topic: String
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.leaveTopic(topic)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmSubscribeErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Options for a topic.
    @objc public class RtmTopicOption: NSObject {
        /// The list of users to subscribe.
        @objc public var users: [String]?

        /// Fetches the Objective-C version of the `AgoraRtmTopicOption`.
        internal var objcVersion: AgoraRtmTopicOption {
            let objcOpt = AgoraRtmTopicOption()
            objcOpt.users = self.users
            return objcOpt
        }
    }

    /// Subscribes to a specific topic within the stream channel with the provided `AgoraRtmTopicOption`.
    ///
    /// - Parameters:
    ///   - topic: The name of the topic to subscribe to within the stream channel.
    ///   - option: The ``RtmTopicOption`` to use for subscribing to the topic.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful `RtmTopicSubscriptionResponse` or an error of type `RtmBaseErrorInfo`.
    func subscribe(
        toTopic topic: String, with option: RtmTopicOption?,
        completion: ((Result<RtmTopicSubscriptionResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmTopicSubscriptionResponse, SubscribeTopicErrorInfo>) -> Void)? = nil
    ) {
        channel.subscribeTopic(topic, with: option?.objcVersion, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(SubscribeTopicErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        })
    }

    @available(iOS 13.0.0, *)
    func subscribe(
        toTopic topic: String, with option: RtmTopicOption?
    ) async throws -> RtmTopicSubscriptionResponse {
        let (resp, err) = await channel.subscribeTopic(topic, with: option?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw SubscribeTopicErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    func unsubscribe(
        fromTopic topic: String, with option: RtmTopicOption?,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, UnsubscribeTopicErrorInfo>) -> Void)? = nil
    ) {
        channel.unsubscribeTopic(topic, with: option?.objcVersion, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(UnsubscribeTopicErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        })
    }

    @available(iOS 13.0.0, *)
    public func unsubscribe(
        fromTopic topic: String, with option: RtmTopicOption?
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.unsubscribeTopic(topic, with: option?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw UnsubscribeTopicErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }


    public func publishTopicMessage(
        _ message: Codable, in topic: String, with options: RtmPublishOptions?,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, PublishTopicMessageErrorInfo>) -> Void)? = nil
    ) {
        guard let nsObjectMessage = message.convertToNSObject() else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .channelInvalidMessage, operation: #function, reason: "message could not convert to NSObject")))
//            completion?(.failure(PublishTopicMessageErrorInfo(errorCode: .publishMessageFailed, operation: "publish", reason: "message could not convert to NSObject")))
            return
        }
        channel.publishTopicMessage(
            nsObjectMessage, inTopic: topic,
            withOption: options?.objcVersion,
            completion: { resp, errInfo in
                guard let completion = completion else { return }
                guard let resp = resp else {
                    return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                    return completion(.failure(PublishTopicMessageErrorInfo(from: errInfo) ?? .noKnownError))
                }
                completion(.success(.init(resp)))
            }
        )
    }

    @available(iOS 13.0.0, *)
    public func publishTopicMessage(
        message: Codable,
        inTopic topic: String, with options: RtmPublishOptions?
    ) async throws -> RtmCommonResponse {
        guard let nsObjectMessage = message.convertToNSObject() else {
            throw RtmBaseErrorInfo(errorCode: .channelInvalidMessage, operation: #function, reason: "message could not convert to NSObject")
//            throw PublishTopicMessageErrorInfo(errorCode: .publishMessageFailed, operation: "publish", reason: "message could not convert to NSObject")
        }
        let (resp, err) = await channel.publishTopicMessage(nsObjectMessage, inTopic: topic, withOption: options?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw PublishTopicMessageErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Retrieves the list of subscribed users from a stream channel.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to retrieve the list of subscribed users from.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful array of user IDs or an error of type `RtmBaseErrorInfo`.
    public func getSubscribedUserList(
        for topic: String,
        completion: ((Result<[String], RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<[String], GetSubscribersErrorInfo>) -> Void)? = nil
    ) {
        channel.getSubscribedUserList(topic, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
//                return completion(.failure(GetSubscribersErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(resp.users))
        })
    }

    /// Asynchronously retrieves the list of subscribed users from a stream channel.
    ///
    /// - Parameter topic: The name of the stream channel to retrieve the list of subscribed users from.
    /// - Returns: An array of user IDs representing the list of subscribed users.
    /// - Throws: An error of type `RtmBaseErrorInfo` if the operation fails.
    @available(iOS 13.0.0, *)
    public func getSubscribedUserList(
        for topic: String
    ) async throws -> [String] {
        let (resp, err) = await channel.subscribedUserList(topic)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw GetSubscribersErrorInfo(from: err) ?? .noKnownError
        }
        return resp.users
    }

    /// Destroys the stream channel.
    ///
    /// - Returns: The error code associated with the destruction of the channel, or `nil` if the destruction is successful.
    func destroy() -> RtmBaseErrorCode? {
        let destroyCode = channel.destroy()
        if destroyCode == .ok { return nil }
        return .init(rawValue: destroyCode.rawValue)
    }
}
