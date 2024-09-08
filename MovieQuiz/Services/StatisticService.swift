//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/7/24.
//

import Foundation


final class StatisticService: StatisticServiceProtocol {
   
    private let storage: UserDefaults = UserDefaults.standard
    
    private enum Keys: String {
        case correct
        case bestGame
        case gamesCount
        case gameCorrectCount
        case gameTotalCount
        case gameDate
    }
    
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.gameCorrectCount.rawValue)
            let total = storage.integer(forKey: Keys.gameTotalCount.rawValue)
            let date = storage.object(forKey: Keys.gameDate.rawValue) as? Date ?? Date()
            
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.gameCorrectCount.rawValue)
            storage.set(newValue.total, forKey: Keys.gameTotalCount.rawValue)
            storage.set(newValue.date, forKey: Keys.gameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        let totalGames = gamesCount
        if totalGames == 0 { return 0.0 }
        
        return Double(correctAnswers) / Double(totalGames * 10) * 100
    }
    
    private var correctAnswers: Int {
        get {
            storage.integer(forKey: Keys.correct.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.correct.rawValue)
        }
    }
    
    func store(correct count: Int, total amount: Int, date: Date) {
        correctAnswers += count
        gamesCount += 1
        
        let gameResult = GameResult(correct: count, total: amount, date: date)
        if gameResult.isBetterThan(bestGame) {
            bestGame = gameResult
        }
    }
}
