import UIKit

final class MovieQuizViewController: UIViewController {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!

    private let questionsCount = 10
    
    private var currentQuestionIndex = 0
    private var currentAnswers = 0
    private let statisticService: StatisticServiceProtocol = StatisticService()
    private var alertPresenter: AlertPresenter?
    private var questionFactory: QuestionFactoryProtocol?
    private var currentQuestion: QuizQuestion?
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitial()
    }
    
    //MARK: - Actions
    @IBAction private func answerButtonClicked(_ sender: Any) {
        guard let currentQuestion = currentQuestion,
              let answerButton = sender as? UIButton  else { return }
        
        let trueAnswer = answerButton == yesButton
        showAnswerResult(isCorrect: currentQuestion.correctAnswer == trueAnswer)
    }
    
    //MARK: - Private functions
    private func setupInitial() {
        alertPresenter = AlertPresenter(viewController: self)
        let questionFactory = QuestionFactory()
        questionFactory.delegate = self
        self.questionFactory = questionFactory
        questionFactory.requestNextQuestion()
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        .init(
            image: UIImage(named: model.image) ?? UIImage(),
            question: model.text,
            questionNumber: "\(currentQuestionIndex + 1)/\(questionsCount)"
        )
    }
    
    private func show(viewModel: QuizStepViewModel) {
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
    }
    
    private func showAnswerResult(isCorrect: Bool) {
        if isCorrect { currentAnswers += 1 }
        
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor(resource: isCorrect ? .ypGreen : .ypRed).cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            guard let self else { return }
            
            self.imageView.layer.borderWidth = 0
            self.showNextQuestionOrResults()
            self.noButton.isEnabled = true
            self.yesButton.isEnabled = true
        }
    }
    
    private func showNextQuestionOrResults() {
        if currentQuestionIndex < questionsCount - 1 {
            currentQuestionIndex += 1
            questionFactory?.requestNextQuestion()
            return
        }
        
        statisticService.store(correct: currentAnswers, total: questionsCount, date: Date())
        
        let resultViewModel = QuizResultsViewModel(
            title: "Этот раунд окончен!",
            text: createResultMessage(answers: currentAnswers),
            buttonText: "Сыграть ещё раз")
        
        show(result: resultViewModel)
    }
    
    private func show(result model: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText) {
                self.currentAnswers = 0
                self.currentQuestionIndex = 0
                self.questionFactory?.requestNextQuestion()
            }
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    private func createResultMessage(answers: Int) -> String {
        return """
            Ваш результат: \(answers)/10
            Количество сыгранных квизов: \(statisticService.gamesCount)
            Рекорд: \(statisticService.bestGame.toString())
            Средняя точность: \(String(format: "%.2f", statisticService.totalAccuracy))%
            """
    }
}

//MARK: - QuestionFactoryDelegate Extension
extension MovieQuizViewController: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        guard let question else { return }
        
        currentQuestion = question
        let viewModel = convert(model: question)
        DispatchQueue.main.async { [weak self] in
            self?.show(viewModel: viewModel)
        }
    }
}
