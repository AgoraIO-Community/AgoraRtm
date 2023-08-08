//
//  RtmClientConfig.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

/// A configuration struct for initializing the Agora Real-Time Messaging (RTM) client.
public struct RtmClientConfig {
    internal let config: AgoraRtmClientConfig

    /// Creates an instance of `RtmClientConfig` with the provided parameters.
    ///
    /// - Parameters:
    ///   - appId: The unique identifier of the application.
    ///   - userId: The user ID for the RTM client.
    ///   - useStringUserId: A flag to indicate whether the user ID should be treated as a string or an integer. Default is `true`.
    public init(appId: String, userId: String, useStringUserId: Bool = true) {
        config = AgoraRtmClientConfig()
        config.appId = appId
        config.useStringUserId = useStringUserId
        config.userId = userId
    }

    /// Creates an instance of `RtmClientConfig` with the provided parameters.
    ///
    /// - Parameters:
    ///   - appId: The unique identifier of the application.
    ///   - userId: The user ID for the RTM client as an integer value.
    ///   - useStringUserId: A flag to indicate whether the user ID should be treated as a string or an integer. Default is `false`.
    public init(appId: String, userId: Int, useStringUserId: Bool = false) {
        config = AgoraRtmClientConfig()
        config.appId = appId
        config.useStringUserId = useStringUserId
        config.userId = String(userId)
    }

    /// The area code for the RTM client.
    public var areaCode: RtmAreaCode {
        get { .init(rawValue: UInt(config.areaCode)) }
        set { config.areaCode = UInt32(newValue.legacyAreaCode!.rawValue) }
    }

    /// The timeout for user presence status updates.
    public var presenceTimeout: UInt32 {
        get { config.presenceTimeout }
        set { config.presenceTimeout = newValue }
    }

    /// A flag indicating whether the user ID should be treated as a string or an integer.
    public var useStringUserId: Bool {
        get { config.useStringUserId }
        set { config.useStringUserId = newValue }
    }

    /// The configuration for logging options.
    public var logConfig: RtmLogConfig? {
        didSet { config.logConfig = logConfig?.config }
    }

    /// The configuration for proxy options.
    public var proxyConfig: RtmProxyConfig? {
        didSet { config.proxyConfig = proxyConfig?.config }
    }

    /// The encryption configuration for the RTM client.
    public enum RtmEncryptionConfig {
        /// No encryption.
        case none
        /// AES-128-GCM encryption.
        case aes128GCM(key: String, salt: String?)
        /// AES-256-GCM encryption.
        case aes256GCM(key: String, salt: String?)
    }

    /// The encryption configuration for the RTM client.
    public var encryptionConfig: RtmEncryptionConfig? {
        set {
            var encConfig: AgoraRtmEncryptionConfig? = .init()
            switch newValue {
            case .aes128GCM(let key, let salt):
                encConfig?.encryptionKey = key
                encConfig?.encryptionSalt = salt?.data(using: .utf8)
                encConfig?.encryptionMode = .AES128GCM
            case .aes256GCM(let key, let salt):
                encConfig?.encryptionKey = key
                encConfig?.encryptionSalt = salt?.data(using: .utf8)
                encConfig?.encryptionMode = .AES256GCM
            default:
                encConfig = nil
            }
            config.encryptionConfig = encConfig
        }
        get {
            guard let encConf = config.encryptionConfig, encConf.encryptionMode != .none,
                    let encKey = encConf.encryptionKey else {
                return nil
            }
            let salt = encConf.encryptionSalt
            var saltStr: String? = nil
            if let salt {
                saltStr = String(data: salt, encoding: .utf8)
            }
            switch encConf.encryptionMode {
            case .none: return nil
            case .AES128GCM: return .aes128GCM(key: encKey, salt: saltStr)
            case .AES256GCM: return .aes256GCM(key: encKey, salt: saltStr)
            @unknown default: return nil
            }
        }
    }
}
