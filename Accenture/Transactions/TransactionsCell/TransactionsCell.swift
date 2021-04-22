//
//  TransactionsCell.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import UIKit

class TransactionsCell: UITableViewCell {
    @IBOutlet weak var topBackgroundLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var processLabel: UILabel!
    @IBOutlet weak var balanceLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var data: TransactionsViewModel! {
        didSet {
            dateLabel.text = data.date
            descLabel.text = data.description
            balanceLabel.text = data.runningBalance
            amountLabel.text = data.amount
            processLabel.text = data.processingStatus
            if let color = data.color { amountLabel.textColor = Add().getColor(color: color) }
            }
        }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        topBackgroundLabel.backgroundColor = UIColor.myGreen
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
