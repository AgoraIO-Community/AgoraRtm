//
//  RtmClientConfig+RtmAreaCode.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

extension RtmClientConfig {
    /// An option set representing different area codes for the Agora Real-Time Messaging (RTM) client.
    public struct RtmAreaCode: OptionSet {
        /// The raw value type of the option set, based on `AgoraAreaCodeType.RawValue`.
        public let rawValue: AgoraRtmAreaCode.RawValue
        
        /// Option representing Mainland China.
        public static let mainlandChina = RtmAreaCode(rawValue: AgoraRtmAreaCode.CN.rawValue)
        
        /// Option representing North America.
        public static let northAmerica = RtmAreaCode(rawValue: AgoraRtmAreaCode.NA.rawValue)
        
        /// Option representing Europe.
        public static let europe = RtmAreaCode(rawValue: AgoraRtmAreaCode.EU.rawValue)
        
        /// Option representing Asia, excluding Mainland China.
        public static let asiaExcludingChina = RtmAreaCode(rawValue: AgoraRtmAreaCode.AS.rawValue)
        
        /// Option representing Japan.
        public static let japan = RtmAreaCode(rawValue: AgoraRtmAreaCode.JP.rawValue)
        
        /// Option representing India.
        public static let india = RtmAreaCode(rawValue: AgoraRtmAreaCode.IN.rawValue)
        
        /// Option representing Global (Default).
        public static let global = RtmAreaCode(rawValue: AgoraRtmAreaCode.GLOB.rawValue)
        
        /// Converts the raw value to an `AgoraAreaCodeType` instance, representing a single area code.
        /// - Returns: An `AgoraAreaCodeType` instance initialized with the option set's raw value.
        public var legacyAreaCode: AgoraRtmAreaCode? { .init(rawValue: self.rawValue) }
        
        /// Creates an instance of `AgoraAreaCodeOptions` from a legacy `AgoraAreaCodeType`.
        /// - Parameter legacyCode: The legacy `AgoraAreaCodeType` to convert.
        /// - Returns: An `AgoraAreaCodeOptions` instance initialized with the raw value of the legacy area code.
        internal static func fromLegacy(_ legacyCode: AgoraRtmAreaCode) -> Self {
            RtmAreaCode(rawValue: legacyCode.rawValue)
        }
        
        /// Creates an instance of `AgoraAreaCodeOptions` from the specified raw value.
        ///
        /// - Parameter rawValue: The raw value to initialize the option set.
        /// - Returns: An `AgoraAreaCodeOptions` instance initialized with the given raw value.
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
    }
}
