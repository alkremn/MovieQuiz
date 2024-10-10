//
//  MovieQuizPresenterTests.swift
//  MovieQuizTests
//
//  Created by Alexey Kremnev on 10/10/24.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizPresenterTests: XCTestCase {

    func testPresenterConvertModel() throws {
        // Given
        let expectation = expectation(description: "getting converted model expectation")
        let viewControllerMock = MovieQuizViewControllerMock(expectation: expectation)
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
    
        let questionTest = "Question Test"
        let question = QuizQuestion(image: Data(), actualRating: 5, text: questionTest, correctAnswer: true)
        
        // When
        sut.didReceiveNextQuestion(question: question)

        waitForExpectations(timeout: 1)
        
        var viewModel = viewControllerMock.resultModal
        // Then
        XCTAssertNotNil(viewModel?.image)
        XCTAssertEqual(viewModel?.question, questionTest)
        XCTAssertEqual(viewModel?.questionNumber, "1/10")
    }
}
