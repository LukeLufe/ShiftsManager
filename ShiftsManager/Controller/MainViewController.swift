//
//  MainViewController.swift
//  ShiftsManager
//
//  Created by Luke on 2022/3/31.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var selectRowIndex = 0
    let weekName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weekNumber = 7
    let monthNumber = 49
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registCell()
        configCollectionView()
    }
    
    private func configCollectionView() {
        collectionView.isScrollEnabled = false
        collectionView.collectionViewLayout = generateLayout()
        collectionView.scrollToItem(at: IndexPath(row: 50, section: 0), at: .left, animated: false)
    }
    
    // MARK: - Regist Cell
    
    private let cellCalenderId = "cellCalenderId"
    private let cellWeekId = "cellWeekId"
    
    private func registCell() {
        let cellCalenderNib = UINib(nibName: NibName.calenderCollectionViewCell, bundle: nil)
        collectionView.register(cellCalenderNib, forCellWithReuseIdentifier: cellCalenderId)
        let cellWeekNib = UINib(nibName: NibName.weekCollectionViewCell, bundle: nil)
        collectionView.register(cellWeekNib, forCellWithReuseIdentifier: cellWeekId)
    }
    
    // MARK: - Generate Compositional Layout
    
    private func generateLayout() -> UICollectionViewLayout {
        let itemCalenderSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalHeight(1))
        let itemCalender = NSCollectionLayoutItem(layoutSize: itemCalenderSize)
        let weekGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.95/6))
        let weekGroup = NSCollectionLayoutGroup.horizontal(layoutSize: weekGroupSize, subitems: [itemCalender])
        
        let itemWeekSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/7), heightDimension: .fractionalHeight(1))
        let itemWeek = NSCollectionLayoutItem(layoutSize: itemWeekSize)
        let weekNameGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.05))
        let weekNameGroup = NSCollectionLayoutGroup.horizontal(layoutSize: weekNameGroupSize, subitems: [itemWeek])
        
        let monthGroupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let subitems = [weekNameGroup] + Array(repeating: weekGroup, count: 6)
        let monthGroup = NSCollectionLayoutGroup.vertical(layoutSize: monthGroupSize, subitems: subitems)
        monthGroup.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5)
        
        let section = NSCollectionLayoutSection(group: monthGroup)
        section.orthogonalScrollingBehavior = .paging
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 147
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let monthIndex = indexPath.row % monthNumber
        if let cell = cell as? WeekCollectionViewCell, monthIndex < weekName.count {
            cell.titleLabel.text = weekName[monthIndex]
        } else if let cell = cell as? CalenderCollectionViewCell {
            if indexPath.row % weekNumber == 0 {
                cell.isFirstCell = true
            } else {
                cell.isFirstCell = false
            }
            cell.setNeedsDisplay()
            didSelectCell(cell, at: indexPath)
        }
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
    
    private func didSelectCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
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
    }
    
}
