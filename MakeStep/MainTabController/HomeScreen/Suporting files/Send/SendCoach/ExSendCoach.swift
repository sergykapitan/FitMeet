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
            guard let id = broadcast?.id else { return }
            #if QA
                "https://makestepQA.com/broadcastQA/\(id)".share()
            #elseif DEBUG
                "https://makestep.com/broadcast/\(id)".share()
            #endif
        }
        if indexPath.row == 3 {
            let vc = EditStreamVC()
            vc.broadcast = self.broadcast
            self.present(vc, animated: true, completion: nil)
        }
        if indexPath.row == 4 {
            guard let id = self.broadcast?.id else { return }
            deleteBroadcast = fitMeetStream.deleteBroadcast(id: id)
                .mapError({ (error) -> Error in return error })
                .sink(receiveCompletion: { _ in }, receiveValue: { [self] response in
                    if response.id != nil  {
                        print("Delete \(response.id)")
                   }
            })
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


