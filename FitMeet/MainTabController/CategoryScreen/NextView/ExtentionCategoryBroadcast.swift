//
//  ExtentionCategoryBroadcast.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit


extension CategoryBroadcast: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortListCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryBroadcastCell", for: indexPath) as! CategoryBroadcastCell
       // let text = viewModel.shared()[indexPath.row].searchText
        cell.setImage(image: sortListCategory[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = sortListCategory[indexPath.row].categories?.first?.description
        cell.titleLabel.text = sortListCategory[indexPath.row].name
        guard let category = sortListCategory[indexPath.row].categories?.first?.title else { return cell}
        cell.labelCategory.text = category
        
        return cell
    }
}
extension CategoryBroadcast: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        guard let Url = url else { return }
        let videoURL = URL(string: Url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }

    }

}
