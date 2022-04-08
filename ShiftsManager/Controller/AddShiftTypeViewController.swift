//
//  AddShiftTypeViewController.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/6.
//

import UIKit

class AddShiftTypeViewController: UIViewController {

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var timePickerView: TimePickerView!
    
    private var addShiftTypeCellItems = [AddShiftTypeCellItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configAddShiftTypeCellItems()
        configBackgroundView()
        registCell()
    }
    
    private func configBackgroundView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(backgroundViewTapGesture))
        backgroundView.addGestureRecognizer(tapGesture)
    }
    
    @objc func backgroundViewTapGesture(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true)
    }
    
    // MARK: - Ok Button
    
    @IBAction func addOkBtnPressed(_ sender: Any) {
        let isNotSetAll = addShiftTypeCellItems.contains { $0.isSet == false }
        guard !isNotSetAll else {
            presentHint(title: "有欄位尚未添加")
            return
        }
        let startTimeArray = addShiftTypeCellItems[1].value.split(separator: ":").map { String($0) }
        let endTimeArray = addShiftTypeCellItems[2].value.split(separator: ":").map { String($0) }
        guard let startHour = Int16(startTimeArray[0]), let startMinute = Int16(startTimeArray[1]),
              let endHour = Int16(endTimeArray[0]), let endMinute = Int16(endTimeArray[1]),
              let restMinute = Int16(addShiftTypeCellItems[3].value),
              let hourlyRate = Float(addShiftTypeCellItems[4].value) else {
            print("AddOkBtnPressed Error")
            return
        }
        let name = addShiftTypeCellItems[0].value
        let remark = addShiftTypeCellItems[5].value
        
        let shiftType = ShiftType(context: CoreDataManager.shared.context)
        shiftType.id = UUID().uuidString
        shiftType.name = name
        shiftType.startHour = startHour
        shiftType.startMinute = startMinute
        shiftType.endHour = endHour
        shiftType.endMinute = endMinute
        shiftType.restMinute = restMinute
        shiftType.hourlyRate = hourlyRate
        shiftType.remark = remark
        CoreDataManager.shared.saveContext()
        dismiss(animated: true)
    }
    
    private func presentHint(title: String?) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let ok = UIAlertAction(title: "確定", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    // MARK: - Regist Cell
    
    private let cellId = "ShiftTypeCell"
    
    private func registCell() {
        let cellNib = UINib(nibName: NibName.addShiftTypeTableViewCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellId)
    }

}

extension AddShiftTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return addShiftTypeCellItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        guard let cell = cell as? AddShiftTypeTableViewCell else {
            return cell
        }
        cell.delegate = self
        cell.shiftTypeButton.tag = indexPath.row
        cell.shiftTypeButton.setTitle(addShiftTypeCellItems[indexPath.row].value, for: .normal)
        cell.titleLabel.text = addShiftTypeCellItems[indexPath.row].title
        return cell
    }
    
}

extension AddShiftTypeViewController: UITableViewDelegate {
    
}

extension AddShiftTypeViewController: AddShiftTypeTableViewCellDelegate {
    
    func didShiftTypeBtnPressed(_ sender: UIButton) {
        addShiftTypeCellItems[sender.tag].handler()
    }
    
}

extension AddShiftTypeViewController {
    
    private func configAddShiftTypeCellItems() {
        var addShiftTypeCellItem = AddShiftTypeCellItem(title: "班別名稱", value: "請輸入班別名稱", imageName: "") {
            self.presentAlertTextField(title: "班別名稱", placeholder: "請輸入班別名稱") { [weak self] text in
                guard let text = text else {
                    return
                }
                self?.addShiftTypeCellItems[0].value = text
                self?.addShiftTypeCellItems[0].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
        addShiftTypeCellItem = AddShiftTypeCellItem(title: "開始時間", value: "請輸入開始時間", imageName: "") {
            self.presentTimePicker { [weak self] date in
                self?.addShiftTypeCellItems[1].value = date.toTimeString()
                self?.addShiftTypeCellItems[1].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
        addShiftTypeCellItem = AddShiftTypeCellItem(title: "結束時間", value: "請輸入結束時間", imageName: "") {
            self.presentTimePicker { [weak self] date in
                self?.addShiftTypeCellItems[2].value = date.toTimeString()
                self?.addShiftTypeCellItems[2].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
        addShiftTypeCellItem = AddShiftTypeCellItem(title: "休息時間", value: "請輸入休息時間", imageName: "") {
            self.presentAlertTextField(title: "休息時間", message: "分鐘為單位",
                                       placeholder: "請輸入休息時間", keyboardType: .numberPad) {
                [weak self] text in
                guard let text = text else {
                    return
                }
                self?.addShiftTypeCellItems[3].value = text
                self?.addShiftTypeCellItems[3].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
        addShiftTypeCellItem = AddShiftTypeCellItem(title: "時薪", value: "請輸入時薪", imageName: "") {
            self.presentAlertTextField(title: "時薪", placeholder: "請輸入時薪", keyboardType: .decimalPad) {
                [weak self] text in
                guard let text = text else {
                    return
                }
                self?.addShiftTypeCellItems[4].value = text
                self?.addShiftTypeCellItems[4].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
        addShiftTypeCellItem = AddShiftTypeCellItem(title: "備註", value: " ", isSet: true, imageName: "") {
            self.presentAlertTextField(title: "備註", placeholder: "請輸入備註") { [weak self] text in
                guard let text = text else {
                    return
                }
                self?.addShiftTypeCellItems[5].value = text
                self?.addShiftTypeCellItems[5].isSet = true
                self?.tableView.reloadData()
            }
        }
        addShiftTypeCellItems.append(addShiftTypeCellItem)
    }
    
    private func presentAlertTextField(title: String?, message: String? = nil, placeholder: String?,
                                       keyboardType: UIKeyboardType = .default,
                                       completion: @escaping (String?) -> ()) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = placeholder
            textField.keyboardType = keyboardType
        }
        let cancel = UIAlertAction(title: "取消", style: .cancel)
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "確定", style: .default) { _ in
            let text = alert.textFields?.first?.text
            completion(text)
        }
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    private func presentTimePicker(completion: ((Date) -> ())?) {
        let frame = CGRect(x: tableView.frame.minX, y: tableView.frame.minY - 44.0, width: tableView.frame.width, height: tableView.frame.height + 88.0)
        timePickerView.frame = frame
        view.addSubview(timePickerView)
        timePickerView.completion = completion
    }
    
}

struct AddShiftTypeCellItem {
    
    var title: String
    var value: String
    var isSet = false
    var imageName: String
    var handler: () -> ()
    
}
