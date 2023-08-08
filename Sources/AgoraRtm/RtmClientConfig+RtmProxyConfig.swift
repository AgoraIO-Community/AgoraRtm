//
//  RtmClientConfig+RtmProxyConfig.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

extension RtmClientConfig {
    /// A configuration for the Agora Real-Time Messaging (RTM) client's proxy settings.
    public struct RtmProxyConfig {
        internal let config: AgoraRtmProxyConfig

        /// The type of proxy server to use for RTM client communication.
        public enum RtmProxyType {
            /// HTTP proxy type.
            case http
        }

        /// Initializes the RTM proxy configuration with the specified proxy type, server, port, account, and password.
        ///
        /// - Parameters:
        ///   - proxyType: The type of proxy server to use. Set to `.http` to use an HTTP proxy.
        ///   - server: The proxy server address.
        ///   - port: The proxy server port.
        ///   - account: The account to authenticate with the proxy server, if required.
        ///   - password: The password to authenticate with the proxy server, if required.
        public init(proxyType: RtmProxyType?, server: String, port: UInt16, account: String? = nil, password: String? = nil) {
            config = AgoraRtmProxyConfig()
            if let type = proxyType, type == .http {
                config.proxyType = .http
            } else {
                config.proxyType = .none
            }
            config.server = server
            config.port = port
            config.account = account
            config.password = password
        }

        /// The type of proxy server to use.
        public var proxyType: RtmProxyType? {
            get { config.proxyType == .http ? .http : nil }
            set { config.proxyType = newValue != nil ? .http : .none }
        }

        /// The proxy server address.
        public var server: String {
            get { config.server }
            set { config.server = newValue }
        }

        /// The proxy server port.
        public var port: UInt16 {
            get { config.port }
            set { config.port = newValue }
        }

        /// The account to authenticate with the proxy server, if required.
        public var account: String? {
            get { config.account }
            set { config.account = newValue }
        }

        /// The password to authenticate with the proxy server, if required.
        public var password: String? {
            get { config.password }
            set { config.password = newValue }
        }
    }
}
