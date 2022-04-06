//
//  MainViewController.swift
//  ShiftsManager
//
//  Created by Luke on 2022/3/31.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Data
    
    var dateData = [DisplayDate]()
    var pageYear = Calendar.current.component(.year, from: Date())
    var pageMonth = Calendar.current.component(.month, from: Date())
    var oldPage = 1
    var beginScrollPage = false
    var selectRowIndex: Int?
    let monthName = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
    let weekName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weekNumber = 7
    let monthNumber = 49
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateData = configDateData(forYear: pageYear, currentMonth: pageMonth)
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
        if let newPage = Int(exactly: scrollOffset.x / collectionView.bounds.width), beginScrollPage, newPage != oldPage {
            pageMonth += newPage - oldPage
            if pageMonth > 12 {
                pageMonth = 1
                pageYear += 1
            } else if pageMonth < 1 {
                pageMonth = 12
                pageYear -= 1
            }
            dateData = configDateData(forYear: pageYear, currentMonth: pageMonth)
            collectionViewScrollToPage(1)
            collectionView.reloadData()
            selectRowIndex = nil
        }
        title = "\(monthName[pageMonth - 1]) \(pageYear)"
    }
    
    private func collectionViewScrollToPage(_ page: Int) {
        oldPage = page
        collectionView.scrollToItem(at: IndexPath(row: monthNumber * page + 1, section: 0), at: .left, animated: false)
    }
    
    // MARK: Config Date Data
    
    private func configDateData(forYear currentYear: Int, currentMonth: Int, monthNumber: Int = 49) -> [DisplayDate] {
        var newDateData = [DisplayDate]()
        for page in 0...2 {
            let pageMonth = currentMonth + page - 1
            let dayOfMonthInfo = Date.dayOfMonth(year: currentYear, month: pageMonth)
            let dayOfLastMonthInfo = Date.dayOfMonth(year: currentYear, month: pageMonth - 1)
            for index in 0..<monthNumber {
                if index < 7 {
                    let displayDate = DisplayDate(date: Date())
                    newDateData.append(displayDate)
                } else {
                    let date: Date
                    let isPageMonth: Bool
                    if index < (dayOfMonthInfo.weekday + 7) {
                        let day = index + dayOfLastMonthInfo.monthRange - dayOfMonthInfo.weekday - 6
                        date = Date.date(FromComponents: currentYear, month: pageMonth - 1, day: day)
                        isPageMonth = false
                    } else if index < (dayOfMonthInfo.monthRange + 7 + dayOfMonthInfo.weekday) {
                        let day = index - dayOfMonthInfo.weekday - 6
                        date = Date.date(FromComponents: currentYear, month: pageMonth, day: day)
                        isPageMonth = true
                    } else {
                        let day = index - dayOfMonthInfo.monthRange - dayOfMonthInfo.weekday - 6
                        date = Date.date(FromComponents: currentYear, month: pageMonth + 1, day: day)
                        isPageMonth = false
                    }
                    let displayDate = DisplayDate(date: date, isPageMonth: isPageMonth)
                    newDateData.append(displayDate)
                }
            }
        }
        return newDateData
    }
    
}

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
            cell.dateLabel.textColor = Date.confirmToday(date: displayeDate.date) ? .white : .black
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
