//
//  ExSendStream.swift
//  MakeStep
//
//  Created by Sergey on 04.02.2022.
//

import Kingfisher
import AVFoundation
import AVKit
import UIKit


extension SendStream: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: SendStreamCell.reuseID, for: indexPath) as! SendStreamCell
        cell.labelCategory.text = list[indexPath.row]
        cell.selectionStyle = .none
         return cell
    }
}
extension SendStream: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dismiss(animated: true) {
                if let tabBC = UIApplication.shared.windows[0].rootViewController as? MainTabBarViewController {
                    tabBC.boolStream = false
                    NotificationCenter.default.post(Notification(name: .refreshAllTabs))
                    tabBC.selectedIndex = 2
                }
            }
        }
        if indexPath.row == 1 {
            self.dismiss(animated: true) {
                if let tabBC = UIApplication.shared.windows[0].rootViewController as? MainTabBarViewController {
                    tabBC.boolStream = true
                    NotificationCenter.default.post(Notification(name: .refreshAllTabs))
                    tabBC.selectedIndex = 2
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
}


