//
//  CleanData.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import Foundation
import UIKit
struct CleanData {
     
     func refactorAndInsertIntoViewModel(data: TransactionsModel, completion: @escaping(Result<[TransactionsViewModel], DataError>) -> Void) throws {
        var traData = [TransactionsViewModel]()
        if let tra = data.transactions {
            for a in tra {
                var colorToUse = ""
                var currentBalance = ""
                if let currentBalanceA = a.amount {
                    if let largeNumber = Double(currentBalanceA) {
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        if let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) {
                            currentBalance = formattedNumber
                        }
                    }
           // Determine if red or blue color to be displayed
                    if currentBalanceA.contains("-") {
                        colorToUse = "red"
                    } else { colorToUse = "blue" }
                }
                
                var availableBalance = "";
                if let availableBalanceA = a.runningBalance {
                    if let largeNumber = Double(availableBalanceA) {
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        if let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) {
                            availableBalance = formattedNumber
                        }
                    }
                }
                var processStatus = ""; if let processStatusA = a.processingStatus { processStatus = processStatusA }
                var desc = ""; if let descA = a.description { desc = descA }

        // Date Mods
        // INITIALLY WE JUST MAKE SURE THAT THERE IS A DATE ENTRY
                var date = ""
                if let dateA = a.date {
                    date = dateA
                    // need to make sure that there is a date. Skipping if there is not- this is a safety
                    if date != ""  {
                        let input = TransactionsViewModel(date: date, description: desc, amount: currentBalance, runningBalance: availableBalance, processingStatus: processStatus, newDate: true, color: colorToUse)
                        traData.append(input)
                    }
                }
            }
        } else { throw DataError.noDataAvailable }

        // SORT DATA BY Date
             var sortedArray = traData.sorted(by: {$0.date > $1.date})
             if sortedArray.count < 1 { throw DataError.noDataAvailable }
        // empty traData
             traData = []
             var dateHoldingString = ""
             var newDate = false
        // Reformate Date info
             for a in sortedArray {
                  var date = ""
                  let dateStringB = a.date
                  if dateStringB.count > 10 {
                      let startIndex = dateStringB.index(dateStringB.startIndex, offsetBy: 0)
                      let endIndex = dateStringB.index(dateStringB.startIndex, offsetBy: 9)
                      let numberToManip = String(dateStringB[startIndex...endIndex])
                      let dateFormatterGet = DateFormatter()
                          dateFormatterGet.dateFormat = "yyyy-MM-dd"
                      let dateFormatterPrint = DateFormatter()
                          dateFormatterPrint.dateFormat = "dd MMM yyyy"
                      if let date2 = dateFormatterGet.date(from: numberToManip) {
                             date = dateFormatterPrint.string(from: date2)
                      } else {}}
                 let des = a.description
                 let amount = a.amount
                 let runningBalance = a.runningBalance
                 let processingStatus = a.processingStatus
                 let color = a.color
                 if dateHoldingString == date { newDate = false } else { newDate = true }
            // re-enter previous data into ViewModel
                 if date != "" {
                 let input = TransactionsViewModel(date: date, description: des, amount: amount, runningBalance: runningBalance, processingStatus: processingStatus, newDate: newDate, color: color)
                     traData.append(input)
                     dateHoldingString = date
                 }
             }
             if traData.count < 1 { throw DataError.noDataAvailable }
             completion(.success(traData))
             traData = []
             sortedArray = []
    }
}

 
