//
//  AddShiftTypeTableViewCell.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/6.
//

import UIKit

protocol AddShiftTypeTableViewCellDelegate: AnyObject {
    
    func didShiftTypeBtnPressed(_ sender: UIButton)
    
}

class AddShiftTypeTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var shiftTypeButton: UIButton!
    weak var delegate: AddShiftTypeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    @IBAction func shiftTypeBtnPressed(_ sender: UIButton) {
        delegate?.didShiftTypeBtnPressed(sender)
    }
    
}
