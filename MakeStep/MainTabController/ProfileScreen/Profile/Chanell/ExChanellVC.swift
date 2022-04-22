//
//  ExChanellVC.swift
//  MakeStep
//
//  Created by novotorica on 22.09.2021.
//
//
import Foundation
import UIKit
import AVKit
import AVFoundation
import EasyPeasy

extension ChanellVC: UITableViewDataSource, UITableViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        if self.profileView.mmPlayerLayer.isShrink { return }
//        self.destrtoyMMPlayerInstance()
//    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  brodcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell
        let defoultImage = "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg"
        cell.setImage(image: brodcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? defoultImage )
        cell.labelDescription.text = brodcast[indexPath.row].name
        cell.titleLabel.text = self.user?.fullName
        guard let id = brodcast[indexPath.row].userId else { return cell}
        guard let status =  brodcast[indexPath.row].status else { return  cell}
        switch status {
            
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
            cell.imageLive.image = #imageLiteral(resourceName: "clock")
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            cell.buttonstartStream.isHidden = true
            cell.labelLive.text = "Wait for"
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
//        } else if brodcast[indexPath.row].status == "WAIT_FOR_APPROVE" {
//            cell.imageLive.image = #imageLiteral(resourceName: "clock")
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//            cell.logoUserOnline.isHidden = true
//            cell.buttonstartStream.isHidden = true
//            cell.labelLive.text = "Wait for"
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
   
        if indexPath.row == brodcast.count - 1 {
            if self.itemCount > brodcast.count {
                self.isLoadingList = true
                self.loadMoreItemsForList()
            }
        }
       return cell
    }
   
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard !brodcast.isEmpty else { return }
        guard let broadcastId = brodcast[sender.tag].id else { return }
        showDownSheet(moreArtworKMeUserSheetVC, payload: broadcastId)
    }
    @objc func actionStartStream(_ sender: UIButton) {
        guard let broadcastID = brodcast[sender.tag].id else { return }
          //  self.nextView(broadcastId: broadcastID)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        guard let status = self.brodcast[indexPath.row].status else { return }
        switch status {
            
        case .online:
            vc.broadcast = self.brodcast[indexPath.row]
            vc.id =  self.brodcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
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
            vc.broadcast = self.brodcast[indexPath.row]
            vc.id =  self.brodcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelLive.text = self.brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .banned:
            break
        case .finished:
            guard let streams = self.brodcast[indexPath.row].streams else { return }
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
        case .wait_for_approve:
            vc.broadcast = self.brodcast[indexPath.row]
            vc.id =  self.brodcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
            vc.homeView.labelLive.text = "Wait for"
            vc.homeView.imageEye.isHidden = true
        }
        
//        if self.brodcast[indexPath.row].status == "ONLINE" {
//            vc.broadcast = self.brodcast[indexPath.row]
//            vc.id =  self.brodcast[indexPath.row].userId
//            vc.homeView.buttonChat.isHidden = false
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
//            vc.broadcast = self.brodcast[indexPath.row]
//            vc.id =  self.brodcast[indexPath.row].userId
//            vc.homeView.buttonChat.isHidden = true
//            vc.homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
//            vc.homeView.imageEye.isHidden = true
//            vc.homeView.labelLive.text = self.brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
//            vc.modalPresentationStyle = .fullScreen
//            self.present(vc, animated: true, completion: nil)
//        } else if  self.brodcast[indexPath.row].status == "WAIT_FOR_APPROVE" {
//            vc.broadcast = self.brodcast[indexPath.row]
//            vc.id =  self.brodcast[indexPath.row].userId
//            vc.homeView.buttonChat.isHidden = true
//            vc.homeView.imageLive.image =  #imageLiteral(resourceName: "clock")
//            vc.homeView.labelLive.text = "Wait for"
//            vc.homeView.imageEye.isHidden = true
//        } else if  self.brodcast[indexPath.row].status == "FINISHED" {
//            guard let streams = self.brodcast[indexPath.row].streams else { return }
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
//        }
    }
}

extension ChanellVC {
    
     func layout() {
        profileView.viewTop.translatesAutoresizingMaskIntoConstraints = false
        profileView.imageLogoProfile.translatesAutoresizingMaskIntoConstraints = false
        profileView.welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        profileView.labelFollow.translatesAutoresizingMaskIntoConstraints = false
        profileView.buttonSubscribe.translatesAutoresizingMaskIntoConstraints = false
        profileView.buttonHelpCoach.translatesAutoresizingMaskIntoConstraints = false
     
     view.addSubview(profileView.viewTop)
     view.addSubview(profileView.imageLogoProfile)
     view.addSubview(profileView.welcomeLabel)
     view.addSubview(profileView.labelFollow)
        
        view.addSubview(profileView.buttonHelpCoach)
        
        view.addSubview(profileView.buttonSubscribe)
        view.addSubview(profileView.buttonInstagram)
        view.addSubview(profileView.buttonTwiter)
        view.addSubview(profileView.buttonfaceBook)
        view.addSubview(profileView.labelINTVideo)
        view.addSubview(profileView.labelVideo)
        view.addSubview(profileView.labelINTFollows)
        view.addSubview(profileView.labelFollows)
        view.addSubview(profileView.labelINTFolowers)
        view.addSubview(profileView.labelFolowers)
        view.addSubview(profileView.labelDescription)


        profileView.viewTop.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        profileView.viewTop.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomConstraint = profileView.viewTop.topAnchor.constraint(equalTo: view.topAnchor, constant: popupOffset)
        bottomConstraint.isActive = true
        heightViewTop = profileView.viewTop.heightAnchor.constraint(equalToConstant: 450)
        heightViewTop.isActive = true

        profileView.labelFollow.bottomAnchor.constraint(equalTo: profileView.imageLogoProfile.bottomAnchor, constant: 0).isActive = true
        profileView.labelFollow.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 15).isActive = true

        topWelcomLabelConstant = profileView.welcomeLabel.centerYAnchor.constraint(equalTo: profileView.imageLogoProfile.centerYAnchor, constant: 0)
        topWelcomLabelConstant.isActive = true
        
        rightWelcomLabel = profileView.welcomeLabel.trailingAnchor.constraint(equalTo: profileView.buttonSubscribe.leadingAnchor, constant: -5)
        rightWelcomLabel.isActive = true
        
        leftWelcomeLabelConstant = profileView.welcomeLabel.leadingAnchor.constraint(equalTo: profileView.imageLogoProfile.trailingAnchor, constant: 15)
        leftWelcomeLabelConstant.isActive = true
        
        centerWelcomeLabelConstant = profileView.welcomeLabel.centerXAnchor.constraint(equalTo: profileView.cardView.centerXAnchor)
        centerWelcomeLabelConstant.isActive = false
        

        leftConstant = profileView.imageLogoProfile.leadingAnchor.constraint(equalTo: profileView.viewTop.leadingAnchor, constant: 20)
        leftConstant.isActive = true
        
        
        botConstant = profileView.imageLogoProfile.bottomAnchor.constraint(equalTo: profileView.viewTop.bottomAnchor, constant: -20)
        botConstant.isActive = true
        
        topConstraint = profileView.imageLogoProfile.topAnchor.constraint(equalTo: profileView.viewTop.topAnchor, constant: 120)
        topConstraint.isActive = false
        
        centerConstant = profileView.imageLogoProfile.centerXAnchor.constraint(equalTo: profileView.viewTop.centerXAnchor)
        centerConstant.isActive = false
        
        heightConstant = profileView.imageLogoProfile.heightAnchor.constraint(equalToConstant: 70)
        heightConstant.isActive = true
        widthConstant = profileView.imageLogoProfile.widthAnchor.constraint(equalToConstant: 70)
        widthConstant.isActive = true

        
        topbuttonSubscribeConstant = profileView.buttonSubscribe.topAnchor.constraint(equalTo: profileView.welcomeLabel.bottomAnchor, constant: 20)
        topbuttonSubscribeConstant.isActive = false
        
        leftbuttonSubscribeConstant = profileView.buttonSubscribe.leadingAnchor.constraint(equalTo: profileView.viewTop.centerXAnchor, constant: 18) // leadingAnchor
        leftbuttonSubscribeConstant.isActive = false
        
        rightbuttonSubscribeConstant = profileView.buttonSubscribe.trailingAnchor.constraint(equalTo: profileView.trailingAnchor, constant: -10)
        rightbuttonSubscribeConstant.isActive = true
        centerbuttonSubscribeConstant = profileView.buttonSubscribe.centerYAnchor.constraint(equalTo: profileView.imageLogoProfile.centerYAnchor)
        centerbuttonSubscribeConstant.isActive = true
        
        profileView.buttonSubscribe.anchor( width: 100, height: 28)

        profileView.buttonInstagram.anchor(  right: profileView.viewTop.centerXAnchor,paddingRight: 17, width: 28, height: 28)
        profileView.buttonInstagram.centerY(inView: profileView.buttonSubscribe)
        
        profileView.buttonTwiter.anchor(right: profileView.buttonInstagram.leftAnchor,paddingRight: 5,  width: 28, height: 28)
        profileView.buttonTwiter.centerY(inView: profileView.buttonInstagram)
        
        profileView.buttonfaceBook.anchor( right: profileView.buttonTwiter.leftAnchor, paddingRight: 5, width: 28, height: 28)
        profileView.buttonfaceBook.centerY(inView: profileView.buttonInstagram)

        self.profileView.buttonInstagram.alpha = 0
        self.profileView.buttonTwiter.alpha = 0
        self.profileView.buttonfaceBook.alpha = 0
        self.profileView.labelINTVideo.alpha = 0
        self.profileView.labelVideo.alpha = 0
        self.profileView.labelINTFollows.alpha = 0
        self.profileView.labelFollows.alpha = 0
        self.profileView.labelINTFolowers.alpha = 0
        self.profileView.labelFolowers.alpha = 0
        self.profileView.labelDescription.alpha = 0
        
        profileView.labelINTVideo.anchor(top: profileView.buttonSubscribe.bottomAnchor, left: profileView.viewTop.leftAnchor, paddingTop: 16, paddingLeft: 16, width: 100, height: 20)
         
        profileView.labelVideo.anchor(top: profileView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelVideo.centerX(inView: profileView.labelINTVideo)
        
        
        profileView.labelINTFollows.anchor(top: profileView.buttonSubscribe.bottomAnchor, paddingTop: 16, width: 100, height: 16)
        profileView.labelINTFollows.centerX(inView: profileView.viewTop)
        
        
        profileView.labelFollows.anchor(top: profileView.labelINTVideo.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelFollows.centerX(inView: profileView.viewTop)
        
  
        profileView.labelINTFolowers.anchor(top: profileView.buttonSubscribe.bottomAnchor, right: profileView.viewTop.rightAnchor, paddingTop: 16, paddingRight:  16, width: 100, height: 20)
        
        profileView.labelFolowers.anchor(top: profileView.labelINTFolowers.bottomAnchor,paddingTop: 4,width: 100,height: 16)
        profileView.labelFolowers.centerX(inView: profileView.labelINTFolowers)
        
        
        profileView.labelDescription.anchor(top: profileView.labelFollows.bottomAnchor, left: profileView.viewTop.leftAnchor, right: profileView.viewTop.rightAnchor,  paddingTop: 10, paddingLeft: 15, paddingRight: 5)
        
        profileView.buttonHelpCoach.anchor(bottom:profileView.viewTop.bottomAnchor,paddingBottom: -5,width: 40, height: 30)
        profileView.buttonHelpCoach.centerX(inView: profileView.viewTop)
        profileView.buttonHelpCoach.isUserInteractionEnabled = false
    
    }
}
