//
//  TransactionsSmallCell.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import UIKit

class TransactionsSmallCell: UITableViewCell {
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var balanceLabel2: UILabel!
    var data: TransactionsViewModel! {
        didSet {
            balanceLabel2.text = ""
            selectionStyle = .none
            descLabel.text = data.description
            balanceLabel2.text = data.runningBalance
            amountLabel.text = data.amount
            processLabel.text = data.processingStatus
            if let color = data.color { amountLabel.textColor = Add().getColor(color: color) }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
