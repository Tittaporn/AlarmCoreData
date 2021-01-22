//
//  AlarmTableViewCell.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import UIKit

// MARK: - Protocol
protocol AlarmTableViewCellDelegate : AnyObject {
    func alarmWasToggled(sender: AlarmTableViewCell)
}

class AlarmTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var alarmTitleLabel: UILabel!
    @IBOutlet weak var alarmFireDateLabel: UILabel!
    @IBOutlet weak var isEnabledSwitch: UISwitch!
    
    // MARK: - Properties
    weak var delegate: AlarmTableViewCellDelegate?
    
    // MARK: - Actions
    @IBAction func isEnableSwitchToggled(_ sender: Any) {
        delegate?.alarmWasToggled(sender: self)
    }
    
    // MARK: - Helper Fuctions
    func updateViews(alarm: Alarm) {
        alarmTitleLabel.text = alarm.title
        alarmFireDateLabel.text = alarm.fireDate!.stringValue()
        isEnabledSwitch.isOn = alarm.isEnabled
    }
}
