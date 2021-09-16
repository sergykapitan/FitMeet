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
         return cell
    }
    
}
extension SendCoach: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Send  = \(indexPath.row)")
        if indexPath.row == 0 {
           // guard let urlString = url else { return }
           // urlString.share()
            "Data to share".share()
        }
    
    }
}


