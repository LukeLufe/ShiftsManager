//
//  MainViewController.swift
//  ShiftsManager
//
//  Created by Luke on 2022/3/31.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var currentYear = Calendar.current.component(.year, from: Date())
    var currentMonth = Calendar.current.component(.month, from: Date())
    var oldPage = 1
    var beginScrollPage = false
    var selectRowIndex: Int?
    let monthName = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
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
        collectionViewScrollToPage(1)
        beginScrollPage = true
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
        section.visibleItemsInvalidationHandler = sectionVisibleItemsInvalidationHandler
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    // MARK: - Scroll Section Hadler
    
    private func sectionVisibleItemsInvalidationHandler(visibleItems: [NSCollectionLayoutVisibleItem], scrollOffset: CGPoint,
                                                        layoutEnvironment: NSCollectionLayoutEnvironment) {
        if let newPage = Int(exactly: scrollOffset.x / collectionView.bounds.width), beginScrollPage {
            if newPage > oldPage {
                currentMonth += (newPage - oldPage)
                if currentMonth > 12 {
                    currentMonth = 1
                    currentYear += 1
                }
                if newPage == 4 {
                    collectionViewScrollToPage(1)
                    collectionView.reloadData()
                } else {
                    oldPage = newPage
                }
                selectRowIndex = nil
            } else if newPage < oldPage {
                currentMonth -= (oldPage - newPage)
                if currentMonth < 1 {
                    currentMonth = 12
                    currentYear -= 1
                }
                if newPage == 0 {
                    collectionViewScrollToPage(3)
                    collectionView.reloadData()
                } else {
                    oldPage = newPage
                }
                selectRowIndex = nil
            }
            title = "\(monthName[currentMonth - 1]) \(currentYear)"
        }
    }
    
    private func collectionViewScrollToPage(_ page: Int) {
        oldPage = page
        collectionView.scrollToItem(at: IndexPath(row: monthNumber * page + 1, section: 0), at: .left, animated: false)
    }
    
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return monthNumber * 5
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let monthIndex = indexPath.row % monthNumber
        if let cell = cell as? WeekCollectionViewCell, monthIndex < weekName.count {
            cell.titleLabel.text = weekName[monthIndex]
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
            configCellDate(cell, at: indexPath)
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

    private func configCellDate(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        guard let cell = cell as? CalenderCollectionViewCell else {
            return
        }
        let page = indexPath.row / monthNumber
        let dayOfMonthInfo = Date.dayOfMonth(year: currentYear, month: (currentMonth + page - oldPage))
        let dayOfLastMonthInfo = Date.dayOfMonth(year: currentYear, month: (currentMonth + page - oldPage - 1))
        let index = indexPath.row % monthNumber
        cell.dateView.backgroundColor = nil
        if index < (dayOfMonthInfo.weekday + 7) {
            cell.dateLabel.text = "\(index + dayOfLastMonthInfo.monthRange - dayOfMonthInfo.weekday - 6)"
            cell.dateLabel.alpha = 0.2
        } else if index < (dayOfMonthInfo.monthRange + 7 + dayOfMonthInfo.weekday) {
            let day = index - dayOfMonthInfo.weekday - 6
            cell.dateLabel.text = "\(day)"
            cell.dateLabel.alpha = 1.0
            if Date.confirmToday(year: currentYear, month: (currentMonth + page - oldPage),
                                 day: day) {
                cell.dateView.backgroundColor = .systemCyan
                cell.dateLabel.textColor = .white
            }
        } else {
            cell.dateLabel.text = "\(index - dayOfMonthInfo.monthRange - dayOfMonthInfo.weekday - 6)"
            cell.dateLabel.alpha = 0.2
        }
    }
    
}

extension MainViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectRowIndex = indexPath.row
        collectionView.reloadData()
    }
    
}
