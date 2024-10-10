//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Alexey Kremnev on 10/5/24.
//

import XCTest
@testable import MovieQuiz

final class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {

        // Given
        let array = [1, 1, 2, 3, 5]

        // When
        let value = array[safe: 2]

        // Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutOfRange() throws {

        // Given
        let array = [1, 1, 2, 3, 5]

        // When
        let value = array[safe: 7]

        // Then
        XCTAssertNil(value)
    }
}
