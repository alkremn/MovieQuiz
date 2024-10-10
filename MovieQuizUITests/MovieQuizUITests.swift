//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Alexey Kremnev on 10/6/24.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation

        app.buttons["Yes"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotNil(firstPoster)
        XCTAssertNotNil(secondPoster)
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"].screenshot().pngRepresentation

        app.buttons["No"].tap()
        sleep(3)
        let secondPoster = app.images["Poster"].screenshot().pngRepresentation
        
        XCTAssertNotNil(firstPoster)
        XCTAssertNotNil(secondPoster)
        XCTAssertNotEqual(firstPoster, secondPoster)
    }
    
    func testIndexLabel() {
        sleep(3)
        app.buttons["Yes"].tap()
        sleep(3)
        let indexLabel = app.staticTexts["Index"]
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testResultAlertVisible() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["ResultAlert"]
        
        XCTAssertTrue(alert.exists)
        XCTAssertEqual(alert.label, "Этот раунд окончен!")
        XCTAssertEqual(alert.buttons.firstMatch.label, "Сыграть ещё раз")
    }
    
    func testResultAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            app.buttons["Yes"].tap()
            sleep(2)
        }
        
        let alert = app.alerts["ResultAlert"]
        alert.buttons.firstMatch.tap()
        
        sleep(2)
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertFalse(alert.exists)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
}
