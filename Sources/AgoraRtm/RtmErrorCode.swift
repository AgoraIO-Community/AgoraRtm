//
//  RtmErrorCode.swift
//  
//
//  Created by Max Cobb on 07/08/2023.
//

import AgoraRtmKit

protocol ErrorCode: RawRepresentable where RawValue == Int {}

protocol RtmError: Error {
    associatedtype ErrCode: ErrorCode
    var errorCode: ErrCode { get }
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

/// A base error information struct that implements the `RtmError` protocol,
/// providing error details for the Agora RTM SDK.
public struct RtmErrorInfo: RtmError {
    /// The error code associated with the error.
    public let errorCode: RtmErrorCode

    /// The raw error code value received from the SDK.
    public let rawErrorCode: Int

    /// The name of the operation where the error occurred.
    public let operation: String

    /// The reason or description of the error.
    public let reason: String

    /// Create an `RtmErrorInfo` instance with the specified error code, operation name, and reason.
    ///
    /// - Parameters:
    ///   - errorCode: The error code to associate with the error.
    ///   - operation: The name of the operation where the error occurred.
    ///   - reason: The reason or description of the error.
    internal init(errorCode: Int, operation: String, reason: String) {
        self.errorCode = RtmErrorCode(rawValue: errorCode) ?? .unknown
        self.operation = operation
        self.reason = reason
        self.rawErrorCode = errorCode

        if self.errorCode == .unknown {
            print("Unknown error code: \(errorCode)")
        }
    }

    /// Create an `RtmErrorInfo` instance with the specified error code, operation name, and reason.
    ///
    /// - Parameters:
    ///   - errorCode: The ``RtmErrorCode`` to associate with the error.
    ///   - operation: The name of the operation where the error occurred.
    ///   - reason: The reason or description of the error.
    internal init(errorCode: RtmErrorCode, operation: String, reason: String) {
        self.init(errorCode: errorCode.rawValue, operation: operation, reason: reason)
    }

    /// Create an `RtmErrorInfo` instance for cases where there is no known error,
    /// but the RTM SDK returned no valid response.
    ///
    /// - Parameter operation: The name of the function where the event occurred.
    /// - Returns: A new `RtmErrorInfo` object with the error code set to `-1`.
    internal static func noKnownError(operation: String) -> RtmErrorInfo {
        RtmErrorInfo(
            errorCode: -1,
            operation: operation,
            reason: "\(operation) did not fail or return a response"
        )
    }
}

public enum RtmErrorCode: Int, ErrorCode {
    // `ok` is not a valid error, absence of an error indicates no error.
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
