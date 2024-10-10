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
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(viewController: viewControllerMock)
    
        let questionTest = "Question Test"
        let question = QuizQuestion(image: Data(), actualRating: 5, text: questionTest, correctAnswer: true)
        
        // When
        let viewModel = sut._convert(model: question)
        
        // Then
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, questionTest)
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
