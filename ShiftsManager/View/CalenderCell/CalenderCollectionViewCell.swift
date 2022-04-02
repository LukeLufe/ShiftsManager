//
//  CalenderCollectionViewCell.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/1.
//

import UIKit

class CalenderCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var dateView: UIView!
    
    var isFirstCell = false
    var lineHorizontalWidth = 0.6
    var lineVerticalWidth = 1.0
    var lineColor = UIColor.systemGray5
    
    override func awakeFromNib() {
        super.awakeFromNib()
        dateLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !isFirstCell {
            let lineLeftRect = CGRect(x: 0.0, y: 0.0 + lineHorizontalWidth,
                                      width: lineHorizontalWidth, height: frame.height - lineHorizontalWidth * 2)
            let linePath = UIBezierPath(rect: lineLeftRect)
            lineColor.setFill()
            linePath.fill()
        }
        let lineTopRect = CGRect(x: 0, y: 0, width: frame.width, height: lineVerticalWidth)
        let linePath = UIBezierPath(rect: lineTopRect)
        lineColor.setFill()
        linePath.fill()
    }
    
}
