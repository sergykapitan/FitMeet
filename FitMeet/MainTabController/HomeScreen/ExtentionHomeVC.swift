//
//  ExtentionHomeVC.swift
//  FitMeet
//
//  Created by novotorica on 31.05.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit


extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
       // let text = viewModel.shared()[indexPath.row].searchText
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].categories?.first?.description
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard let category = listBroadcast[indexPath.row].categories?.first?.title, let category2 = listBroadcast[indexPath.row].categories?.last?.title else { return cell}
        cell.labelCategory.text = category + " \u{2665} " +  category2
        
        return cell
    }
}
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        print("RESPONCE ====== \(listBroadcast[indexPath.row].streams?.first)")
        print("URRRRKKHHJGVHJGJGHLUG =======\(url)")
        guard let Url = url else { return }
        let videoURL = URL(string: Url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }

//        let navVC = tabBarController?.viewControllers![0] as! UINavigationController
//        let searchCollViewController = navVC.topViewController as! SearchCollectionViewController
//        let searchText: String = viewModel.shared()[indexPath.row].searchText!
//        searchCollViewController.makeReguest(searchText: searchText)
//        tabBarController?.selectedIndex = 0

    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//
//        let his = viewModel.shared()[indexPath.row]
//        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
//
//            self.viewModel.delete(text: his)
//            tableView.reloadData()
//       }
//       let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
//
//       return swipeActions
//   }
}
