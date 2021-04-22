//
//  ViewModel.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import Foundation

// Accounts
struct AccViewModel:Decodable, Equatable {
    let id: String?
    let currentBalance: String?
    let availableBalance: String?
    let productName: String?
}

// Transactions
struct TransactionsViewModel:Decodable, Equatable {
    var date: String
    let description: String?
    let amount: String?
    let runningBalance: String?
    let processingStatus: String?
    let newDate: Bool?
    let color: String?
}
