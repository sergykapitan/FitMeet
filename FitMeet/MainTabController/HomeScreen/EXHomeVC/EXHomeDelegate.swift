//
//  EXHomeDelegate.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit
import AVKit

extension HomeVC: UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      let video = videos[indexPath.row]
      return HomeTableviewCell.height(for: video)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //2 Create an AVPlayerViewController and present it when the user taps
        let video = videos[indexPath.row]

        let videoURL = video.url
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
      
        present(playerViewController, animated: true) {
          player.play()
        }
      }
    }

