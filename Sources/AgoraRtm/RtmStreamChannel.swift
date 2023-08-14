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
    /// - Parameter channel: The `AgoraRtmStreamChannel` to wrap. Pass `nil` to create
    ///                      an `RtmStreamChannel` instance with no underlying channel.
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
    ) {
        channel.join(with: option.objcVersion) { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
//                return completion(.failure(JoinErrorInfo(from: errInfo) ?? .noKnownError))
            }
            completion(.success(.init(resp)))
        }
    }

    /// Asynchronously joins a channel with specified options.
    ///
    /// Use this method to join a channel with the desired settings, allowing more granular control over channel behavior.
    ///
    /// - Parameter option: The configuration options for joining the channel, encapsulated in an ``RtmJoinChannelOption`` object.
    ///
    /// - Throws: ``RtmBaseErrorInfo`` if an error occurs during the join attempt.
    ///
    /// - Returns: A response confirming the result of the join attempt, encapsulated in an ``RtmCommonResponse`` object.
    @available(iOS 13.0.0, *)
    public func join(
        with option: RtmJoinChannelOption
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.join(with: option.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }


    /// Leaves the stream channel.
    ///
    /// - Parameter completion: An optional completion block that will be called with the result of the operation.
    ///                         The result will contain either a successful ``RtmCommonResponse`` or an error of type ``RtmBaseErrorInfo``.
    public func leave(
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        channel.leave { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
            }
            completion(.success(.init(resp)))
        }
    }

    @available(iOS 13.0.0, *)
    public func leave() async throws -> RtmCommonResponse {
        let (resp, err) = await channel.leave()
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
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
    ) {
        channel.renewToken(token, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
            }
            completion(.success(.init(resp)))
        })
    }

    @available(iOS 13.0.0, *)
    public func renewToken(_ token: String) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.renewToken(token)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
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
    ) {
        channel.joinTopic(topic, with: option?.objcVersion, completion:  { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
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
    @discardableResult @available(iOS 13.0.0, *)
    public func joinTopic(
        _ topic: String, with option: RtmJoinTopicOption?
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.joinTopic(topic, with: option?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Leaves the stream channel.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to leave.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful ``RtmCommonResponse``
    ///                 or an error of type ``RtmBaseErrorInfo``.
    public func leaveTopic(
        _ topic: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        channel.leaveTopic(topic, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
            }
            completion(.success(.init(resp)))
        })
    }

    /// Asynchronously leaves the stream channel.
    ///
    /// - Parameter topic: The name of the stream channel to leave.
    /// - Returns: A ``RtmCommonResponse`` object representing the result of the operation.
    /// - Throws: An error of type ``RtmBaseErrorInfo`` if the operation fails.
    @discardableResult @available(iOS 13.0.0, *)
    public func leaveTopic(
        _ topic: String
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.leaveTopic(topic)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Subscribes to messages from specified users within a topic.
    ///
    /// This method lets you receive messages from a list of specific users in a given topic.
    ///
    /// - Parameters:
    ///   - topic: The topic name to be subscribed to.
    ///   - options: Subscription options using ``RtmTopicOption``, including users to subscribe to.
    ///              Use `nil` to subscribe to all.
    ///   - completion: An optional completion handler that returns either a successful response
    ///                 (``RtmTopicSubscriptionResponse``) or an error (``RtmBaseErrorInfo``). Defaults to nil.
    public func subscribe(
        toTopic topic: String, withOptions options: RtmTopicOption? = nil,
        completion: ((Result<RtmTopicSubscriptionResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        channel.subscribeTopic(topic, with: options?.objcVersion, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
            }
            completion(.success(.init(resp)))
        })
    }

    /// Asynchronously subscribes to messages from specified users within a topic.
    ///
    /// - Parameters:
    ///   - topic: The topic name to be subscribed to.
    ///   - options: Subscription options using ``RtmTopicOption``, including users to subscribe to.
    ///              Use `nil` to subscribe to all.
    ///
    /// - Returns:
    ///   A result that either provides a successful response ``RtmTopicSubscriptionResponse``
    ///   or throws an error ``RtmBaseErrorInfo``.
    @discardableResult @available(iOS 13.0.0, *)
    public func subscribe(
        toTopic topic: String, withOptions options: RtmTopicOption? = nil
    ) async throws -> RtmTopicSubscriptionResponse {
        let (resp, err) = await channel.subscribeTopic(topic, with: options?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Unsubscribes from specified users' messages within a topic.
    ///
    /// This method allows you to stop receiving messages from a list of specified users within a given topic.
    ///
    /// - Parameters:
    ///   - topic: The topic name to be unsubscribed from.
    ///   - options: Subscription options using ``RtmTopicOption``, including users to unsubscribe to.
    ///              Use `nil` to unsubscribe to all.
    ///   - completion: An optional completion handler that returns either a successful response ``RtmCommonResponse``
    ///                 or an error ``RtmBaseErrorInfo``.
    public func unsubscribe(
        fromTopic topic: String, withOptions options: RtmTopicOption? = nil,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        channel.unsubscribeTopic(topic, with: options?.objcVersion, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ?? .noKnownError(operation: #function)))
            }
            completion(.success(.init(resp)))
        })
    }

    /// Asynchronously unsubscribes from messages from specified users within a topic.
    ///
    /// - Parameters:
    ///   - topic: The topic name to be unsubscribed from.
    ///   - options: Subscription options using ``RtmTopicOption``, including users to unsubscribe to.
    ///              Use `nil` to unsubscribe to all.
    ///
    /// - Returns:
    ///   A result that either provides a successful response ``RtmCommonResponse``
    ///   or throws an error ``RtmBaseErrorInfo``.
    @discardableResult @available(iOS 13.0.0, *)
    public func unsubscribe(
        fromTopic topic: String, withOptions options: RtmTopicOption? = nil
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await channel.unsubscribeTopic(topic, with: options?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Publishes a message to a specified topic asynchronously.
    ///
    /// - Parameters:
    ///   - message: The message to be published. Must be `Codable`.
    ///   - topic: The name of the topic to which the message will be published.
    ///   - options: Optional configurations for publishing the message. Defaults to `nil`.
    ///   - completion: A completion block that returns a result containing an ``RtmCommonResponse`` or ``RtmBaseErrorInfo``.
    public func publishTopicMessage(
        _ message: Codable, in topic: String, with options: RtmPublishOptions?,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        let msgString: String
        do {
            msgString = try message.convertToString()
        } catch let error as RtmBaseErrorInfo {
            completion?(.failure(error))
            return
        } catch {
            completion?(.failure(RtmBaseErrorInfo(
                errorCode: .channelInvalidMessage, operation: #function,
                reason: "could not encode message: \(error.localizedDescription)"
            )))
            return
        }
        channel.publishTopicMessage(
            msgString as NSString, inTopic: topic,
            withOption: options?.objcVersion,
            completion: { resp, errInfo in
                guard let completion = completion else { return }
                guard let resp = resp else {
                    return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                        .noKnownError(operation: #function)))
                }
                completion(.success(.init(resp)))
            }
        )
    }

    /// Publishes a message to a specified topic.
    ///
    /// This function allows you to publish a message to a topic.
    ///
    /// - Parameters:
    ///   - message: The message to be published. Must be `Codable`.
    ///   - topic: The name of the topic to which the message will be published.
    ///   - options: Optional configurations for publishing the message. Defaults to `nil`.
    ///
    /// - Returns: An ``RtmCommonResponse`` containing information about the published message.
    ///
    /// - Throws: ``RtmBaseErrorInfo`` if an error occurs during the publishing process.
    @discardableResult @available(iOS 13.0.0, *)
    public func publishTopicMessage(
        message: Codable,
        inTopic topic: String, with options: RtmPublishOptions?
    ) async throws -> RtmCommonResponse {
        let msgString: String
        do {
            msgString = try message.convertToString()
        } catch let error as RtmBaseErrorInfo {
            throw error
        } catch {
            throw RtmBaseErrorInfo(
                errorCode: .channelInvalidMessage, operation: #function,
                reason: "could not encode message: \(error.localizedDescription)"
            )
        }
        let (resp, err) = await channel.publishTopicMessage(
            msgString as NSString, inTopic: topic, withOption: options?.objcVersion
        )
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
        }
        return .init(resp)
    }

    /// Retrieves the list of subscribed users from a stream channel.
    ///
    /// - Parameters:
    ///   - topic: The name of the stream channel to retrieve the list of subscribed users from.
    ///   - completion: An optional completion block that will be called with the result of the operation.
    ///                 The result will contain either a successful array of user IDs or an error of type ``RtmBaseErrorInfo``.
    public func getSubscribedUserList(
        forTopic topic: String,
        completion: ((Result<[String], RtmBaseErrorInfo>) -> Void)? = nil
    ) {
        channel.getSubscribedUserList(topic, completion: { resp, errInfo in
            guard let completion = completion else { return }
            guard let resp = resp else {
                return completion(.failure(RtmBaseErrorInfo(from: errInfo) ??
                    .noKnownError(operation: #function)))
            }
            completion(.success(resp.users))
        })
    }

    /// Asynchronously retrieves the list of subscribed users from a stream channel.
    ///
    /// - Parameter topic: The name of the stream channel to retrieve the list of subscribed users from.
    /// - Returns: An array of user IDs representing the list of subscribed users.
    /// - Throws: An error of type ``RtmBaseErrorInfo`` if the operation fails.
    @available(iOS 13.0.0, *)
    public func getSubscribedUserList(
        forTopic topic: String
    ) async throws -> [String] {
        let (resp, err) = await channel.subscribedUserList(topic)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
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

/// Options for subscribing and unsubscribing to a topic
@objc public class RtmTopicOption: NSObject {
    /// The list of users to subscribe to or unsubscribe from.
    /// Use `nil` to apply to all users in a topic
    @objc public var users: [String]?
    /// Fetches the Objective-C version of the `AgoraRtmTopicOption`.
    internal var objcVersion: AgoraRtmTopicOption {
        let objcOpt = AgoraRtmTopicOption()
        objcOpt.users = self.users
        return objcOpt
    }

    /// Creates an instance of ``RtmTopicOption`` with the provided parameters.
    /// - Parameter users: The list of users to subscribe to or unsubscribe from.
    ///                    Use `nil` to apply to all users in a topic
    @objc public init(users: [String]? = nil) {
        self.users = users
    }
}
