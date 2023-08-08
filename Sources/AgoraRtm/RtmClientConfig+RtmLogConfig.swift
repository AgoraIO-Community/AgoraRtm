//
//  RtmClientConfig+RtmLogConfig.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

extension RtmClientConfig {
    /// A configuration for controlling the log output of the Agora Real-Time Messaging (RTM) client.
    public struct RtmLogConfig {

        /// The log level options for the RTM client.
        public enum RtmLogLevel: Int {
            /// No log output.
            case none    = 0b00000
            /// Log level for informational messages.
            case info    = 0b00001
            /// Log level for warning messages.
            case warn    = 0b00010
            /// Log level for error messages.
            case error   = 0b00100
            /// Log level for fatal error messages.
            case fatal   = 0b01000
            /// Log level for API call messages.
            case apiCall = 0b10000
        }

        internal let config: AgoraRtmLogConfig

        /// Initializes the RTM log configuration with the specified log level, file path, and file size in kilobytes.
        ///
        /// - Parameters:
        ///   - level: The log level to control the verbosity of log output.
        ///   - filePath: The file path to store the log file. If nil, logs are not written to a file.
        ///   - fileSizeInKB: The maximum size of the log file in kilobytes before rotation.
        public init(level: RtmLogLevel, filePath: String?, fileSizeInKB: Int32) {
            config = AgoraRtmLogConfig()
            config.filePath = filePath
            config.fileSizeInKB = fileSizeInKB
            config.level = .init(rawValue: level.rawValue) ?? .info
        }

        /// The file path where the log file is stored. If nil, logs are not written to a file.
        public var filePath: String? {
            get { config.filePath }
            set { config.filePath = newValue }
        }

        /// The maximum size of the log file in kilobytes before rotation.
        public var fileSizeInKB: Int32 {
            get { config.fileSizeInKB }
            set { config.fileSizeInKB = newValue }
        }

        /// The log level controlling the verbosity of log output.
        public var level: RtmLogLevel? {
            get { .init(rawValue: config.level.rawValue) }
            set { config.level = .init(rawValue: (newValue ?? .info).rawValue) ?? .info }
        }
    }
}
