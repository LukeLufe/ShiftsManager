//
//  MainViewController.swift
//  ShiftsManager
//
//  Created by Luke on 2022/3/31.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewBottomLayout: NSLayoutConstraint!
    @IBOutlet weak var editShiftDateView: UIView!
    @IBOutlet weak var editShiftDateViewHightLayout: NSLayoutConstraint!
    lazy var editShiftDateViewHight: CGFloat = view.bounds.height * 0.2
    
    // MARK: - Date Data
    
    var dateData = [DisplayDate]()
    var pageYear = Calendar.current.component(.year, from: Date())
    var pageMonth = Calendar.current.component(.month, from: Date())
    var oldPage = 1
    var beginScrollPage = false
    var selectRowIndex: Int? {
        didSet {
            drawLine()
        }
    }
    var todayIndex: Int = 0
    let monthName = ["January", "February", "March", "April", "May", "June",
                     "July", "August", "September", "October", "November", "December"]
    let weekName = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    let weekNumber = 7
    let monthNumber = 49
    
    // MARK: - Shift Data
    
    var shiftTypeData = [ShiftType]()
    var shiftDateData = [ShiftDate]()
    
    // MARK: - ViewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        readFromCoreData()
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
    
    // MARK: - Read CoreData
    
    private func readFromCoreData() {
        let manager = CoreDataManager.shared
        do {
            shiftTypeData = try manager.read(fetchRequest: ShiftType.fetchRequest())
            shiftDateData = try manager.read(fetchRequest: ShiftDate.fetchRequest())
        } catch {
            print("readFromCoreData: \(error)")
        }
    }
    
    // MARK: - ToolBar Button
    
    @IBAction func addShiftTypeBtnPressed(_ sender: Any) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: StoryboardId.addShiftTypeVc)
            as? AddShiftTypeViewController {
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            vc.delegate = self
            present(vc, animated: true)
        }
    }
    
    @IBAction func editShiftDateBtnPressed(_ sender: Any) {
        let hight: CGFloat
        if editShiftDateView.isHidden {
            editShiftDateView.isHidden = false
            hight = editShiftDateViewHight
        } else {
            editLineIsHidden = true
            hight = 0
        }
        editShiftDateViewHightLayout.constant = hight
        collectionViewBottomLayout.constant = -hight
        UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.2, delay: 0.0) { [weak self] in
            self?.view.layoutIfNeeded()
        } completion: { [weak self] _ in
            if self?.selectRowIndex == nil {
                self?.selectRowIndex = self?.todayIndex
            }
            if hight == 0 {
                self?.editShiftDateView.isHidden = true
                self?.selectRowIndex = nil
            } else {
                self?.editLineIsHidden = false
            }
            self?.collectionView.reloadData()
        }
    }
    
    var editLine: CAShapeLayer?
    var editLineIsHidden = true {
        didSet {
            drawLine()
        }
    }
    
    func drawLine() {
        editLine?.removeFromSuperlayer()
        guard !editLineIsHidden, let selectRowIndex = selectRowIndex,
        let cell = collectionView.cellForItem(at: IndexPath(row: selectRowIndex, section: 0)) else {
            return
        }
        editLine = CAShapeLayer()
        editLine?.strokeColor = UIColor.systemBlue.cgColor
        editLine?.lineWidth = 3.0
        editLine?.lineDashPattern = [3, 3]
        let lineAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineAnimation.fromValue = editLine?.lineDashPattern?.reduce(0, { $0 + $1.intValue })
        lineAnimation.toValue = 0
        lineAnimation.duration = 0.3
        lineAnimation.repeatCount = .infinity
        editLine?.add(lineAnimation, forKey: nil)
        let startPoint = CGPoint(x: editShiftDateView.frame.midX, y: editShiftDateView.frame.minY)
        let cellRect = cell.convert(CGRect(x: 0.0, y: 0.0, width: cell.bounds.width, height: cell.bounds.height), to: view)
        let endPoint = CGPoint(x: cellRect.midX, y: cellRect.maxY)
        let path = CGMutablePath()
        path.addLines(between: [startPoint, endPoint])
        editLine?.path = path
        if let editLine = editLine {
            view.layer.addSublayer(editLine)
        }
    }
    
    // MARK: - Regist Cell
    
    let cellCalenderId = "cellCalenderId"
    let cellWeekId = "cellWeekId"
    
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
    
    // MARK: - Config Date Data
    
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

// MARK: - Add ShiftType Did Finish

extension MainViewController: AddShiftTypeViewControllerDelegate {
    
    func didFinishShiftType(_ shiftType: ShiftType) {
        shiftTypeData.append(shiftType)
    }
    
}
