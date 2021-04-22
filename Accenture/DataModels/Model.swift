//
//  Model.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import Foundation
// Accounts
struct AccountModel:Decodable {
    var accounts: [Acc]?
}
struct Acc:Decodable {
    let id: String?
    let currentBalance: String?
    let availableBalance: String?
    let productName: String?
}

// Transactions
struct TransactionsModel:Decodable {
    var transactions: [Transactions]?
}
struct Transactions:Decodable {
    let date: String?
    let description: String?
    let amount: String?
    let runningBalance: String?
    let processingStatus: String?
}

