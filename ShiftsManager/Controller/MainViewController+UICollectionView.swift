//
//  MainViewController+UICollectionView.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/6.
//

import UIKit

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dateData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: UICollectionViewCell
        if (indexPath.row % monthNumber) < weekNumber {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellWeekId, for: indexPath)
        } else {
            cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellCalenderId, for: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let dateIndex = indexPath.row % monthNumber
        if let cell = cell as? WeekCollectionViewCell, dateIndex < weekName.count {
            cell.titleLabel.text = weekName[dateIndex]
            if indexPath.row % weekNumber == 0 {
                cell.titleLabel.textColor = .systemRed
            } else if indexPath.row % weekNumber == 6 {
                cell.titleLabel.textColor = .systemGreen
            } else {
                cell.titleLabel.textColor = .black
            }
        } else if let cell = cell as? CalenderCollectionViewCell {
            if indexPath.row % weekNumber == 0 {
                cell.dateLabel.textColor = .systemRed
                cell.isFirstCell = true
            } else if indexPath.row % weekNumber == 6 {
                cell.dateLabel.textColor = .systemGreen
                cell.isFirstCell = false
            } else {
                cell.dateLabel.textColor = .black
                cell.isFirstCell = false
            }
            cell.setNeedsDisplay()
            confirmSelectCell(cell, at: indexPath)
            
            let displayeDate = dateData[indexPath.row]
            cell.dateLabel.text = "\(displayeDate.date.toDayString())"
            cell.dateLabel.alpha = displayeDate.isPageMonth ? 1.0 : 0.2
            cell.dateView.backgroundColor = Date.confirmToday(date: displayeDate.date) ? .systemCyan : nil
            cell.dateLabel.textColor = Date.confirmToday(date: displayeDate.date) ? .white : cell.dateLabel.textColor
        }
    }
    
    private func confirmSelectCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        if indexPath.row == selectRowIndex {
            UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.3, delay: 0.0) {
                cell.contentView.layer.borderColor = UIColor.systemBlue.cgColor
                cell.contentView.layer.borderWidth = 2.5
            }
        } else {
            cell.contentView.layer.borderColor = nil
            cell.contentView.layer.borderWidth = 0
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRowIndex = indexPath.row
        collectionView.reloadData()
        
        // test
        didSelectDate(didSelectItemAt: indexPath)
    }
    
    func didSelectDate(didSelectItemAt indexPath: IndexPath) {
        let displayeDate = dateData[indexPath.row]
        let alert = UIAlertController(title: "測試日期", message: "\(displayeDate.date.toString())", preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
}
