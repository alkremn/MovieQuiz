//
//  MockMovieQuizViewController.swift
//  MovieQuizTests
//
//  Created by Alexey Kremnev on 10/10/24.
//

import Foundation
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(viewModel: MovieQuiz.QuizStepViewModel) {}
    
    func show(result model: MovieQuiz.QuizResultsViewModel) {}
    
    func highlightImageBorder(isCorrect: Bool) {}
    
    func showLoadingIndicator() {}
    
    func hideLoadingIndicator() {}
    
    func showNetworkError(message: String, completion: @escaping () -> Void) {}
}
