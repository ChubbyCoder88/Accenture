//
//  AccountsVC.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import UIKit
import Combine
import Foundation
class AccountsVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var totalAvailableLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "AccountsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "AccountsCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        let cart = UIImage(systemName: "bell")
        let rightB = UIBarButtonItem(image: cart,
        style: .plain,
        target: self,
        action: #selector(doNothing))
        navigationItem.rightBarButtonItem = rightB
        dataApiCall()
    }
    
    private var usersSubscriper: AnyCancellable?
    private var accData = [AccViewModel]()
    @objc func doNothing() {}
    private func dataApiCall() {
        usersSubscriper = DataManager().usersPublisher
            .sink(receiveCompletion: { [weak self] finished in
                switch finished {
                case .failure(_): Alert.show(title: "There was an issue", message: "Please try later", vc: self ?? AccountsVC())
                case .finished: print("finished")
                }
             }, receiveValue: { [weak self] (data) in
                self?.refactorData(data: data)
                print("data", data)
             })
    }
    func refactorData(data: AccountModel) {
        do {
            let result = try inputIntoViewModel(data: data)
                accData = result
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.tableView.tableFooterView = UIView()
                self.updateTotalAvailable()
            }
        } catch { Alert.show(title: "There was an issue", message: "Please try later", vc: self) }
    }
    var totalAvailableBalance = 0.0
    var totalAvailableBalanceString = ""
    func inputIntoViewModel(data: AccountModel) throws -> [AccViewModel] {
        if let acc = data.accounts {
            for a in acc {
                var id = ""; if let idA = a.id { id = idA }
                var productName = ""; if let productNameA = a.productName { productName = productNameA }
                var currentBalance = ""
                if let currentBalanceA = a.currentBalance {
                    if let largeNumber = Double(currentBalanceA) {
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        if let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) {
                            currentBalance = formattedNumber
                        }
                    }
                }
                var availableBalance = ""
                if let availableBalanceA = a.availableBalance {
                    if let largeNumber = Double(availableBalanceA) {
                        totalAvailableBalance += largeNumber
                        let numberFormatter = NumberFormatter()
                        numberFormatter.numberStyle = .currency
                        if let formattedNumber = numberFormatter.string(from: NSNumber(value:largeNumber)) {
                            availableBalance = formattedNumber
                        }
                    }
                }
                let input = AccViewModel(id: id, currentBalance: currentBalance, availableBalance: availableBalance, productName: productName)
                accData.append(input)
            }
            if accData.count < 1 { throw DataError.noDataAvailable }
            return accData
        } else { throw DataError.noDataAvailable }
    }
    func updateTotalAvailable() {
            let numberFormatter = NumberFormatter()
            numberFormatter.numberStyle = .currency
            if let formattedNumber = numberFormatter.string(from: NSNumber(value:totalAvailableBalance)) {
                totalAvailableBalanceString = formattedNumber
                totalAvailableLabel.text = totalAvailableBalanceString
            }
    }
    var idPassing = "", productNamePassing = "", availableBalancePassing = "", currentBalancePassing = ""
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ToTransactionsVC" {
            let nextView = segue.destination as! TransactionsVC
                nextView.id = idPassing
                nextView.productName = productNamePassing
                nextView.availableBalance = availableBalancePassing
                nextView.currentBalance = currentBalancePassing
            }
        }
    }

extension AccountsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AccountsCell", for: indexPath) as! AccountsCell
        let data = accData[indexPath.row]
            cell.selectionStyle = .none
            cell.acTypelabel.text = data.productName
            cell.availableAmountlLabel.text = data.availableBalance
            cell.currentAmountLabel.text = data.currentBalance
            cell.referenceLabel.text = data.id
         if data.productName == "Saving" { cell.acImage.image = UIImage(systemName: "banknote.fill") }
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return accData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = accData[indexPath.row]
        if let passing = data.id {
            if let current = data.currentBalance {
                if let avail = data.availableBalance {
                    if let product = data.productName {
                        idPassing = passing
                        currentBalancePassing = current
                        availableBalancePassing = avail
                        productNamePassing = product
                        performSegue(withIdentifier: "ToTransactionsVC", sender: indexPath)
                    }
                }
            }
        }
    }
}

