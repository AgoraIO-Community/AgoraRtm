//
//  RtmClientKit.swift
//
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

internal extension Encodable {
    /// Converts a Codable object to an NSObject.
    ///
    /// - Parameter codableValue: The Codable object to convert.
    /// - Returns: The converted NSObject or `nil` if the conversion fails.
    func convertToNSObject() -> NSObject? {
        let data = try? JSONEncoder().encode(self)
        if let data = data {
            return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? NSObject
        }
        return nil
    }

}

/// A class that serves as a client-side real-time communication kit.
///
/// It uses the Agora real-time communication client `AgoraRtmClientKit` to handle
/// operations such as logging in/out, token renewal, subscribing to/unsubscribing from
/// channels, message publishing, and more.
open class RtmClientKit: NSObject {

    /// The Agora real-time communication client.
    internal let agoraRtmClient: AgoraRtmClientKit

    /// The storage used by the Agora RTM client.
    public lazy var storage: RtmStorage? = { .init(storage: agoraRtmClient.getStorage()) }()

    /// The lock used by the Agora RTM client.
    public var lock: AgoraRtmLock? { agoraRtmClient.getLock() }

    /// The presence information used by the Agora RTM client.
    public var presence: RtmPresence? { .init(agoraRtmClient.getPresence()) }

    /// The delegate for handling Real-Time Messaging (RTM) events.
    public weak var delegate: RtmClientDelegate?

    /// Creates a new instance of `RtmClientKit`.
    ///
    /// - Parameters:
    ///   - config: Configuration for the Agora RTM client.
    ///   - delegate: The delegate for the Agora RTM client.
    public init?(config: RtmClientConfig, delegate: RtmClientDelegate) {
        guard let rtmClient = AgoraRtmClientKit(
            config: config.config, delegate: nil
        ) else { return nil }
        self.delegate = delegate
        self.agoraRtmClient = rtmClient
        super.init()
        agoraRtmClient.agoraRtmDelegate = self
    }

    /// The delegate for the Agora RTM client.
    public var agoraRtmDelegate: AgoraRtmClientDelegate? {
        get { agoraRtmClient.agoraRtmDelegate }
        set { agoraRtmClient.agoraRtmDelegate = newValue }
    }

    /// Logs into the Agora RTM system.
    ///
    /// - Parameters:
    ///   - token: The token to log in with.
    ///   - completion: The completion handler to call when the login operation is complete.
    public func login(
        byToken token: String?,
        completion: ((Result<AgoraRtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmLoginErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.login(byToken: token) { loginResp, loginErr in
            guard let completion = completion else { return }
            guard let response = loginResp else {
                completion(.failure(RtmBaseErrorInfo(from: loginErr) ?? .noKnownError(operation: #function)))
//                completion(.failure(RtmLoginErrorInfo(from: loginErr) ?? .noKnownError))
                return
            }
            completion(.success(response))
        }
    }

    /// Asynchronously logs into the Agora RTM system.
    ///
    /// - Parameter token: The token to log in with.
    /// - Returns: A ``RtmCommonResponse`` if the login is successful, otherwise throws an ``RtmBaseErrorInfo`` error.
    @available(iOS 13.0.0, *)
    public func login(byToken token: String? = nil) async throws -> RtmCommonResponse {
        let (loginResp, err) = await agoraRtmClient.login(byToken: token)
        if let response = loginResp {
            return .init(response)
        }
        throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//        throw RtmLoginErrorInfo(from: err) ?? RtmLoginErrorInfo.noKnownError
    }

    /// Logs out of the Agora RTM system.
    ///
    /// - Parameter completion: The completion handler to call when the logout operation is complete.
    public func logout(
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmLogoutErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.logout() { resp, logoutErr in
            guard let completion = completion else { return }
            guard let resp else {
                completion(.failure(RtmBaseErrorInfo(from: logoutErr) ?? .noKnownError(operation: #function)))
//                completion(.failure(RtmLogoutErrorInfo(from: logoutErr) ?? .noKnownError))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Asynchronously logs out of the Agora RTM system.
    ///
    /// This method can throw an ``RtmBaseErrorInfo`` error if the logout operation fails.
    @available(iOS 13.0.0, *)
    public func logout() async throws -> RtmCommonResponse {
        let (resp, err) = await agoraRtmClient.logout()
        guard let resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmLogoutErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Renews the token for the Agora RTM client.
    ///
    /// - Parameters:
    ///   - token: The new token to renew.
    ///   - completion: The completion handler to call when the token renewal operation is complete.
    public func renewToken(
        _ token: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmRenewTokenErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.renewToken(token) { resp, renewErr in
            guard let completion = completion else { return }
            guard let resp = resp else {
                completion(.failure(RtmBaseErrorInfo(from: renewErr) ?? .noKnownError(operation: #function)))
//                completion(.failure(RtmRenewTokenErrorInfo(from: renewErr) ?? .noKnownError))
                return
            }
            completion(.success(.init(resp)))
        }
    }
    /// Asynchronously renews the token for the Agora RTM client.
    ///
    /// - Parameters:
    ///   - token: The new token to renew.
    ///
    /// This method can throw a ``RtmBaseErrorInfo`` error if the token renewal operation fails.
    @available(iOS 13.0.0, *)
    public func renewToken(_ token: String) async throws -> RtmCommonResponse {
        let (resp, err) = await agoraRtmClient.renewToken(token)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmRenewTokenErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// A set of options for subscribing to specific features in the Agora Real-Time Messaging (RTM) system.
    /// You can use these options to customize your subscription behavior.
    ///
    /// Create an instance of ``RtmSubscribeFeatures`` by combining the individual options using the `OptionSet` syntax.
    /// For example:
    /// ```
    /// let subscriptionOptions: RtmSubscribeFeatures = [.withMessage, .withMetadata]
    /// ```
    ///
    /// Once you have the desired subscription options, you can convert them to the corresponding `AgoraRtmSubscribeOptions`
    /// object using the `toObjectiveC()` method.
    ///
    /// - Note: These options correspond to the options available in the `AgoraRtmSubscribeOptions` Objective-C class.
    /// - SeeAlso: ``RtmClientKit/subscribe(toChannel:features:completion)``
    public struct RtmSubscribeFeatures: OptionSet {
        public let rawValue: UInt

        /// Subscribe to channels with messages.
        ///
        /// This option allows you to receive messages sent to the subscribed channels.
        public static let messages = RtmSubscribeFeatures(rawValue: 1 << 0)

        /// Subscribe to channels with metadata.
        ///
        /// This option allows you to receive metadata updates for the subscribed channels.
        public static let metadata = RtmSubscribeFeatures(rawValue: 1 << 1)

        /// Subscribe to channels with user presence updates.
        ///
        /// This option allows you to receive presence updates for the users in the subscribed channels.
        public static let presence = RtmSubscribeFeatures(rawValue: 1 << 2)

        /// Subscribe to channels with lock updates.
        ///
        /// This option allows you to receive updates about channel locks in the subscribed channels.
        public static let lock = RtmSubscribeFeatures(rawValue: 1 << 3)

        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }

        /// Converts the `RtmSubscribeFeatures` to the corresponding `AgoraRtmSubscribeOptions` object.
        ///
        /// - Returns: The `AgoraRtmSubscribeOptions` object with the subscription options set based on the ``RtmClientKit/RtmSubscribeFeatures``.
        internal var objcVersion: AgoraRtmSubscribeOptions {
            let objcOpt = AgoraRtmSubscribeOptions()
            objcOpt.withMessage = self.contains(.messages)
            objcOpt.withMetadata = self.contains(.metadata)
            objcOpt.withPresence = self.contains(.presence)
            objcOpt.withLock = self.contains(.lock)
            return objcOpt
        }
    }

    /// Subscribes to a channel with the provided name and options.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to subscribe to.
    ///   - features: The options for subscribing to the channel.
    ///   - completion: The completion handler to call when the subscription operation is complete.
    ///   This handler takes one argument, ``RtmCommonResponse``,
    ///   which indicates the response of the subscription operation.
    public func subscribe(
        toChannel channelName: String,
        features: RtmSubscribeFeatures = [],
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmSubscribeErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.subscribe(withChannel: channelName, option: features.objcVersion) { resp, subErr in
            guard let completion = completion else { return }
            guard let resp = resp else {
                completion(.failure(RtmBaseErrorInfo(from: subErr) ?? .noKnownError(operation: #function)))
//                completion(.failure(RtmSubscribeErrorInfo(from: subErr) ?? .noKnownError))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Asynchronously subscribes to a channel with the provided name and options.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to subscribe to.
    ///   - option: The options for subscribing to the channel.
    ///
    /// This method can throw a ``RtmCommonResponse`` error if the subscription operation fails.
    @available(iOS 13.0.0, *)
    public func subscribe(
        toChannel channelName: String, option: RtmSubscribeFeatures = []
    ) async throws -> RtmCommonResponse {
        let (resp, err) = await agoraRtmClient.subscribe(withChannel: channelName, option: option.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmSubscribeErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Unsubscribes from a channel with the provided name.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to unsubscribe from.
    ///   - completion: The completion handler to call when the unsubscription operation is complete.
    ///   This handler takes one argument, ``RtmCommonResponse``,
    ///   which indicates the response of the unsubscription operation.
    public func unsubscribe(
        fromChannel channelName: String,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmUnsubscribeErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.unsubscribe(withChannel: channelName) { resp, subErr in
            guard let completion = completion else { return }
            guard let resp = resp else {
                completion(.failure(RtmBaseErrorInfo(from: subErr) ?? .noKnownError(operation: #function)))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Asynchronously unsubscribes from a channel with the provided name.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to unsubscribe from.
    ///
    /// This method can throw a ``RtmCommonResponse`` error if the unsubscription operation fails.
    @available(iOS 13.0.0, *)
    public func unsubscribe(fromChannel channelName: String) async throws -> RtmCommonResponse {
        let (resp, err) = await agoraRtmClient.unsubscribe(withChannel: channelName)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmUnsubscribeErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Publishes a message in the specified channel.
    ///
    /// - Parameters:
    ///   - message: The message to publish.
    ///   - channelName: The name of the channel to publish the message to.
    ///   - publishOption: The options for publishing the message.
    ///   - completion: The completion handler to call when the publish operation is complete.
    ///   This handler takes one argument, ``RtmCommonResponse``,
    ///   which indicates the response of the publish operation.
    public func publish(
        message: Codable,
        to channelName: String,
        withOption publishOption: RtmPublishOptions?,
        completion: ((Result<RtmCommonResponse, RtmBaseErrorInfo>) -> Void)? = nil
//        completion: ((Result<AgoraRtmCommonResponse, RtmPublishErrorInfo>) -> Void)? = nil
    ) {
        guard let msg = message.convertToNSObject() else {
            completion?(.failure(RtmBaseErrorInfo(errorCode: .channelInvalidMessage, operation: #function, reason: "message could not convert to NSObject")))
//            completion?(.failure(RtmPublishErrorInfo(errorCode: .publishMessageFailed, operation: "publish", reason: "message could not convert to NSObject")))
            return
        }
        agoraRtmClient.publish(channelName, message: msg, withOption: publishOption?.objcVersion) { resp, pubErr in
            guard let completion = completion else { return }
            guard let resp = resp else {
                completion(.failure(RtmBaseErrorInfo(from: pubErr) ?? .noKnownError(operation: #function)))
//                completion(.failure(RtmPublishErrorInfo(from: pubErr) ?? .noKnownError))
                return
            }
            completion(.success(.init(resp)))
        }
    }

    /// Asynchronously publishes a message in the specified channel.
    ///
    /// - Parameters:
    ///   - message: The message to publish.
    ///   - channelName: The name of the channel to publish the message to.
    ///   - publishOption: The options for publishing the message.
    ///
    /// This method can throw an ``RtmBaseErrorInfo`` error if the publish operation fails.
    @available(iOS 13.0.0, *)
    public func publish(message: Codable, to channelName: String, withOption publishOption: RtmPublishOptions?) async throws -> RtmCommonResponse {
        guard let msg = message.convertToNSObject() else {
            throw RtmBaseErrorInfo(errorCode: .channelInvalidMessage, operation: #function, reason: "message could not convert to NSObject")
//            throw RtmPublishErrorInfo(errorCode: .publishMessageFailed, operation: "publish", reason: "could not convert message to NSObject")
        }
        let (resp, err) = await agoraRtmClient.publish(channelName, message: msg, withOption: publishOption?.objcVersion)
        guard let resp = resp else {
            throw RtmBaseErrorInfo(from: err) ?? .noKnownError(operation: #function)
//            throw RtmPublishErrorInfo(from: err) ?? .noKnownError
        }
        return .init(resp)
    }

    /// Sets the parameters for the Agora RTM client.
    ///
    /// - Parameter parameters: The parameters to set.
    ///
    /// This method can throw an ``RtmBaseErrorInfo`` error if the parameter setting fails.
    public func setParameters(_ parameters: String) throws {
        let err = agoraRtmClient.setParameters(parameters)
        if err != .ok
//           let paramErr = RtmSetParametersErrorCode(rawValue: err.rawValue)
        {
            throw RtmBaseErrorInfo(errorCode: err.rawValue, operation: #function, reason: "")
//            throw paramErr
        }
    }

    /// Gets the error reason for the given error code.
    ///
    /// - Parameter errorCode: The error code for which to get the reason.
    /// - Returns: The error reason string or nil if the error code is invalid.
    public func getErrorReason(_ errorCode: Int) -> String? {
        guard let internalErr = AgoraRtmErrorCode(rawValue: errorCode) else { return nil }
        return agoraRtmClient.getErrorReason(internalErr)
    }

    /// Creates a stream channel with the provided name.
    ///
    /// - Parameter channelName: The name of the stream channel to create.
    /// - Returns: The newly created ``RtmStreamChannel`` instance.
    public func createStreamChannel(_ channelName: String) -> RtmStreamChannel? {
        RtmStreamChannel(channel: agoraRtmClient.createStreamChannel(channelName))
    }

    /// Destroys the Agora RTM client.
    ///
    /// - Returns: The error code indicating the result of the destruction, or nil if successful.
    public func destroy() -> RtmBaseErrorCode? {
        RtmBaseErrorCode(rawValue: agoraRtmClient.destroy().rawValue)
    }
}
