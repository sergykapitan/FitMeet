//
//  ExtentionSearchVideoVC.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//

import UIKit

extension SearchVideoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCCell") as! SearchVCCell
        let defoultImage = "https://dev.makestep.com/qa-files/files_1e2d9edb-4819-4800-8076-30a80d6b51d0.jpeg"
        cell.labelDescription.text = listBroadcast[indexPath.row].name
        cell.titleLabel.text = listBroadcast[indexPath.row].categories?.first?.title
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? defoultImage )
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        return cell
    }
    @objc func actionMore() {
        let detailViewController = SendVC()
        actionSheetTransitionManager.height = 0.3
        detailViewController.modalPresentationStyle = .custom
        detailViewController.transitioningDelegate = actionSheetTransitionManager
        present(detailViewController, animated: true)

    }
    
}
extension SearchVideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       var sizeCell:CGFloat = 96
       return sizeCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = PlayerViewVC()
        if self.listBroadcast[indexPath.row].status == "ONLINE" {
            vc.broadcast = self.listBroadcast[indexPath.row]
            vc.id =  self.listBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.playerSlider.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else if  self.listBroadcast[indexPath.row].status == "OFFLINE" {
            guard let streams = listBroadcast[indexPath.row].streams else { return }
            if streams.isEmpty  { return }
            guard let url = streams.first?.vodUrl else { return }
            vc.broadcast = self.listBroadcast[indexPath.row]
            vc.id = self.listBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        } else if  self.listBroadcast[indexPath.row].status == "PLANNED" {
            print("PLANNED")
            return
        } else if  self.listBroadcast[indexPath.row].status == "WAIT_FOR_APPROVE" {
            print("WAIT_FOR_APPROVE")
            return
        } else if  self.listBroadcast[indexPath.row].status == "FINISHED" {
            print("FINISHED")
            guard let streams = listBroadcast[indexPath.row].streams else { return }
            if streams.isEmpty  { return }
            guard let url = streams.first?.vodUrl else { return }
            vc.broadcast = self.listBroadcast[indexPath.row]
            vc.id = self.listBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.listBroadcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
    }
}
