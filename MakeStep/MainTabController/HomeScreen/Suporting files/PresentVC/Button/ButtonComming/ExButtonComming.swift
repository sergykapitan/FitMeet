//
//  ExButtonComming.swift
//  MakeStep
//
//  Created by Sergey on 23.11.2021.
//

import Foundation
import UIKit
import EasyPeasy

extension ButtonCommingg: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  brodcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell

       
        
        if brodcast[indexPath.row].previewPath == "/path/to/file.jpg" {
            cell.setImage(image:"https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        } else {
            cell.setImage(image: brodcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        }


      

        cell.labelDescription.text = brodcast[indexPath.row].description
        cell.titleLabel.text = self.user?.fullName
        
 
        guard let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
      
       if brodcast[indexPath.row].status == "PLANNED" {
          
          
            cell.label.text = self.brodcast[indexPath.row].name
            cell.backgroundImage.removeBlur()
            cell.backgroundImage.backgroundColor = .clear
            cell.imageLive.image = #imageLiteral(resourceName: "clock")
            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.backgroundImage.applyBlurEffect()
           
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.overlay.anchor(width: 80)

        }
        
        let categorys = brodcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row

        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        cell.setImageLogo(image: self.usersd[id]?.avatarPath ?? "https://logodix.com/logo/1070633.png")



        if brodcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }



        self.url = self.brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        if self.usersd[id]?.id == Int(selfId!) {
            cell.buttonLike.isHidden = true
            cell.buttonstartStream.isHidden = false
        } else {
            cell.buttonLike.isHidden = false
            cell.buttonstartStream.isHidden = true
        }

        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
        cell.buttonstartStream.tag = indexPath.row
        cell.buttonstartStream.addTarget(self, action: #selector(actionStartStream(_:)), for: .touchUpInside)
        cell.buttonstartStream.isUserInteractionEnabled = true
      
      
        
       return cell
    }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
            self.followBroadcast(id: id)
        } else {
            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
            self.unFollowBroadcast(id: id)
        }
    }
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
                guard let coachID = user?.id,let userID = selfId else { return }
        
                if coachID == Int(userID)! {
                    let detailViewController = SendCoach()
                    actionSheetTransitionManager.height = 0.3
                    detailViewController.modalPresentationStyle = .custom
                    detailViewController.transitioningDelegate = actionSheetTransitionManager
                    detailViewController.url = self.url
                    detailViewController.broadcast = brodcast[sender.tag]
                    present(detailViewController, animated: true)
                } else {
        
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.2
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        detailViewController.url = self.url
        present(detailViewController, animated: true)
        }

    }
    @objc func actionStartStream(_ sender: UIButton) {
        guard let broadcastID = brodcast[sender.tag].id else { return }
            self.nextView(broadcastId: broadcastID)
    }
  
}