//
//  ExChannelCoach.swift
//  MakeStep
//
//  Created by Sergey on 24.02.2022.
//

import Foundation
import UIKit
import AVKit
import AVFoundation
import EasyPeasy

extension ChannelCoach: UITableViewDataSource, UITableViewDelegate {
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  brodcast.count
    }    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

            let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell

       
        
        if brodcast[indexPath.row].previewPath == "/path/to/file.jpg" {
            cell.setImage(image:"https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        } else {
            cell.setImage(image: brodcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        }


        cell.labelDescription.text = brodcast[indexPath.row].name
        
        
       
        
 
        guard let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
        switch brodcast[indexPath.row].status {
            
        case .online:
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.labelLive.text = "Live"
            cell.imageEye.isHidden = false
            cell.labelEye.isHidden = false
            cell.logoUserOnline.isHidden = false
            cell.buttonstartStream.isHidden = true
        case .offline:
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.imageLive.setImageColor(color: .gray)
            cell.labelLive.text = "Offline"
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            cell.buttonstartStream.isHidden = true
        case .planned:
            cell.imageLive.image = #imageLiteral(resourceName: "clock")
            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            cell.buttonstartStream.isHidden = false
        case .banned:
            break
        case .finished:
            break
        case .wait_for_approve:
            break
        }

//        if brodcast[indexPath.row].status == "OFFLINE" {
//            cell.imageLive.image = #imageLiteral(resourceName: "rec")
//            cell.imageLive.setImageColor(color: .gray)
//            cell.labelLive.text = "Offline"
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//            cell.logoUserOnline.isHidden = true
//            cell.buttonstartStream.isHidden = true
//
//        } else if brodcast[indexPath.row].status == "ONLINE" {
//            cell.imageLive.image = #imageLiteral(resourceName: "rec")
//            cell.labelLive.text = "Live"
//            cell.imageEye.isHidden = false
//            cell.labelEye.isHidden = false
//            cell.logoUserOnline.isHidden = false
//            cell.buttonstartStream.isHidden = true
//
//        } else if brodcast[indexPath.row].status == "PLANNED" {
//            cell.imageLive.image = #imageLiteral(resourceName: "clock")
//            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//            cell.logoUserOnline.isHidden = true
//            cell.buttonstartStream.isHidden = false
//
//        }
        
        let categorys = brodcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row

        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        self.url = self.brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
        guard let id = brodcast[indexPath.row].userId else { return cell}
        cell.titleLabel.text = self.usersd[id]?.fullName
  
        if indexPath.row == brodcast.count - 1 {
            if self.itemCount > brodcast.count {
                self.isLoadingList = true
                self.loadMoreItemsForList()
            }
        }
       return cell
    }
 
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil,let broadcastId = self.brodcast[sender.tag].id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)
    }
    @objc func actionStartStream(_ sender: UIButton) {
        guard let broadcastID = brodcast[sender.tag].id else { return }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        if self.brodcast[indexPath.row] == nil { return }
        switch self.brodcast[indexPath.row].status {
            
        case .online:
            guard let streams = brodcast[indexPath.row].streams else { return }
            if streams.isEmpty  { return }
            vc.broadcast = self.brodcast[indexPath.row]
            vc.id =  self.brodcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.labelLike.text = "\(String(describing: self.brodcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .offline:
            guard let streams = brodcast[indexPath.row].streams else { return }
            if streams.isEmpty  { return }
            guard let url = streams.first?.vodUrl else { return }
            vc.broadcast = self.brodcast[indexPath.row]
            vc.id = self.brodcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.brodcast[indexPath.row].followersCount!))"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .planned:
            break
        case .banned:
            break
        case .finished:
            break
        case .wait_for_approve:
            break
        }
        
//        if self.brodcast[indexPath.row].status == "ONLINE" {
//            guard let streams = brodcast[indexPath.row].streams else { return }
//            if streams.isEmpty  { return }
//            vc.broadcast = self.brodcast[indexPath.row]
//            vc.id =  self.brodcast[indexPath.row].userId
//            vc.homeView.buttonChat.isHidden = false
//            vc.homeView.labelLike.text = "\(String(describing: self.brodcast[indexPath.row].followersCount!))"
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else if  self.brodcast[indexPath.row].status == "OFFLINE" {
//            guard let streams = brodcast[indexPath.row].streams else { return }
//            if streams.isEmpty  { return }
//            guard let url = streams.first?.vodUrl else { return }
//            vc.broadcast = self.brodcast[indexPath.row]
//            vc.id = self.brodcast[indexPath.row].userId
//            vc.homeView.buttonChat.isHidden = true
//            vc.homeView.overlay.isHidden = true
//            vc.homeView.imageLive.isHidden = true
//            vc.homeView.labelLive.isHidden = true
//            vc.homeView.imageEye.isHidden = true
//            vc.homeView.labelEye.isHidden = true
//            vc.homeView.labelLike.text = "\(String(describing: self.brodcast[indexPath.row].followersCount!))"
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else if  self.brodcast[indexPath.row].status == "PLANNED" {
//            print("PLANNED")
//            return
////            vc.broadcast = self.brodcast[indexPath.row]
////            vc.id =  self.brodcast[indexPath.row].userId
////            vc.homeView.buttonChat.isHidden = true
////            vc.homeView.imageEye.isHidden = true
////            vc.homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
////            vc.homeView.labelLive.text = self.brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
////            vc.homeView.labelLike.text = "\(String(describing: self.brodcast[indexPath.row].followersCount!))"
//        } else if  self.brodcast[indexPath.row].status == "WAIT_FOR_APPROVE" {
//            print("WAIT_FOR_APPROVE")
//            return
//        } else if  self.brodcast[indexPath.row].status == "FINISHED" {
//            print("FINISHED")
//            return
//        }
//        vc.modalPresentationStyle = .fullScreen
//        self.present(vc, animated: true, completion: nil)
    }

}

extension ChannelCoach {
    
     func layout() {
         homeView.viewTop.translatesAutoresizingMaskIntoConstraints = false
         homeView.imageLogoProfile.translatesAutoresizingMaskIntoConstraints = false
         homeView.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
         homeView.labelFollow.translatesAutoresizingMaskIntoConstraints = false
         homeView.buttonSubscribe.translatesAutoresizingMaskIntoConstraints = false
         homeView.buttonHelpCoach.translatesAutoresizingMaskIntoConstraints = false
         
         view.addSubview(homeView.viewTop)
         view.addSubview(homeView.imageLogoProfile)
         view.addSubview(homeView.welcomeLabel)
         view.addSubview(homeView.labelFollow)
         view.addSubview(homeView.buttonHelpCoach)
         
         view.addSubview(homeView.buttonSubscribe)
         view.addSubview(homeView.buttonFollow)
         view.addSubview(homeView.buttonInstagram)
         view.addSubview(homeView.buttonTwiter)
         view.addSubview(homeView.buttonfaceBook)
         view.addSubview(homeView.labelINTVideo)
         view.addSubview(homeView.labelVideo)
         view.addSubview(homeView.labelINTFollows)
         view.addSubview(homeView.labelFollows)
         view.addSubview(homeView.labelINTFolowers)
         view.addSubview(homeView.labelFolowers)
         view.addSubview(homeView.labelDescription)

         
         

         homeView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
         homeView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
         bottomConstraint = homeView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: popupOffset)
         bottomConstraint.isActive = true
         heightViewTop = homeView.viewTop.heightAnchor.constraint(equalToConstant: 450)
         heightViewTop.isActive = true

         homeView.labelFollow.bottomAnchor.constraint(equalTo: homeView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
         homeView.labelFollow.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 15).isActive = true
         

        // topWelcomLabelConstant = homeView.welcomeLabel.topAnchor.constraint(equalTo: homeView.imageLogoProfile.topAnchor, constant: 0)
         topWelcomLabelConstant = homeView.welcomeLabel.centerYAnchor.constraint(equalTo: homeView.imageLogoProfile.centerYAnchor, constant: 0)
         topWelcomLabelConstant.isActive = true
         
         rightWelcomLabel = homeView.welcomeLabel.trailingAnchor.constraint(equalTo: homeView.buttonSubscribe.leadingAnchor, constant: -5)
         rightWelcomLabel.isActive = true
         
         leftWelcomeLabelConstant = homeView.welcomeLabel.leadingAnchor.constraint(equalTo: homeView.imageLogoProfile.trailingAnchor, constant: 15)
         leftWelcomeLabelConstant.isActive = true
         
         centerWelcomeLabelConstant = homeView.welcomeLabel.centerXAnchor.constraint(equalTo: homeView.cardView.centerXAnchor)
         centerWelcomeLabelConstant.isActive = false
         

         leftConstant = homeView.imageLogoProfile.leadingAnchor.constraint(equalTo: homeView.viewTop.leadingAnchor, constant: 20)
         leftConstant.isActive = true
         
         
         botConstant = homeView.imageLogoProfile.bottomAnchor.constraint(equalTo: homeView.viewTop.bottomAnchor, constant: -20)
         botConstant.isActive = true
         
         topConstraint = homeView.imageLogoProfile.topAnchor.constraint(equalTo: homeView.viewTop.topAnchor, constant: 120)
         topConstraint.isActive = false
         
         centerConstant = homeView.imageLogoProfile.centerXAnchor.constraint(equalTo: homeView.viewTop.centerXAnchor)
         centerConstant.isActive = false
         
         heightConstant = homeView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
         heightConstant.isActive = true
         widthConstant = homeView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
         widthConstant.isActive = true

         
         topbuttonSubscribeConstant = homeView.buttonSubscribe.topAnchor.constraint(equalTo: homeView.welcomeLabel.bottomAnchor, constant: 20)
         topbuttonSubscribeConstant.isActive = false
         leftbuttonSubscribeConstant = homeView.buttonSubscribe.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -18)
         leftbuttonSubscribeConstant.isActive = false
         
         rightbuttonSubscribeConstant = homeView.buttonSubscribe.trailingAnchor.constraint(equalTo: homeView.trailingAnchor, constant: -10)
         rightbuttonSubscribeConstant.isActive = true
         centerbuttonSubscribeConstant = homeView.buttonSubscribe.centerYAnchor.constraint(equalTo: homeView.imageLogoProfile.centerYAnchor)
         centerbuttonSubscribeConstant.isActive = true
         
         
         homeView.buttonSubscribe.anchor( width: 90, height: 28)
         homeView.buttonFollow.anchor( width: 90, height: 28)
         
         
         homeView.buttonFollow.anchor(top: homeView.welcomeLabel.bottomAnchor, paddingTop: 20, width: 102, height: 28)
         homeView.buttonFollow.centerX(inView: homeView.viewTop)
  
        
         homeView.buttonInstagram.anchor( left: homeView.cardView.leftAnchor,paddingLeft: 17, width: 28, height: 28)
         homeView.buttonInstagram.centerY(inView: homeView.buttonFollow)

         homeView.buttonTwiter.anchor(left: homeView.buttonInstagram.rightAnchor,paddingLeft: 5, width: 28, height: 28)
         homeView.buttonTwiter.centerY(inView: homeView.buttonInstagram)

         homeView.buttonfaceBook.anchor(left: homeView.buttonTwiter.rightAnchor, paddingLeft: 5, width: 28, height: 28)
         homeView.buttonfaceBook.centerY(inView: homeView.buttonInstagram)
         
         
  
        
         self.homeView.buttonFollow.alpha = 0
         self.homeView.buttonInstagram.alpha = 0
         self.homeView.buttonTwiter.alpha = 0
         self.homeView.buttonfaceBook.alpha = 0
         self.homeView.labelINTVideo.alpha = 0
         self.homeView.labelVideo.alpha = 0
         self.homeView.labelINTFollows.alpha = 0
         self.homeView.labelFollows.alpha = 0
         self.homeView.labelINTFolowers.alpha = 0
         self.homeView.labelFolowers.alpha = 0
         self.homeView.labelDescription.alpha = 0
        
         
         homeView.labelINTVideo.anchor(top: homeView.buttonSubscribe.bottomAnchor, left: homeView.viewTop.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
          
          homeView.labelVideo.anchor(top: homeView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
         homeView.labelVideo.centerX(inView: homeView.labelINTVideo)
         
         
         homeView.labelINTFollows.anchor(top: homeView.buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
         homeView.labelINTFollows.centerX(inView: homeView.buttonFollow)
         
         
         homeView.labelFollows.anchor(top: homeView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
         homeView.labelFollows.centerX(inView: homeView.viewTop)
         
   
         homeView.labelINTFolowers.anchor(top: homeView.buttonSubscribe.bottomAnchor, right: homeView.viewTop.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
         
         homeView.labelFolowers.anchor(top: homeView.labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
         homeView.labelFolowers.centerX(inView: homeView.labelINTFolowers)
         
         
         homeView.labelDescription.anchor(top: homeView.labelFollows.bottomAnchor, left: homeView.viewTop.leftAnchor, right: homeView.viewTop.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
         
         homeView.buttonHelpCoach.anchor(bottom:homeView.viewTop.bottomAnchor,paddingBottom: -5,width: 40, height: 30)
         homeView.buttonHelpCoach.centerX(inView: homeView.viewTop)
         homeView.buttonHelpCoach.isUserInteractionEnabled = false
     }
}
