//
//  AccentureTests.swift
//  AccentureTests
//
//  Created by Matthew on 20/4/21.
//

import XCTest
@testable import Accenture

class AccentureTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    // AccountsVC()
    // checking that AccountsVC inputIntoViewModel() will not throw if data is correct.
    func testAccountsVCCorrectApiDataWillNotThrow() throws {
        let acc = AccountsVC()
        let model = AccountModel(accounts: [Accenture.Acc(id: "098765", currentBalance: "25238.24", availableBalance: "8238.70", productName: "Saving"), Accenture.Acc(id: "12345", currentBalance: "500.01", availableBalance: "500.01", productName: "Spending"), Accenture.Acc(id: "135790", currentBalance: "-469.01", availableBalance: "1500.00", productName: "Spending")])
            XCTAssertNoThrow(try acc.inputIntoViewModel(data: model))
    }
    
    
    // checking if AccountsVC inputIntoViewModel() will throw if data is empty
    // checking if error code thrown is equal to DataError.noDataAvailable
    func testAccountsVCEmptyDataThrowsAndTestErrorCode() throws {
        let acc = AccountsVC()
        let data = AccountModel()
        let expectedError = DataError.noDataAvailable
        var error: DataError?
        XCTAssertThrowsError(try acc.inputIntoViewModel(data: data)) {
            thrownError in
            error = thrownError as? DataError
        }
        XCTAssertEqual(expectedError, error)
    }
    
    // TransactionsVC()
    // checking that data with all empty data will throw an error *if you don't have dates you can't order the data
    func testThatDataWithAllEmptyDatesThrows() throws {
        var error: ValidationError?
        let clean = CleanData()
        var model = TransactionsModel(transactions: [Accenture.Transactions(date: "", description: "Bed, Bath & Table-Hold for POS debits", amount: "-10.70", runningBalance: nil, processingStatus: "PENDING"), Accenture.Transactions(date: "", description: "V7110 Hotel Clarendon Surry Hills Ref: 205944", amount: "-27.70", runningBalance: "8500.00", processingStatus: "POSTED"), Accenture.Transactions(date: "", description: "Salary", amount: "6.91", runningBalance: "1270.54", processingStatus: "POSTED")])
        
        XCTAssertThrowsError(try clean.refactorAndInsertIntoViewModel(data: model, completion: { (data) in
        })) {
            thrownError in
            error = thrownError as? ValidationError
        }
    }
    // checking if CleanData() refactorAndInsertIntoViewMode() will throw if data is empty
    func testThatEmptyDataWillThrow() throws {
        let clean = CleanData()
        let model = TransactionsModel()
        XCTAssertThrowsError(try clean.refactorAndInsertIntoViewModel(data: model, completion: { (data) in
        })) {
            thrownError in
        }
    }
    
    // 1) checking that  CleanData() refactorAndInsertIntoViewMode() will not throw if data is correct.
    // 2) checking that the data is date ordered correctly
    // 3) check that incorrect date order is not the same as the results from 1)
    // 4) check that the date is being refactored correctly
    func testCorrectApiDataWillNotThrowAndDataIsDateOrderedCorrectly() throws {
        // Checking if  ->  CorrectDataWillNotThrow
        var traData = [TransactionsViewModel]()
        let clean = CleanData()
        let model = TransactionsModel(transactions: [Accenture.Transactions(date: "2021-03-11T07:42:18Z", description: "Bed, Bath & Table-Hold for POS debits", amount: "-10.70", runningBalance: nil, processingStatus: "PENDING"), Accenture.Transactions(date: "2021-03-11T06:42:18Z", description: "V7110 Hotel Clarendon Surry Hills Ref: 205944", amount: "-27.70", runningBalance: "8500.00", processingStatus: "POSTED"), Accenture.Transactions(date: "2021-03-09T06:42:18Z", description: "Salary", amount: "6.91", runningBalance: "1270.54", processingStatus: "POSTED")])
//      1)
        XCTAssertNoThrow(try clean.refactorAndInsertIntoViewModel(data: model, completion: { (result) in
switch result {
                case .failure(let error): print("error", error)
                case .success(let data1): traData = data1
              }
        }))
//      Checking if  -> DataIsDateOrderedCorrectly
        var reOrderedData = [TransactionsViewModel]()
        let a = TransactionsViewModel(date: "11 Mar 2021", description: "Bed, Bath & Table-Hold for POS debits", amount: "-$10.70", runningBalance: "", processingStatus: "PENDING", newDate: true, color: "red")
        let b = TransactionsViewModel(date: "11 Mar 2021", description: "V7110 Hotel Clarendon Surry Hills Ref: 205944", amount: "-$27.70", runningBalance: "$8,500.00", processingStatus: "POSTED", newDate: false, color: "red")
        let c = TransactionsViewModel(date: "09 Mar 2021", description: "Salary", amount: "$6.91", runningBalance: "$1,270.54", processingStatus: "POSTED", newDate: true, color: "blue")
        reOrderedData.append(a)
        reOrderedData.append(b)
        reOrderedData.append(c)
       
//      2) This is the correct date order
        XCTAssertEqual(reOrderedData, traData)
//
        var reOrderedDataIncorrect = [TransactionsViewModel]()
        reOrderedDataIncorrect.append(a)
        reOrderedDataIncorrect.append(c)
        reOrderedDataIncorrect.append(b)
        
//      3) // This is the incorrect date order
        XCTAssertNotEqual(reOrderedDataIncorrect, traData)

//      4)
        // check if refactoring is correct - "09 Mar 202" instead off 09 Mar 2021
        let d = TransactionsViewModel(date: "09 Mar 202", description: "Salary", amount: "$6.91", runningBalance: "$1,270.54", processingStatus: "POSTED", newDate: true, color: "blue")
        var refactoredCorrectly = [TransactionsViewModel]()
        refactoredCorrectly.append(a)
        refactoredCorrectly.append(b)
        refactoredCorrectly.append(d)
        // This confirms that even a slight change in date results is noticed
        XCTAssertNotEqual(refactoredCorrectly, traData)
    }
    
    // testing that a negative amount will always have a red color assinged.
    func testNegativeAmountHasRedColor() throws {
        var traData = [TransactionsViewModel]()
        let clean = CleanData()
        let model = TransactionsModel(transactions: [Accenture.Transactions(date: "2021-03-11T07:42:18Z", description: "Bed, Bath & Table-Hold for POS debits", amount: "-10.70", runningBalance: nil, processingStatus: "PENDING")])

        XCTAssertNoThrow(try clean.refactorAndInsertIntoViewModel(data: model, completion: { (result) in
switch result {
                case .failure(let error): print("error", error)
                case .success(let data1): traData = data1
              }
        }))
        var color = traData[0].color
        var colorShouldBe = "red"
        if let color = color {
            XCTAssertEqual(colorShouldBe, color)
            XCTAssertNotEqual(colorShouldBe, "blue")
        }
    }
    
    // testing that a postive amount will always have a blue color assinged.
    func testPositiveAmountHasBlueColor() throws {
        var traData = [TransactionsViewModel]()
        let clean = CleanData()
        let model = TransactionsModel(transactions: [Accenture.Transactions(date: "2021-03-09T06:42:18Z", description: "Salary", amount: "6.91", runningBalance: "1270.54", processingStatus: "POSTED")])

        XCTAssertNoThrow(try clean.refactorAndInsertIntoViewModel(data: model, completion: { (result) in
switch result {
                case .failure(let error): print("error", error)
                case .success(let data1): traData = data1
              }
        }))
        var color = traData[0].color
        var colorShouldBe = "blue"
        if let color = color {
            XCTAssertEqual(colorShouldBe, color)
            XCTAssertNotEqual(colorShouldBe, "red")
        }
    } 
}
