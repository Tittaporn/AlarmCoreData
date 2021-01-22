//
//  AlarmListTableViewController.swift
//  AlarmCoreData
//
//  Created by Lee McCormick on 1/21/21.
//

import UIKit

class AlarmListTableViewController: UITableViewController {
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        AlarmController.shared.fetchAlarms()
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AlarmController.shared.alarms.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "alarmCell", for: indexPath) as? AlarmTableViewCell else { return UITableViewCell() }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        cell.delegate = self
        cell.updateViews(alarm: alarm)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let alarmToDelete = AlarmController.shared.alarms[indexPath.row]
            AlarmController.shared.delete(alarm: alarmToDelete)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toAlarmDetailVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destinationVC = segue.destination as? AlarmDetailTableViewController else { return }
            let alarm = AlarmController.shared.alarms[indexPath.row]
            destinationVC.alarm = alarm
        }
    }
}

extension AlarmListTableViewController: AlarmTableViewCellDelegate {
    func alarmWasToggled(sender: AlarmTableViewCell) {
        guard let indexPath = tableView.indexPath(for: sender) else { return }
        let alarm = AlarmController.shared.alarms[indexPath.row]
        AlarmController.shared.toggleIsEnabledFor(alarm: alarm)
        sender.updateViews(alarm: alarm)
    }
}
