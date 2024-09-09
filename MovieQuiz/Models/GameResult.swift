//
//  GameResult.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/7/24.
//

import Foundation


struct GameResult {
    let correct: Int
    let total: Int
    let date: Date
    
    func isBetterThan(_ other: GameResult) -> Bool {
        self.correct > other.correct
    }
    
    func toString() -> String {
        "\(correct)/\(total) (\(date.dateTimeString))"
    }
}
