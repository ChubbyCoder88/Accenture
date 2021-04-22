//
//  AccountsCell.swift
//  Accenture
//
//  Created by Matthew on 20/4/21.
//

import UIKit

class AccountsCell: UITableViewCell {
    @IBOutlet weak var acTypelabel: UILabel!
    @IBOutlet weak var availableTextLabel: UILabel!
    @IBOutlet weak var availableAmountlLabel: UILabel!
    @IBOutlet weak var currentTextLabel: UILabel!
    @IBOutlet weak var currentAmountLabel: UILabel!
    @IBOutlet weak var referenceLabel: UILabel!
    @IBOutlet weak var acImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        acImage.tintColor = UIColor.myGreen
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
