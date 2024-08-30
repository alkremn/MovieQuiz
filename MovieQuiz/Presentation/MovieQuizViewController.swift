import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    
    private var currentQuestionIndex = 0
    private var currentAnswers = 0
    
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

    override func viewDidLoad() {
        super.viewDidLoad()
        showQuestion(at: currentQuestionIndex)
    }
    
    //MARK: - Event handlers
    @IBAction private func answerButtonClicked(_ sender: Any) {
        guard let answerButton = sender as? UIButton else { return }
        let currentQuestion = questions[currentQuestionIndex]
        let trueAnswer = answerButton == yesButton
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == trueAnswer)
    }
    
    //MARK: - helper methods
    private func convert(model: QuizQuestion) -> QuizQuestionViewModel {
        return QuizQuestionViewModel(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questions.count)"
        )
    }
    
    private func show(viewModel: QuizQuestionViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect {
            currentAnswers += 1
        }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor(resource: isCorrect ? .ypGreen : .ypRed).cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex == questions.count - 1 {
            let resultsViewModel = QuizResultsViewModel(
                title: "Этот раунд окончен!",
                text: "Ваш результат: \(currentAnswers)/10",
                buttonText: "Сыграть ещё раз")
            show(quiz: resultsViewModel)
        } else {
            currentQuestionIndex += 1
            showQuestion(at: currentQuestionIndex)
        }
    }
    
    private func show(quiz result: QuizResultsViewModel) {
        let alert = UIAlertController(
            title: result.title,
            message: result.text,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: result.buttonText, style: .default) { _ in
            self.currentQuestionIndex = 0
            self.currentAnswers = 0
            let firstQuestion = self.questions[self.currentQuestionIndex]
            let viewModel = self.convert(model: firstQuestion)
            self.show(viewModel: viewModel)
        }
        
        alert.addAction(alertAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showQuestion(at index: Int) {
        let nextQuestion = questions[currentQuestionIndex]
        let viewModel = convert(model: nextQuestion)
        show(viewModel: viewModel)
    }
}
