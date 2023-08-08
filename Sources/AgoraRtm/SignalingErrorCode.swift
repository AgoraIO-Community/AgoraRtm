//
//  SignalingErrorCode.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

protocol ErrorCode: RawRepresentable where RawValue == Int {}

protocol RtmError: Error {
    associatedtype E: ErrorCode
    var errorCode: E { get }
    var rawErrorCode: Int { get }
    var operation: String { get }
    var reason: String { get }
    init?(from errorInfo: AgoraRtmErrorInfo)
    init(errorCode: Int, operation: String, reason: String)
}
extension RtmError {
    init?(from errorInfo: AgoraRtmErrorInfo) {
        if errorInfo.errorCode == .ok {
            return nil
        }
        self.init(errorCode: errorInfo.errorCode.rawValue, operation: errorInfo.operation, reason: errorInfo.reason)
    }
}

/// A base error information struct that implements the `RtmError` protocol, providing error details for the Agora RTM SDK.
public struct RtmBaseErrorInfo: RtmError {
    /// The error code associated with the error.
    public let errorCode: RtmBaseErrorCode

    /// The raw error code value received from the SDK.
    public let rawErrorCode: Int

    /// The name of the operation where the error occurred.
    public let operation: String

    /// The reason or description of the error.
    public let reason: String

    /// Create an `RtmBaseErrorInfo` instance with the specified error code, operation name, and reason.
    ///
    /// - Parameters:
    ///   - errorCode: The error code to associate with the error.
    ///   - operation: The name of the operation where the error occurred.
    ///   - reason: The reason or description of the error.
    internal init(errorCode: Int, operation: String, reason: String) {
        self.errorCode = RtmBaseErrorCode(rawValue: errorCode) ?? .unknown
        self.operation = operation
        self.reason = reason
        self.rawErrorCode = errorCode

        if self.errorCode == .unknown {
            print("Unknown error code: \(errorCode)")
        }
    }

    /// Create an `RtmBaseErrorInfo` instance with the specified error code, operation name, and reason.
    ///
    /// - Parameters:
    ///   - errorCode: The `RtmBaseErrorCode` to associate with the error.
    ///   - operation: The name of the operation where the error occurred.
    ///   - reason: The reason or description of the error.
    internal init(errorCode: RtmBaseErrorCode, operation: String, reason: String) {
        self.init(errorCode: errorCode.rawValue, operation: operation, reason: reason)
    }

    /// Create an `RtmBaseErrorInfo` instance for cases where there is no known error, but the RTM SDK returned no valid response.
    ///
    /// - Parameter operation: The name of the function where the event occurred.
    /// - Returns: A new `RtmBaseErrorInfo` object with the error code set to `-1`.
    internal static func noKnownError(operation: String) -> RtmBaseErrorInfo {
        RtmBaseErrorInfo(
            errorCode: -1,
            operation: operation,
            reason: "\(operation) did not fail or return a response"
        )
    }
}

public enum RtmBaseErrorCode: Int, ErrorCode {
//    case ok = 0
    case unknown = -1
    case notInitialized = -10001
    case notLogin = -10002
    case invalidAppId = -10003
    case invalidEventHandler = -10004
    case invalidToken = -10005
    case invalidUserId = -10006
    case initServiceFailed = -10007
    case invalidChannelName = -10008
    case tokenExpired = -10009
    case loginNoServerResources = -10010
    case loginTimeout = -10011
    case loginRejected = -10012
    case loginAborted = -10013
    case invalidParameter = -10014
    case loginNotAuthorized = -10015
    case loginInconsistentAppId = -10016
    case duplicateOperation = -10017
    case instanceAlreadyReleased = -10018
    case channelNotJoined = -11001
    case channelNotSubscribed = -11002
    case channelExceedTopicUserLimitation = -11003
    case channelReused = -11004
    case channelInstanceExceedLimitation = -11005
    case channelInErrorState = -11006
    case channelJoinFailed = -11007
    case channelInvalidTopicName = -11008
    case channelInvalidMessage = -11009
    case channelMessageLengthExceedLimitation = -11010
    case channelInvalidUserList = -11011
    case channelNotAvailable = -11012
    case channelTopicNotSubscribed = -11013
    case channelExceedTopicLimitation = -11014
    case channelJoinTopicFailed = -11015
    case channelTopicNotJoined = -11016
    case channelTopicNotExist = -11017
    case channelInvalidTopicMeta = -11018
    case channelSubscribeTimeout = -11019
    case channelSubscribeTooFrequent = -11020
    case channelSubscribeFailed = -11021
    case channelUnsubscribeFailed = -11022
    case channelEncryptMessageFailed = -11023
    case channelPublishMessageFailed = -11024
    case channelPublishMessageTooFrequent = -11025
    case channelPublishMessageTimeout = -11026
    case channelNotConnected = -11027
    case channelLeaveFailed = -11028
    case channelCustomTypeLengthOverflow = -11029
    case channelInvalidCustomType = -11030
    case channelUnsupportedMessageType = -11031
    case channelPresenceNotReady = -11032
    case storageOperationFailed = -12001
    case storageMetadataItemExceedLimitation = -12002
    case storageInvalidMetadataItem = -12003
    case storageInvalidArgument = -12004
    case storageInvalidRevision = -12005
    case storageMetadataLengthOverflow = -12006
    case storageInvalidLockName = -12007
    case storageLockNotAcquired = -12008
    case storageInvalidKey = -12009
    case storageInvalidValue = -12010
    case storageKeyLengthOverflow = -12011
    case storageValueLengthOverflow = -12012
    case storageDuplicateKey = -12013
    case storageOutdatedRevision = -12014
    case storageNotSubscribe = -12015
    case storageInvalidMetadataInstance = -12016
    case storageSubscribeUserExceedLimitation = -12017
    case storageOperationTimeout = -12018
    case storageNotAvailable = -12019
    case presenceNotConnected = -13001
    case presenceNotWritable = -13002
    case presenceInvalidArgument = -13003
    case presenceCacheTooManyStates = -13004
    case presenceStateCountOverflow = -13005
    case presenceInvalidStateKey = -13006
    case presenceInvalidStateValue = -13007
    case presenceStateKeySizeOverflow = -13008
    case presenceStateValueSizeOverflow = -13009
    case presenceStateDuplicateKey = -13010
    case presenceUserNotExist = -13011
    case presenceOperationTimeout = -13012
    case presenceOperationFailed = -13013
    case lockOperationFailed = -14001
    case lockOperationTimeout = -14002
    case lockOperationPerforming = -14003
    case lockAlreadyExist = -14004
    case lockInvalidName = -14005
    case lockNotAcquired = -14006
    case lockAcquireFailed = -14007
    case lockNotExist = -14008
    case lockNotAvailable = -14009
}

internal extension RtmClientKit {
    struct RtmLoginErrorInfo: RtmError {
        let errorCode: LoginErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = RtmLoginErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = LoginErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    
    struct RtmLogoutErrorInfo: RtmError {
        static let noKnownError = RtmLogoutErrorInfo(
            errorCode: -1,
            operation: "logout",
            reason: "logout did not fail or return a response"
        )
        let errorCode: LogoutErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = LogoutErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    
    struct RtmRenewTokenErrorInfo: RtmError {
        internal static let noKnownError = RtmRenewTokenErrorInfo(
            errorCode: -1,
            operation: "renewToken",
            reason: "renewToken did not fail or return a response"
        )
        let errorCode: RenewTokenErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RenewTokenErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    
    struct RtmSubscribeErrorInfo: RtmError {
        internal static let noKnownError = RtmSubscribeErrorInfo(
            errorCode: -1,
            operation: "subscribe",
            reason: "subscribe did not fail or return a response"
        )
        let errorCode: SubscribeErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = SubscribeErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    
    struct RtmUnsubscribeErrorInfo: RtmError {
        internal static let noKnownError = RtmUnsubscribeErrorInfo(
            errorCode: -1,
            operation: "unsubscribe",
            reason: "unsubscribe did not fail or return a response"
        )
        let errorCode: UnsubscribeErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = UnsubscribeErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    
    struct RtmPublishErrorInfo: RtmError {
        internal static let noKnownError = RtmPublishErrorInfo(
            errorCode: -1,
            operation: "publish",
            reason: "publish did not fail or return a response"
        )
        let errorCode: PublishErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = PublishErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
        internal init(errorCode: PublishErrorCode, operation: String, reason: String) {
            self.init(errorCode: errorCode.rawValue, operation: operation, reason: reason)
        }
    }
    
    enum RtmSetParametersErrorCode: Error {
        case notInitialized
        case notLogin
        case invalidAppId
        case invalidEventHandler
        case invalidToken
        case invalidUserId
        case initServiceFailed
        case unknown(Int)
        var rawValue: Int {
            switch self {
            case .notInitialized: return -10001
            case .notLogin: return -10002
            case .invalidAppId: return -10003
            case .invalidEventHandler: return -10004
            case .invalidToken: return -10005
            case .invalidUserId: return -10006
            case .initServiceFailed: return -10007
            case .unknown(let value): return value
            }
        }
        init?(rawValue: Int) {
            switch rawValue {
            case -10001: self = .notInitialized
            case -10002: self = .notLogin
            case -10003: self = .invalidAppId
            case -10004: self = .invalidEventHandler
            case -10005: self = .invalidToken
            case -10006: self = .invalidUserId
            case -10007: self = .initServiceFailed
            default: self = .unknown(rawValue)
            }
        }
    }
    
    enum LoginErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case invalidToken = -10005
        case invalidUserId = -10006
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case loginNoServerResources = -10010
        case loginTimeout = -10011
        case loginRejected = -10012
        case loginAborted = -10013
        case invalidParameter = -10014
        case loginNotAuthorized = -10015
        case loginInconsistentAppId = -10016
        case unknown = -1
    }
    enum LogoutErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case invalidToken = -10005
        case invalidUserId = -10006
        case initServiceFailed = -10007
        case unknown = -1
    }
    enum RenewTokenErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case invalidToken = -10005
        case invalidUserId = -10006
        case initServiceFailed = -10007
        case unknown = -1
    }
    enum SubscribeErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case invalidToken = -10005
        case invalidUserId = -10006
        case initServiceFailed = -10007
        case unknown = -1
    }
    enum UnsubscribeErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case invalidToken = -10005
        case invalidUserId = -10006
        case initServiceFailed = -10007
        case unknown = -1
    }
    enum PublishErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case invalidAppId = -10003
        case invalidEventHandler = -10004
        case initServiceFailed = -10007
        case publishMessageFailed = -11024
        case publishMessageTooFrequent = -11025
        case publishMessageTimeout = -11026
        case unknown = -1
    }
}

internal extension RtmStreamChannel {
    struct JoinErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.JoinErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = JoinErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.JoinErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum JoinErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }
    struct LeaveErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.LeaveErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = LeaveErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.LeaveErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum LeaveErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }
    struct JoinTopicErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.JoinTopicErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = JoinTopicErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.JoinTopicErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum JoinTopicErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }
    struct LeaveTopicErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.LeaveTopicErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = LeaveTopicErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.LeaveTopicErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum LeaveTopicErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }


    struct SubscribeTopicErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.SubscribeTopicErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = SubscribeTopicErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.SubscribeTopicErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum SubscribeTopicErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }
    struct UnsubscribeTopicErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.UnsubscribeTopicErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = UnsubscribeTopicErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.UnsubscribeTopicErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
    }
    enum UnsubscribeTopicErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case unknown = -1
    }

    struct PublishTopicMessageErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.PublishTopicMessageErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = PublishTopicMessageErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.PublishTopicMessageErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
        internal init(errorCode: PublishTopicMessageErrorCode, operation: String, reason: String) {
            self.init(errorCode: errorCode.rawValue, operation: operation, reason: reason)
        }
    }
    enum PublishTopicMessageErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case publishMessageFailed = -11024
        case publishMessageTooFrequent = -11025
        case publishMessageTimeout = -11026
        case unknown = -1
    }

    struct GetSubscribersErrorInfo: RtmError {
        let errorCode: RtmStreamChannel.GetSubscribersErrorCode
        let rawErrorCode: Int
        let operation: String
        let reason: String
        static let noKnownError = GetSubscribersErrorInfo(
            errorCode: -1,
            operation: "login",
            reason: "login did not fail or return a response"
        )
        init(errorCode: Int, operation: String, reason: String) {
            self.errorCode = RtmStreamChannel.GetSubscribersErrorCode(rawValue: errorCode) ?? .unknown
            self.operation = operation
            self.reason = reason
            self.rawErrorCode = errorCode
            if self.errorCode == .unknown {
                print("unknown error code: \(errorCode)")
            }
        }
        internal init(errorCode: GetSubscribersErrorCode, operation: String, reason: String) {
            self.init(errorCode: errorCode.rawValue, operation: operation, reason: reason)
        }
    }
    enum GetSubscribersErrorCode: Int, ErrorCode {
        case notInitialized = -10001
        case notLogin = -10002
        case initServiceFailed = -10007
        case invalidChannelName = -10008
        case tokenExpired = -10009
        case invalidParameter = -10014
        case publishMessageFailed = -11024
        case publishMessageTooFrequent = -11025
        case publishMessageTimeout = -11026
        case unknown = -1
    }
}
