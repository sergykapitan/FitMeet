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
        if listBroadcast[indexPath.row].previewPath == "https://dev.fitliga.com/path/to/file.jpg" {
            cell.setImage(image: "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        } else {
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        }
        cell.labelDescription.text = listBroadcast[indexPath.row].categories?.first?.description
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard let category = listBroadcast[indexPath.row].categories?.first?.title, let category2 = listBroadcast[indexPath.row].categories?.last?.title else { return cell}
        cell.labelCategory.text = category + " \u{2665} " +  category2
        
        
        // assign the youtuber model to the cell
          // cell.youtuber = youtubers[indexPath.row]
           
           // the 'self' here means the view controller, set view controller as the delegate
           cell.delegate = self
        
       // cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
      //  cell.buttonLike.tag = indexPath.row
      //  cell.buttonLike.isUserInteractionEnabled = true
        
     //   if listBroadcast[indexPath.row].
        
        
        return cell
    }
}
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
       // return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        print("RESPONCE ====== \(listBroadcast[indexPath.row].streams?.first)")
        print("URRRRKKHHJGVHJGJGHLUG =======\(url)")
        
        
        let id = self.listBroadcast[indexPath.row].userId
        
//
       guard let Url = url else { return }
        let vc = PresentVC()
       
        vc.modalPresentationStyle = .fullScreen
        vc.id = id
        vc.Url = Url
        
        navigationController?.pushViewController(vc, animated: true)
       // self.present(vc, animated: true, completion: nil)

//        self.playerContainerView = Bundle.main.loadNibNamed("videoPlayerContainerNib", owner: self, options: nil)?.first as? PlayerContainerView
//        self.playerContainerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        self.view.addSubview(self.playerContainerView!)
//        self.playerContainerView?.initializeView()
//        self.playerContainerView?.link = Url
//        self.playerContainerView?.minimizedOrigin = {
//            let x = UIScreen.main.bounds.width/2
//            let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32)
//            let coordinate = CGPoint.init(x: x, y: y)
//            return coordinate
//        }()
//        self.playerContainerView?.initializeView()
    }
        
        
//        let videoURL = URL(string: Url)
//        let player = AVPlayer(url: videoURL!)
//        let playerViewController = AVPlayerViewController()
//        playerViewController.player = player
//        self.present(playerViewController, animated: true) {
//            playerViewController.player!.play()
//        }

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
//}
extension HomeVC : YoutuberTableViewCellDelegate {
    
    func youtuberTableViewCell(_ youtuberTableViewCell: HomeCell, subscribeButtonTappedFor youtuber: String) { do {
    // directly use the youtuber saved in the cell
    // show alert
    let alert = UIAlertController(title: "Subscribed!", message: "Subscribed to \(youtuber)", preferredStyle: .alert)
    let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(okAction)
    
    self.present(alert, animated: true, completion: nil)
  }
  }

}
