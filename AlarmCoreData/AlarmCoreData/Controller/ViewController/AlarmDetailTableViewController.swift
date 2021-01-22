//
//  AlarmDetailTableViewController.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import UIKit

class AlarmDetailTableViewController: UITableViewController {

    // MARK: - Outlets
    @IBOutlet var alarmFireDatePicker: UIDatePicker!
    @IBOutlet var alarmTitleTextField: UITextField!
    @IBOutlet var  alarmIsEnabledButton: UIButton!
    
    // MARK: - Properties
    var alarm: Alarm?
    var isAlarmOn: Bool = true
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.reloadData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func alarmIsEnabledButtonTapped(_ sender: Any) {
        if let alarm = alarm {
            AlarmController.shared.toggleIsEnabledFor(alarm: alarm)
            isAlarmOn = alarm.isEnabled
        } else {
            isAlarmOn.toggle()
        }
        designIsEnabledButton()
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = alarmTitleTextField.text, !title.isEmpty else { return }
        if let alarm = alarm {
            AlarmController.shared.update(alarm: alarm, newTitle: title, newFireDate: alarmFireDatePicker.date, isEnabled: alarm.isEnabled)
        } else {
            AlarmController.shared.createAlarm(withTitle: title, fireDate: alarmFireDatePicker.date)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helper Fuctions
    func updateViews() {
        guard let alarm = alarm else { return }
        alarmTitleTextField.text = alarm.title
        alarmFireDatePicker.date =  alarm.fireDate ?? Date()
        self.isAlarmOn = alarm.isEnabled
        designIsEnabledButton()
    }
    
    func designIsEnabledButton() {
        switch isAlarmOn {
        case true:
            alarmIsEnabledButton.backgroundColor = .white
            alarmIsEnabledButton.setTitle("Enabled", for: .normal)
        case false:
            alarmIsEnabledButton.backgroundColor = .darkGray
            alarmIsEnabledButton.setTitle("Disabled", for: .normal)
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
}
