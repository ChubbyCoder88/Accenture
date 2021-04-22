//
//  TransactionsVC.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import UIKit
import Combine
import Foundation
class TransactionsVC: UIViewController {
    @IBOutlet weak var acImage: UIImageView!
    @IBOutlet weak var acTypelabel: UILabel!
    @IBOutlet weak var availableAmountlLabel: UILabel!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    var id = "",  productName = "", availableBalance = "", currentBalance = ""
    var clean = CleanData()
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: "TransactionsCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TransactionsCell")
        let nib2 = UINib(nibName: "TransactionsSmallCell", bundle: nil)
        tableView.register(nib2, forCellReuseIdentifier: "TransactionsSmallCell")
        tableView.delegate = self
        tableView.dataSource = self
        self.navigationController?.navigationBar.tintColor = UIColor.white
        if id != "" { dataApiCall(id: id) }
        acTypelabel.text = productName; availableAmountlLabel.text = availableBalance; currentAmountLabel.text = currentBalance;
        if productName == "Saving" { acImage.image = UIImage(systemName: "banknote.fill") }
        acImage.tintColor = UIColor.myGreen
    }

    private var usersSubscriper: AnyCancellable?
    private var traData = [TransactionsViewModel]()
    private func dataApiCall(id: String) {
         usersSubscriper = DataManagerTransactions(id: id).usersPublisher
            .sink(receiveCompletion: { [weak self] _ in }, receiveValue: { [weak self] (data) in
                self?.refactorData(data: data)
            })
    }
    func refactorData(data: TransactionsModel) {
        do {
            try clean.refactorAndInsertIntoViewModel(data: data, completion: { [weak self] (result) in
            switch result {
                case .failure(let error): print("error", error)
                case .success(let data1): self?.traData = data1;
                    DispatchQueue.main.async {
                        self?.tableView.reloadData();
                        self?.tableView.tableFooterView = UIView()
                    }
              }})
        } catch { Alert.show(title: "There was an issue", message: "Please try later", vc: self) }
    }
}
extension TransactionsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let data = traData[indexPath.row]
         if data.newDate == true {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsCell", for: indexPath) as! TransactionsCell
                cell.data = data
                cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionsSmallCell", for: indexPath) as! TransactionsSmallCell
                cell.data = data
                cell.selectionStyle = .none
            return cell
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return traData.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if traData[indexPath.row].newDate == true { return 100 } else { return 80 }
    }
}
