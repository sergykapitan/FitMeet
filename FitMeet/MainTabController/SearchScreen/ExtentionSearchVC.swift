//
//  ExtentionSearchVC.swift
//  FitMeet
//
//  Created by novotorica on 11.06.2021.
//

import Foundation
import UIKit
import AVFoundation
import AVKit


extension SearchVC: UITableViewDataSource {
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            var indexCount = self.filtredBroadcast.count
        }
        var indexCount = self.listBroadcast.count
        
        if index == 0 {
            if isFiltering {
                indexCount = filtredBroadcast.count
                return filtredBroadcast.count
                    }
               indexCount = listBroadcast.count
                return self.listBroadcast.count
        } else if index == 1 {
            if isFiltering {
                indexCount = filterListUser.count
                return filterListUser.count
                    }
               indexCount = listUsers.count
                return self.listUsers.count
        } else if index == 2 {
            indexCount = listCategory.count
        }
        if isFiltering {
            indexCount = filtredBroadcast.count
            return filtredBroadcast.count
                }
           indexCount = listBroadcast.count
            return self.listBroadcast.count
        
        
        
        
        print(indexCount)
        return indexCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCCell") as! SearchVCCell
        var cell2 = tableView.dequeueReusableCell(withIdentifier: "SearchVCUserCell") as! SearchVCUserCell
        var cell3 = tableView.dequeueReusableCell(withIdentifier: "SearchVCCategory") as! SearchVCCategory
        
        let defoultImage = "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg"
        let candy: [BroadcastResponce]
          if isFiltering {
            candy = filtredBroadcast
          } else {
            candy = listBroadcast
          }
        
//        let filterUs: [Users]
//        
//        if isFiltering {
//            filterUs = filterListUser
//        } else {
//            filterUs = listUsers
//        }

        if index == 0 {

            cell.labelDescription.text = candy[indexPath.row].name
            cell.titleLabel.text = candy[indexPath.row].categories?.first?.title
            cell.setImage(image: candy[indexPath.row].previewPath ?? defoultImage )
            return cell

        }

        if index == 1 {
            cell2.setImage(image: listUsers[indexPath.row].avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png" )
            cell2.labelDescription.text = listUsers[indexPath.row].fullName
            cell2.logoUserImage.layer.cornerRadius = cell2.logoUserImage.frame.height/2
            cell2.titleLabel.text = "\(listUsers[indexPath.row].channelSubscribeCount!)" + "  Views"


            return cell2

        }
        if index == 2 {
            cell3.labelDescription.text = listCategory[indexPath.row].title
            return cell3
        }

        cell.labelDescription.text = candy[indexPath.row].name
        cell.titleLabel.text = candy[indexPath.row].categories?.first?.title
                       
        cell.setImage(image: candy[indexPath.row].previewPath ?? defoultImage )
        
       
        
        
        return cell
    }
}
extension SearchVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var sizeCell:CGFloat = 96
        
        if index == 0 {
            sizeCell =  96
        }
        if index == 1 {
            sizeCell = 70
        }
        if index == 2 {
            sizeCell = 40
        }
        return sizeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let url: String?
        if isFiltering {
             url = self.filtredBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        } else {
             url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        }
        
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
