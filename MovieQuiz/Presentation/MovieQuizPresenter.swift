//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 10/10/24.
//

import UIKit


final class MovieQuizPresenter {
    private weak var viewController: MovieQuizViewControllerProtocol?
    
    private let statisticService: StatisticServiceProtocol
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    private var currentQuestionIndex = 0
    private var currentAnswers = 0
    private let questionsCount = 10
    
    private var isLastQuestion: Bool { currentQuestionIndex == questionsCount - 1 }
    
    init(viewController: MovieQuizViewControllerProtocol) {
        self.viewController = viewController
        
        statisticService = StatisticService()
        questionFactory = QuestionFactory(moviesLoader: MoviesLoader(), delegate: self)
        
        viewController.showLoadingIndicator()
        questionFactory?.loadData()
    }
    
    //MARK: - Public methods
    
    func answerButtonClicked(isYes: Bool) {
        guard let currentQuestion = currentQuestion else { return }
        
        proceedWithAnswer(isCorrect: currentQuestion.correctAnswer == isYes)
    }

    
    //MARK: - Private Methods
    
    private func proceedWithAnswer(isCorrect: Bool) {
        if isCorrect { currentAnswers += 1 }
        
        viewController?.highlightImageBorder(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            proceedToNextQuestionOrResults()
        }
    }
    
    private func proceedToNextQuestionOrResults() {
        if isLastQuestion {
            statisticService.store(correct: currentAnswers, total: questionsCount, date: Date())
            
            let resultViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: createResultMessage(answers: currentAnswers),
                buttonText: "Сыграть ещё раз") { [weak self] in
                    guard let self else { return }
                    self.resetResults()
                }
            
            viewController?.show(result: resultViewModel)
            return
        }
            
        currentQuestionIndex += 1
        viewController?.showLoadingIndicator()
        questionFactory?.requestNextQuestion()
        
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        .init(
            image: UIImage(data: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)"
        )
    }
    
    private func resetResults() {
        currentAnswers = 0
        currentQuestionIndex = 0
        questionFactory?.requestNextQuestion()
    }
    
    private func createResultMessage(answers: Int) -> String {
        """
            Ваш результат: \(answers)/10
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.toString())
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
        """
    }
}


//MARK: - QuestionFactoryDelegate Extension

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            viewController?.hideLoadingIndicator()
            viewController?.show(viewModel: viewModel)
        }
    }

    func didLoadDataFromServer() {
        questionFactory?.requestNextQuestion()
    }
    
    func didFailToLoadData(with error: Error) {
        viewController?.hideLoadingIndicator()
        viewController?.showNetworkError(message: error.localizedDescription) { [weak self] in
            guard let self else { return }
    
            self.resetResults()
            viewController?.showLoadingIndicator()
            self.questionFactory?.loadData()
        }
    }
}
