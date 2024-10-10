//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 10/10/24.
//

import Foundation


protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(viewModel: QuizStepViewModel)
    func show(result model: QuizResultsViewModel)
    func highlightImageBorder(isCorrect: Bool)
    func showLoadingIndicator()
    func hideLoadingIndicator()
    func showNetworkError(message: String, completion: @escaping () -> Void)
}
