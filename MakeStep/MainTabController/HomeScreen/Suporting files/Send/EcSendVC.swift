//
//  EcSendVC.swift
//  MakeStep
//
//  Created by novotorica on 23.08.2021.
//


import Kingfisher
import AVFoundation
import AVKit
import UIKit


extension SendVC: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SendVCCell", for: indexPath) as! SendVCCell
        cell.labelCategory.text = list[indexPath.row]
        return cell
    }
}
extension SendVC: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            guard let id = broadcast?.id else { return }
            #if QA
                "https://makestep.com/broadcastQA/\(id)".share()
            #elseif DEBUG
                "https://makestep.com/broadcast/\(id)".share()
            #endif
          
        }
    }
}


