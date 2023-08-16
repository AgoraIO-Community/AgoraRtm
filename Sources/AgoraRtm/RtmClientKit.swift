//
//  RtmClientKit.swift
//
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// A class that serves as a client-side real-time communication kit.
///
/// It uses the Agora real-time communication client `AgoraRtmClientKit` to handle
/// operations such as logging in/out, token renewal, subscribing to/unsubscribing from
/// channels, message publishing, and more.
open class RtmClientKit: NSObject {

    /// The Agora real-time communication client.
    internal var agoraRtmClient: AgoraRtmClientKit!

    /// The storage used by the Agora RTM client.
    public lazy var storage: RtmStorage? = { .init(storage: agoraRtmClient.getStorage()) }()

    /// The lock used by the Agora RTM client.
    public lazy var lock: RtmLock? = { .init(lock: agoraRtmClient.getLock()) }()

    /// The presence information used by the Agora RTM client.
    public lazy var presence: RtmPresence? = { .init(presence: agoraRtmClient.getPresence()) }()

    /// The delegate for handling Real-Time Messaging (RTM) events.
    public weak var delegate: RtmClientDelegate?

    /// Creates a new instance of `RtmClientKit`.
    ///
    /// - Parameters:
    ///   - config: Configuration for the Agora RTM client.
    ///   - delegate: The delegate for the Agora RTM client.
    public init?(config: RtmClientConfig, delegate: RtmClientDelegate?) {
        super.init()
        guard let rtmClient = AgoraRtmClientKit(
            config: config.config, delegate: self
        ) else { return nil }
        self.delegate = delegate
        self.agoraRtmClient = rtmClient
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
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.login(byToken: token) { loginResp, err in
            // TODO: Login should not return a response if there's an error
            RtmClientKit.handleCompletion((loginResp, err), completion: completion, operation: #function)
        }
    }

    /// Asynchronously logs into the Agora RTM system.
    ///
    /// - Parameter token: The token to log in with.
    /// - Returns: A ``RtmCommonResponse`` if the login is successful, otherwise throws an ``RtmErrorInfo`` error.
    @available(iOS 13.0.0, *) @discardableResult
    public func login(byToken token: String? = nil) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await agoraRtmClient.login(byToken: token), operation: #function)
    }

    /// Logs out of the Agora RTM system.
    ///
    /// - Parameter completion: The completion handler to call when the logout operation is complete.
    public func logout(
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.logout() { resp, logoutErr in
            RtmClientKit.handleCompletion((resp, logoutErr), completion: completion, operation: #function)
        }
    }

    /// Asynchronously logs out of the Agora RTM system.
    ///
    /// This method can throw an ``RtmErrorInfo`` error if the logout operation fails.
    @available(iOS 13.0.0, *)
    @discardableResult
    public func logout() async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await agoraRtmClient.logout(), operation: #function)
    }

    /// Renews the token for the Agora RTM client.
    ///
    /// - Parameters:
    ///   - token: The new token to renew.
    ///   - completion: The completion handler to call when the token renewal operation is complete.
    public func renewToken(
        _ token: String,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.renewToken(token) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Asynchronously renews the token for the Agora RTM client.
    ///
    /// - Parameters:
    ///   - token: The new token to renew.
    ///
    /// This method can throw a ``RtmErrorInfo`` error if the token renewal operation fails.
    @available(iOS 13.0.0, *) @discardableResult
    public func renewToken(_ token: String) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await agoraRtmClient.renewToken(token), operation: #function)
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
        features: RtmSubscribeFeatures = [.messages, .presence],
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.subscribe(withChannel: channelName, option: features.objcVersion) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Asynchronously subscribes to a channel with the provided name and options.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to subscribe to.
    ///   - features: The options for subscribing to the channel.
    ///
    /// This method can throw a ``RtmCommonResponse`` error if the subscription operation fails.
    @available(iOS 13.0.0, *) @discardableResult
    public func subscribe(
        toChannel channelName: String, features: RtmSubscribeFeatures = [.messages, .presence]
    ) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(await agoraRtmClient.subscribe(
            withChannel: channelName, option: features.objcVersion
        ), operation: #function)
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
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        agoraRtmClient.unsubscribe(withChannel: channelName) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Asynchronously unsubscribes from a channel with the provided name.
    ///
    /// - Parameters:
    ///   - channelName: The name of the channel to unsubscribe from.
    ///
    /// This method can throw a ``RtmCommonResponse`` error if the unsubscription operation fails.
    @available(iOS 13.0.0, *) @discardableResult
    public func unsubscribe(fromChannel channelName: String) async throws -> RtmCommonResponse {
        return try RtmClientKit.handleCompletion(
            await agoraRtmClient.unsubscribe(withChannel: channelName), operation: #function
        )
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
        withOption publishOption: RtmPublishOptions? = nil,
        completion: ((Result<RtmCommonResponse, RtmErrorInfo>) -> Void)? = nil
    ) {
        let msgString: String
        do {
            msgString = try message.convertToString()
        } catch let error as RtmErrorInfo {
            completion?(.failure(error))
            return
        } catch {
            completion?(.failure(RtmErrorInfo(
                errorCode: .channelInvalidMessage, operation: #function,
                reason: "could not encode message: \(error.localizedDescription)"
            )))
            return
        }

        agoraRtmClient.publish(channelName, message: msgString as NSString, withOption: publishOption?.objcVersion) { resp, err in
            RtmClientKit.handleCompletion((resp, err), completion: completion, operation: #function)
        }
    }

    /// Asynchronously publishes a message in the specified channel.
    ///
    /// - Parameters:
    ///   - message: The message to publish.
    ///   - channelName: The name of the channel to publish the message to.
    ///   - publishOption: The options for publishing the message.
    ///
    /// This method will throw an ``RtmErrorInfo`` if the encoding or publish operation fails.
    @discardableResult @available(iOS 13.0.0, *)
    public func publish(
        message: Codable, to channelName: String, withOption publishOption: RtmPublishOptions? = nil
    ) async throws -> RtmCommonResponse {
        let msgString: String
        do {
            msgString = try message.convertToString()
        } catch let error as RtmErrorInfo {
            throw error
        } catch {
            throw RtmErrorInfo(
                errorCode: .channelInvalidMessage, operation: #function,
                reason: "could not encode message: \(error.localizedDescription)"
            )
        }
        return try RtmClientKit.handleCompletion(await agoraRtmClient.publish(
            channelName,
            message: msgString as NSString,
            withOption: publishOption?.objcVersion
        ), operation: #function)
    }

    /// Sets the parameters for the Agora RTM client.
    ///
    /// - Parameter parameters: The parameters to set.
    ///
    /// This method can throw an ``RtmErrorInfo`` error if the parameter setting fails.
    public func setParameters(_ parameters: String) throws {
        let err = agoraRtmClient.setParameters(parameters)
        if err != .ok {
            throw RtmErrorInfo(errorCode: err.rawValue, operation: #function, reason: "")
        }
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
    public func destroy() -> RtmErrorCode? {
        RtmErrorCode(rawValue: agoraRtmClient.destroy().rawValue)
    }
}

/// A set of options for subscribing to specific features in the Agora Real-Time Messaging (RTM) system.
/// You can use these options to customize your subscription behavior.
///
/// Create an instance of ``RtmSubscribeFeatures`` by combining the individual options using the `OptionSet` syntax.
/// For example:
///
/// ```swift
/// let subscriptionOptions: RtmSubscribeFeatures = [
///     .messages, .metadata
/// ]
///
/// clientKit.subscribe(
///     toChannel: "example", features: subscriptionOptions
/// )
/// ```
///
/// - See Also: ``RtmClientKit/subscribe(toChannel:features:)`` and
///          ``RtmClientKit/subscribe(toChannel:features:completion:)``
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
    /// - Returns: The `AgoraRtmSubscribeOptions` object with the subscription options set based on the ``RtmSubscribeFeatures``.
    internal var objcVersion: AgoraRtmSubscribeOptions {
        let objcOpt = AgoraRtmSubscribeOptions()
        objcOpt.withMessage = self.contains(.messages)
        objcOpt.withMetadata = self.contains(.metadata)
        objcOpt.withPresence = self.contains(.presence)
        objcOpt.withLock = self.contains(.lock)
        return objcOpt
    }
}

public extension RtmClientKit {
    /// Gets the error reason for the given error code.
    ///
    /// - Parameter errorCode: The error code for which to get the reason.
    /// - Returns: The error reason string or nil if the error code is invalid.
    static func getErrorReason(_ errorCode: RtmErrorCode) -> String? {
        guard let agoraErr = AgoraRtmErrorCode(
            rawValue: errorCode.rawValue
        ) else { return nil }
        return AgoraRtmClientKit.getErrorReason(agoraErr)
    }

    /// Gets the version of Agora RTM SDK.
    ///
    /// - Returns: The version string for the RTM engine.
    static func getVersion() -> String {
        AgoraRtmClientKit.getVersion()
    }
}

// Functions to handle the response cases for the objc library
internal extension RtmClientKit {
    static func handleCompletion<T: RtmResponseProtocol>(_ block: (resp: T.ResponseType?, err: AgoraRtmErrorInfo), completion: ((Result<T, RtmErrorInfo>) -> Void)? = nil, operation: String) {
        // TODO: No function should not return a response if there's an error
        guard let completion else { return }
        if let err = RtmErrorInfo(from: block.err) { return completion(.failure(err)) }
        guard let resp = block.resp else {
            return completion(.failure(.noKnownError(operation: operation)))
        }
        completion(.success(T.init(resp)))
    }

    static func handleCompletion<T: RtmResponseProtocol>(_ block: (resp: T.ResponseType?, err: AgoraRtmErrorInfo), operation: String) throws -> T {
        // TODO: No function should not return a response if there's an error
        if let err = RtmErrorInfo(from: block.err) { throw err }
        guard let resp = block.resp else { throw RtmErrorInfo.noKnownError(operation: #function) }
        return .init(resp)
    }

}
