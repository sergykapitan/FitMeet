//
//  ExSendCoach.swift
//  MakeStep
//
//  Created by novotorica on 15.09.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit


extension SendCoach: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendCoachCell", for: indexPath) as! SendCoachCell
        cell.labelCategory.text = list[indexPath.row]
        cell.selectionStyle = .none
         return cell
    }
    
}
extension SendCoach: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            "Data to share".share()
        }
        if indexPath.row == 3 {
            let vc = EditStreamVC()
            vc.broadcast = self.broadcast
            self.present(vc, animated: true, completion: nil)
        }
    
    }
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .lightGray
    }

    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        let cell  = tableView.cellForRow(at: indexPath)
        cell!.contentView.backgroundColor = .clear
    }
}


