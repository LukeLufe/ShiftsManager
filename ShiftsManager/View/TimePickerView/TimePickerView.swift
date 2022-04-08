//
//  TimePickerView.swift
//  ShiftsManager
//
//  Created by Luke on 2022/4/8.
//

import UIKit

class TimePickerView: UIView {

    @IBOutlet weak var timePicker: UIDatePicker!
    var pickerMinuteIntervalType: PickerMinuteIntervalType = .one
    var completion: ((Date) -> ())?

    @IBAction func minuteIntervalBtnPressed(_ sender: UIButton) {
        switch pickerMinuteIntervalType {
        case .one:
            pickerMinuteIntervalType = .five
        case .five:
            pickerMinuteIntervalType = .one
        }
        timePicker.minuteInterval = pickerMinuteIntervalType.rawValue
        sender.setTitle("\(pickerMinuteIntervalType.rawValue)", for: .normal)
    }
    
    @IBAction func oClockBtnPressed(_ sender: Any) {
        timePicker.date = timePicker.date.toOClock()
    }
    
    @IBAction func halfClockBtnPressed(_ sender: Any) {
        timePicker.date = timePicker.date.toHalfClock()
    }
    
    @IBAction func okBtnPressed(_ sender: Any) {
        completion?(timePicker.date)
        removeFromSuperview()
    }
    
    enum PickerMinuteIntervalType: Int {
        case one = 1
        case five = 5
    }
    
}
