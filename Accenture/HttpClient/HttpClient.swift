//
//  HttpClient.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import Foundation
import Combine
// Acccounts
class DataManager {
    private let urlString = "https://www.ubank.com.au/content/dam/ubank/mobile/coding/accounts.json"
    var usersPublisher: AnyPublisher<AccountModel, Error> {
        let url = URL(string: urlString)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: AccountModel.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        }
    }

// Transactions
class DataManagerTransactions {
    var urlStringA = ""
    init(id: String) { urlStringA = "https://www.ubank.com.au/content/dam/ubank/mobile/coding/transactions_\(id).json" }
    var usersPublisher: AnyPublisher<TransactionsModel, Error> {
        let url = URL(string: urlStringA)!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: TransactionsModel.self, decoder: JSONDecoder())
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
        }
    }

enum DataError:Error {
    case noDataAvailable
}
enum ValidationError: LocalizedError {
    case invalidValue
}
