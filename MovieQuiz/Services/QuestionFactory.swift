//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/2/24.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    
    private let moviesLoader: MoviesLoading
    private weak var delegate: QuestionFactoryDelegate?

    private var movies = [MostPopularMovie]()
    
    init(moviesLoader: MoviesLoading, delegate: QuestionFactoryDelegate?) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
        
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self else { return }
                
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            let index = (0..<movies.count).randomElement() ?? 0
            
            guard let movie = movies[safe: index] else { return }
            
            var imageData = Data()

            do {
                imageData = try Data.init(contentsOf: movie.resizedImageURL)
            } catch {
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.delegate?.didFailToLoadData(with: error)
                }
            }

            let rating = Float(movie.rating) ?? 0.0
            let randomRating = Int.random(in: 7...9)
            let question = QuizQuestion(image: imageData,
                                        actualRating: rating,
                                        text: "Рейтинг этого фильма больше чем \(randomRating)?",
                                        correctAnswer: rating > Float(randomRating))
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
