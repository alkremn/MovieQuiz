//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/2/24.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    weak var delegate: QuestionFactoryDelegate?
    
    private let questions: [QuizQuestion] = [
        .init(image: "The Godfather", actualRating: 9.2, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Dark Knight", actualRating: 9, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Kill Bill", actualRating: 8.1, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Avengers", actualRating: 8, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Deadpool", actualRating: 8, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "The Green Knight", actualRating: 6.6, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: true),
        .init(image: "Old", actualRating: 5.8, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "The Ice Age Adventures of Buck Wild", actualRating: 4.3, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "Tesla", actualRating: 5.1, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false),
        .init(image: "Vivarium", actualRating: 5.8, text: "Рейтинг этого фильма больше чем 6?", correctAnswer: false)
    ]
    
    public func requestNextQuestion() {
        guard let index = (0..<questions.count).randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }
}
