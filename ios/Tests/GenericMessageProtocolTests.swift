//
// Wire
// Copyright (C) 2025 Wire Swiss GmbH
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see http://www.gnu.org/licenses/.
//

import Testing

@testable import GenericMessageProtocol

struct GenericMessageProtocolTests {

    @Test func testMessages() async throws {

        // Given
        let genericMessage = GenericMessage.with { genericMessage in
            genericMessage.messageID = "Lorem Ipsum"
        }

        // Then
        #expect(genericMessage.messageID == "Lorem Ipsum")

    }

    @Test func testMLS() async throws {

        // Given
        let commitBundle = Mls_CommitBundle.with { commitBundle in
            commitBundle.groupInfoBundle = .with { groupInfoBundle in
                groupInfoBundle.groupInfoType = .groupInfo
                groupInfoBundle.ratchetTreeType = .delta
            }
        }

        // Then
        #expect(commitBundle.groupInfoBundle.groupInfoType == .groupInfo)
        #expect(commitBundle.groupInfoBundle.ratchetTreeType == .delta)

    }

    @Test func testOTR() async throws {

        // Given
        let qualifiedNewOtrMessage = Proteus_QualifiedNewOtrMessage.with { qualifiedNewOtrMessage in
            qualifiedNewOtrMessage.nativePriority = .highPriority
        }

        // Then
        #expect(qualifiedNewOtrMessage.nativePriority == .highPriority)

    }

}
