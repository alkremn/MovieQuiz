//
//  MockMovieQuizViewController.swift
//  MovieQuizTests
//
//  Created by Alexey Kremnev on 10/10/24.
//

import Foundation
import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    private let expectation: XCTestExpectation
    
    init(expectation: XCTestExpectation) {
        self.expectation = expectation
    }
    
    var resultModal: QuizStepViewModel?
    
    func show(viewModel: QuizStepViewModel) {
        resultModal = viewModel
        expectation.fulfill()
    }
    
    func show(result model: QuizResultsViewModel) {}
    
    func highlightImageBorder(isCorrect: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String, completion: @escaping () -> Void) {}
}
