//
//  _0260911_PMUITests.swift
//  20260911_PMUITests
//
//  Created by competitor on 2026/9/11.
//

import XCTest

final class _0260911_PMUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        test()
    }
    func test(){
        let app = XCUIApplication()
        app.activate()
        log(1, "Application startup")
        app.cells/*@START_MENU_TOKEN@*/.element(boundBy: 5)/*[[".element(boundBy: 5)",".containing(.staticText, identifier: \"7.0\").firstMatch",".containing(.staticText, identifier: \"L'Appart à Méribel\").firstMatch",".containing(.image, identifier: \"cover\/1009\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[3]]@END_MENU_TOKEN@*/.swipeUp()
        log(2, "Scroll to the bottom of the hotel list")
        let textField = app/*@START_MENU_TOKEN@*/.textFields["Search a hotel name"]/*[[".otherElements.textFields[\"Search a hotel name\"]",".textFields",".textFields[\"Search a hotel name\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        UIPasteboard.general.string = "Méribel"
        textField.firstMatch.tap()
        textField.typeText("Méribel")
        log(3, "Perform a search after entering the search term in the search bar")
        app.buttons.matching(identifier: "Book it").element(boundBy: 0).tap()
log(4, "Click the listing item \"Appartement Méribel\"")
        app.scrollViews/*@START_MENU_TOKEN@*/.containing(.staticText, identifier: "S").firstMatch/*[[".element(boundBy: 1)",".containing(.staticText, identifier: \"T\").firstMatch",".containing(.staticText, identifier: \"Simon\").firstMatch",".containing(.staticText, identifier: \"S\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.swipeLeft()
        log(5, "Click the Guest reviews tab button")
        let scrollViewsQuery = app.scrollViews
        scrollViewsQuery/*@START_MENU_TOKEN@*/.containing(.staticText, identifier: "Simon").firstMatch/*[[".element(boundBy: 1)",".containing(.staticText, identifier: \"T\").firstMatch",".containing(.staticText, identifier: \"Simon\").firstMatch",".containing(.staticText, identifier: \"S\").firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[1]]@END_MENU_TOKEN@*/.swipeLeft()
        app/*@START_MENU_TOKEN@*/.staticTexts["Simon"]/*[[".otherElements.staticTexts[\"Simon\"]",".staticTexts[\"Simon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.swipeLeft()
        app.staticTexts["Kerem"].firstMatch.swipeLeft()
        log(6, "Scroll down the Reviews list to the 4th Review (published by \"Miles\")")
        app/*@START_MENU_TOKEN@*/.buttons["Room Selection"]/*[[".segmentedControls.buttons[\"Room Selection\"]",".buttons[\"Room Selection\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        log(7, "Click the Room selection label button")
        let element = scrollViewsQuery/*@START_MENU_TOKEN@*/.firstMatch/*[[".containing(.staticText, identifier: \"Booking\").firstMatch",".containing(.image, identifier: \"chevron.left\").firstMatch",".containing(.other, identifier: nil).firstMatch",".firstMatch"],[[[-1,3],[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        element.swipeUp()
        element.tap()
      log(8, "Scroll down the room list to the \"Great Family Room\" item")
        app/*@START_MENU_TOKEN@*/.staticTexts["Bed: 1 large double bed and 1 single bed, Total number of guest: 3"]/*[[".otherElements.staticTexts[\"Bed: 1 large double bed and 1 single bed, Total number of guest: 3\"]",".staticTexts[\"Bed: 1 large double bed and 1 single bed, Total number of guest: 3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        
       log(9, "Click the \"Great Family Room\" item")
        
        let firstNm = app/*@START_MENU_TOKEN@*/.textFields["first name"]/*[[".otherElements.textFields[\"first name\"]",".textFields[\"first name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        firstNm.firstMatch.tap()
        firstNm.typeText("Tylor")
        log(10, "Enter First Name")
        let element6 = app/*@START_MENU_TOKEN@*/.buttons["Return"]/*[[".otherElements",".buttons[\"return\"]",".buttons[\"Return\"]"],[[[-1,2],[-1,1],[-1,0,1]],[[-1,2],[-1,1]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        
        let lastNm = app/*@START_MENU_TOKEN@*/.textFields["last name"]/*[[".otherElements.textFields[\"last name\"]",".textFields[\"last name\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        lastNm.firstMatch.tap()
        lastNm.typeText("Hutchinson")
        element6.tap()
        log(11, "Enter Last Name")
        let checkin = app/*@START_MENU_TOKEN@*/.textFields["check-in"]/*[[".otherElements.textFields[\"check-in\"]",".textFields[\"check-in\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        checkin.firstMatch.tap()
        checkin.typeText("Oct 15 2024")
        element6.tap()
        log(12, "Enter check-in date")
        let checkout = app/*@START_MENU_TOKEN@*/.textFields["check-out"]/*[[".otherElements.textFields[\"check-out\"]",".textFields[\"check-out\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        checkout.firstMatch.tap()
        checkout.typeText("2024/2/10")
log(13, "Enter check-out date")
        element6.tap()
        let ad = app/*@START_MENU_TOKEN@*/.textFields["adults"]/*[[".otherElements.textFields[\"adults\"]",".textFields[\"adults\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        ad.firstMatch.tap()
        ad.typeText("4")
      log(14, "Enter the number of adults")
        app/*@START_MENU_TOKEN@*/.textFields["childrens"]/*[[".otherElements.textFields[\"childrens\"]",".textFields[\"childrens\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        app/*@START_MENU_TOKEN@*/.keys["3"]/*[[".otherElements.keys[\"3\"]",".keys[\"3\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        log(15, "Enter the number of children")
       
       
        let imagesQuery = app.images
       
        app/*@START_MENU_TOKEN@*/.staticTexts["Check-out date"]/*[[".otherElements.staticTexts[\"Check-out date\"]",".staticTexts[\"Check-out date\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.swipeUp()
        imagesQuery.matching(identifier: "circle").element(boundBy: 2).tap()
        log(16, "Click the E-Pay radio button")
      
        app/*@START_MENU_TOKEN@*/.buttons["Book Now"]/*[[".scrollViews.buttons",".otherElements.buttons[\"Book Now\"]",".buttons[\"Book Now\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
log(17, "Click the \"Book now\" button")
        checkout.firstMatch.tap()
        let element2 = app/*@START_MENU_TOKEN@*/.keys["delete"]/*[[".otherElements.keys[\"delete\"]",".keys[\"delete\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        element2.tap()
        checkout.typeText("10-16-2024")
     log(18, "Change check-out date")
     
                
        element6.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Book Now"]/*[[".otherElements.buttons[\"Book Now\"]",".buttons",".buttons[\"Book Now\"]"],[[[-1,2],[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
        log(19, "Click the \"Book now\" button")
        app/*@START_MENU_TOKEN@*/.buttons["Yes"]/*[[".otherElements.buttons[\"Yes\"]",".buttons[\"Yes\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.firstMatch.tap()
     log(20, "Click \"Yes\" in the pop-up window to confirm your reservation.")
        
    }
    func log(_ step: Int,_ desc: String){
        print("Step \(step): \(desc)")
        Thread.sleep(forTimeInterval: 10)
    }
}
