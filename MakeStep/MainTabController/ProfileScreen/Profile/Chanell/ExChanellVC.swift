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

       
        
        if brodcast[indexPath.row].previewPath == "/path/to/file.jpg" {
            cell.setImage(image:"https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        } else {
            cell.setImage(image: brodcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        }


      

        cell.labelDescription.text = brodcast[indexPath.row].description
        cell.titleLabel.text = self.user?.fullName
        
 
        guard let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
      
//       if brodcast[indexPath.row].status == "PLANNED" {
//
//
//            cell.label.text = self.brodcast[indexPath.row].name
//            cell.backgroundImage.removeBlur()
//            cell.backgroundImage.backgroundColor = .clear
//            cell.imageLive.image = #imageLiteral(resourceName: "clock")
//            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
//            cell.backgroundImage.applyBlurEffect()
//
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//            cell.overlay.anchor(width: 80)
//
//        }
        if brodcast[indexPath.row].status == "OFFLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.imageLive.setImageColor(color: .gray)
            cell.labelLive.text = "Offline"
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            cell.buttonstartStream.isHidden = true
   
        } else if brodcast[indexPath.row].status == "ONLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.labelLive.text = "Live"
            cell.imageEye.isHidden = false
            cell.labelEye.isHidden = false
            cell.logoUserOnline.isHidden = false
            cell.buttonstartStream.isHidden = true

        } else if brodcast[indexPath.row].status == "PLANNED" {
            cell.imageLive.image = #imageLiteral(resourceName: "clock")
            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
            cell.logoUserOnline.isHidden = true
            cell.buttonstartStream.isHidden = false

        }
        
        let categorys = brodcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row

        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")



        if brodcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }



        self.url = self.brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        guard let selfID = selfId else { return cell}
        if self.usersd[id]?.id == Int(selfID) {
            cell.buttonLike.isHidden = true
          //  cell.buttonstartStream.isHidden = false
        } else {
            cell.buttonLike.isHidden = false
          //  cell.buttonstartStream.isHidden = true
        }

        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.isUserInteractionEnabled = true

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        
//        cell.buttonstartStream.tag = indexPath.row
//        cell.buttonstartStream.addTarget(self, action: #selector(actionStartStream(_:)), for: .touchUpInside)
//        cell.buttonstartStream.isUserInteractionEnabled = true
      
      
        
       return cell
    }
    @objc func editButtonTapped(_ sender: UIButton) -> Void {
        if sender.currentImage == UIImage(named: "LikeNot") {
            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
           // self.followBroadcast(id: id)
        } else {
            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
           guard let id = brodcast[sender.tag].id else { return }
           // self.unFollowBroadcast(id: id)
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
          //  self.nextView(broadcastId: broadcastID)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        vc.urlStream = self.brodcast[indexPath.row].streams?.first?.vodUrl
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
