//
//  SchoolSchedulesUITests.swift
//  SchoolSchedulesUITests
//
//  Created by 多田桃大 on 2023/01/18.
//

import XCTest
import RealmSwift
@testable import SchoolSchedules

final class SchoolSchedulesUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        Realm.Configuration.defaultConfiguration.inMemoryIdentifier = self.name
        
        XCUIApplication().launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
                // UI tests must launch the application that they test.
                let app = XCUIApplication()
                app.launch()
        app.buttons["追加"].tap()
        
        let collectionViewsQuery = app.collectionViews
        collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Subject Name"]/*[[".cells.textFields[\"Subject Name\"]",".textFields[\"Subject Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let roomNumberTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Room Number"]/*[[".cells.textFields[\"Room Number\"]",".textFields[\"Room Number\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        roomNumberTextField.tap()
        roomNumberTextField.tap()
        
        let teacherNameTextField = collectionViewsQuery/*@START_MENU_TOKEN@*/.textFields["Teacher Name"]/*[[".cells.textFields[\"Teacher Name\"]",".textFields[\"Teacher Name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        teacherNameTextField.tap()
        teacherNameTextField.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.buttons["Term, Required"]/*[[".cells.buttons[\"Term, Required\"]",".buttons[\"Term, Required\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let app2 = app
        app2.toolbars["Toolbar"]/*@START_MENU_TOKEN@*/.buttons["追加"]/*[[".otherElements[\"ゴミ箱\"].buttons[\"追加\"]",".buttons[\"追加\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.navigationBars["New Term"]/*@START_MENU_TOKEN@*/.buttons["Save"]/*[[".otherElements[\"Save\"].buttons[\"Save\"]",".buttons[\"Save\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["2,023 Front Full"]/*[[".cells.staticTexts[\"2,023 Front Full\"]",".staticTexts[\"2,023 Front Full\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app2.navigationBars["Term List"]/*@START_MENU_TOKEN@*/.buttons["Select"]/*[[".otherElements[\"Select\"].buttons[\"Select\"]",".buttons[\"Select\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        teacherNameTextField.tap()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.staticTexts["SUBJECT SCHEDULE"]/*[[".cells.staticTexts[\"SUBJECT SCHEDULE\"]",".staticTexts[\"SUBJECT SCHEDULE\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeUp()
        collectionViewsQuery/*@START_MENU_TOKEN@*/.otherElements["Color"]/*[[".cells.otherElements[\"Color\"]",".otherElements[\"Color\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.children(matching: .other).element.children(matching: .button).element.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        elementsQuery.otherElements["パープル 49"].tap()
        elementsQuery.buttons["閉じる"].tap()
        collectionViewsQuery.staticTexts["1 (8:50 ~ 10:20)"].tap()
        

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
