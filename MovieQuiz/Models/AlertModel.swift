//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Alexey Kremnev on 9/4/24.
//

import Foundation

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: () -> Void
}
