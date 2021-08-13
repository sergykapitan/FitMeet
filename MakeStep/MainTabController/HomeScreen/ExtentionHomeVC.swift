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
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].description
        
        
        
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard let category = listBroadcast[indexPath.row].categories?.first?.title,
              let category2 = listBroadcast[indexPath.row].categories?.last?.title,
              let id = listBroadcast[indexPath.row].userId else { return cell}
        cell.labelCategory.text = category + " \u{2665} " +  category2
        cell.labelEye.text = " \(listBroadcast[indexPath.row].followersCount!)"        
        bindingUser(id: id)
      
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            
            
            cell.setImageLogo(image: self.user?.avatarPath ?? "https://logodix.com/logo/1070633.png")
            
        }
        
        
        
        cell.delegate = self
        
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.isUserInteractionEnabled = true
        
     //   if listBroadcast[indexPath.row].
        
        
        return cell
    }
}
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 280
       // return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        let id = self.listBroadcast[indexPath.row].userId
        let follow = self.listBroadcast[indexPath.row].followersCount
       guard let Url = url else { return }
        let vc = PresentVC()
       
        vc.modalPresentationStyle = .fullScreen
        vc.id = id
        vc.Url = Url
        vc.follow = "\(follow)"
        
        navigationController?.pushViewController(vc, animated: true)

    }


    }

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
