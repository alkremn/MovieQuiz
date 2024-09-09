//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/4/24.
//

import UIKit

final class AlertPresenter {
    
    private let viewController: UIViewController
    
    init(viewController: UIViewController) {
        self.viewController = viewController
    }
    
    public func show(alertModel: AlertModel) {
        let alert = UIAlertController(
            title: alertModel.title,
            message: alertModel.message,
            preferredStyle: .alert
        )
        
        let alertAction = UIAlertAction(title: alertModel.buttonText, style: .default) { _ in
            alertModel.completion()
        }
        
        alert.addAction(alertAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}
