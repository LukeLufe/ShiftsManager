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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    // MARK: - Regist Cell
    
    private let cellId = "ShiftTypeCell"
    
    private func registCell() {
        let cellNib = UINib(nibName: NibName.addShiftTypeTableViewCell, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: cellId)
    }

}

extension AddShiftTypeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        guard let cell = cell as? AddShiftTypeTableViewCell else {
            return cell
        }
        cell.shiftTypeButton.setTitle("測試", for: .normal)
        return cell
    }
    
}

extension AddShiftTypeViewController: UITableViewDelegate {
    
}
