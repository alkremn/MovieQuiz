import UIKit

final class MovieQuizViewController: UIViewController, MovieQuizViewControllerProtocol {
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var textLabel: UILabel!
    @IBOutlet private var counterLabel: UILabel!
    @IBOutlet private weak var noButton: UIButton!
    @IBOutlet private weak var yesButton: UIButton!
    @IBOutlet private var loadingIndicator: UIActivityIndicatorView!
    
    private var presenter: MovieQuizPresenter?
    private var alertPresenter: AlertPresenter?
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupInitial()
    }
    
    //MARK: - Actions
    
    @IBAction private func answerButtonClicked(_ sender: Any) {
        guard let answerButton = sender as? UIButton  else { return }
        presenter?.answerButtonClicked(isYes: answerButton == yesButton)
    }
    
    //MARK: - Public methods

    func show(viewModel: QuizStepViewModel) {
        imageView.layer.borderColor = UIColor.clear.cgColor
        imageView.image = viewModel.image
        textLabel.text = viewModel.question
        counterLabel.text = viewModel.questionNumber
        noButton.isEnabled = true
        yesButton.isEnabled = true
    }
    
    func show(result model: QuizResultsViewModel) {
        let alertModel = AlertModel(
            title: model.title,
            message: model.text,
            buttonText: model.buttonText,
            completion: model.completion)
        
        alertPresenter?.show(alertModel: alertModel)
    }
    
    func highlightImageBorder(isCorrect: Bool) {
        imageView.layer.borderWidth = 8
        imageView.layer.borderColor = UIColor(resource: isCorrect ? .ypGreen : .ypRed).cgColor
        noButton.isEnabled = false
        yesButton.isEnabled = false
    }
    
    func showLoadingIndicator() {
        loadingIndicator.isHidden = false
        loadingIndicator.startAnimating()
    }
    
    func hideLoadingIndicator() {
        loadingIndicator.isHidden = true
        loadingIndicator.stopAnimating()
    }
    
    func showNetworkError(message: String, completion: @escaping () -> Void) {
        let alertModel = AlertModel(title: "Ошибка",
                                    message: message,
                                    buttonText: "Попробовать ещё раз",
                                    completion: completion)
            
        alertPresenter?.show(alertModel: alertModel)
    }
    
    
    //MARK: - Private functions
    private func setupInitial() {
        presenter = MovieQuizPresenter(viewController: self)
        alertPresenter = AlertPresenter(viewController: self)
        textLabel.text = ""
    }
}
