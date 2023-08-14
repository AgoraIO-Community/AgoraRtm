//
//  RtmClientKitTests.swift
//  
//
//  Created by Max Cobb on 14/08/2023.
//

import XCTest
@testable import AgoraRtm
import AgoraRtmKit

final class RtmClientKitTests: XCTestCase {

    var rtmClient: RtmClientKit!

    override func setUpWithError() throws {
        let config = RtmClientConfig(appId: "87654321234567898765432123456789", userId: "yourUserId")
        rtmClient = RtmClientKit(config: config, delegate: nil)
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        _ = rtmClient?.destroy()
    }

    // Test initialization
    func testInit() {
        XCTAssertNotNil(rtmClient)
        XCTAssertTrue(rtmClient?.delegate === nil)
    }

    // Test initialization
    func testInvalidAppIdInit() {
        _ = rtmClient?.destroy()
        let config = RtmClientConfig(appId: "18c2dfa12345678987654321f", userId: "yourUserId")
        rtmClient = RtmClientKit(config: config, delegate: nil)
        XCTAssertNil(rtmClient)
    }

    func testSetParams() {
        // TODO: This should only accept dictionaries
//        XCTAssertThrowsError( try rtmClient.setParameters("test") )
    }
}
