//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/3/24.
//

import Foundation

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
    func didLoadDataFromServer()
    func didFailToLoadData(with error: Error)
}
