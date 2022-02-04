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
         return cell
    }
}
extension SendStream: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.dismiss(animated: true) {
               
            }
        }
        if indexPath.row == 1 {
            self.dismiss(animated: true) {
                if let tabBC = UIApplication.shared.windows[0].rootViewController as? UITabBarController {
                    tabBC.selectedIndex = 2
                }
            }
        }
    }
}


