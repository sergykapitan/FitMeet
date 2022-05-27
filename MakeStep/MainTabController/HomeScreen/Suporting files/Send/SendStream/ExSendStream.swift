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
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        view.backgroundColor = .white
        let label = UILabel(frame: CGRect(x: 10, y: -10, width: tableView.frame.width, height: 20))
        label.text = "Create"
        label.backgroundColor = UIColor.clear
        label.font = UIFont.boldSystemFont(ofSize: 20)
        view.addSubview(label)
        return view
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        let cell = tableView.dequeueReusableCell(withIdentifier: SendStreamCell.reuseID, for: indexPath) as! SendStreamCell
        cell.imageCell.image = image[indexPath.row]
        cell.labelCategory.text = list[indexPath.row]
        cell.selectionStyle = .none
        
         return cell
    }
}
extension SendStream: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       let cell  = tableView.cellForRow(at: indexPath) as! SendStreamCell
        print(cell.imageCell.frame.size.width)
        UIView.animate(withDuration: 0.5) {
            cell.imageCell.backgroundColor = .lightGray.alpha(0.2)
        } completion: { tr in
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


