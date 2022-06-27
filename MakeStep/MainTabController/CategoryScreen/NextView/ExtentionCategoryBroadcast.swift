//
//  ExtentionCategoryBroadcast.swift
//  FitMeet
//
//  Created by novotorica on 10.06.2021.
//

import Foundation
import Kingfisher
import AVFoundation
import AVKit
import UIKit
import TagListView

extension CategoryBroadcast: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortListCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.hideAnimation()
        cell.setupImage(urlString: sortListCategory[indexPath.row].resizedPreview?["preview_l"]?.jpeg ?? Constants.defoultImage)
        cell.labelDescription.text = sortListCategory[indexPath.row].name
        
        cell.buttonLike.isHidden = false
        cell.overlayPlan.isHidden = true
        cell.overlayOffline.isHidden = true
        cell.overlay.isHidden = true
        
      
        guard
              let id = sortListCategory[indexPath.row].userId,
              let broadcastID = self.sortListCategory[indexPath.row].id,
              let subscriber = listBroadcast[indexPath.row].onlyForSubscribers
              else { return cell}
        cell.setImageLogo(image: self.usersd[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
        if let chanelId = sortListCategory[indexPath.row].channelIds?.last {
            cell.titleLabel.text = channellsd[chanelId]?.name
        }
        self.ids.append(broadcastID)
        let categorys = sortListCategory[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        let arr = s.map { String("\u{0023}" + $0)}
        
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
        cell.tagView.delegate = self
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row
       
        self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        guard let status = sortListCategory[indexPath.row].status  else { return cell}
        switch status {
            
        case .online:
            cell.overlayPlan.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlay.isHidden = false
            cell.logoUserOnline.isHidden = false
            self.url = self.sortListCategory[indexPath.row].streams?.first?.hlsPlaylistUrl
        case .offline:
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false

            if let time = sortListCategory[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                if subscriber {
                    cell.overlayOffline.labelLive.text = ""
                } else {
                    cell.overlayOffline.labelLive.text = "00:00"
                }
            }
            self.url = self.sortListCategory[indexPath.row].streams?.first?.vodUrl
        case .planned:
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = true
            cell.overlayPlan.isHidden = false
            
            cell.overlayPlan.labelLive.text = sortListCategory[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
            cell.logoUserOnline.isHidden = true
        case .banned:
            break
        case .finished:
            cell.overlayPlan.isHidden = true
            cell.overlay.isHidden = true
            cell.overlayOffline.isHidden = false

            if let time = sortListCategory[indexPath.row].streams?.first?.vodLength {
                cell.overlayOffline.labelLive.text =  "\(time.secondsToTime())"
            } else {
                if subscriber {
                    cell.overlayOffline.labelLive.text = ""
                } else {
                    cell.overlayOffline.labelLive.text = "00:00"
                }
            }
            self.url = self.sortListCategory[indexPath.row].streams?.first?.vodUrl
        case .wait_for_approve:
            break
        }
  
        cell.stackButton.tag = indexPath.row
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.tapGestureSelectorMy(_:)))
        cell.stackButton.addGestureRecognizer(tap)

        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        return cell
    }
   
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return }
        guard let broadcastId = sortListCategory[sender.tag].id else { return }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)

    }

    @objc func tapGestureSelectorMy(_ sender: UITapGestureRecognizer) {
        let tappedView = sender.view
        guard let viewTag = tappedView?.tag else { return }
        guard !listBroadcast.isEmpty else { return }
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        guard let id = listBroadcast[viewTag].userId else { return}
        vc.user = self.usersd[id]
        navigationController?.pushViewController(vc, animated: true)
        
    }
}
extension CategoryBroadcast: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 310
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    let vc = PlayerViewVC()
        vc.delegate = self
        vc.delegatePicInPic = self
        vc.broadcast = self.sortListCategory[indexPath.row]
        vc.id =  self.sortListCategory[indexPath.row].userId
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)

    }
}


extension CategoryBroadcast: TagListViewDelegate {
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        for ta in sender.tagViews {
        if ta.titleLabel?.text == title {
        ta.isSelected = !ta.isSelected
        }else{
        ta.isSelected = false
        }
      }
    }
}
extension CategoryBroadcast: OpenCoachDelegate {
    func coachTapped(userId: Int) {
        let vc = ChannelCoach()
        vc.modalPresentationStyle = .fullScreen
        vc.user = self.usersd[userId]
        navigationController?.pushViewController(vc, animated: true)
    }
}
extension CategoryBroadcast: CustomPlayerViewControllerDelegate {
  func playerViewControllerShouldAutomaticallyDismissAtPictureInPictureStart(_ playerViewController: PlayerViewVC) -> Bool {
    // Dismiss the controller when PiP starts so that the user is returned to the item selection screen.
    return true
  }

  func playerViewController(
    _ playerViewController: PlayerViewVC,
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void
  ) {
    playerViewController.picInPic = false
    restore(playerViewController: playerViewController, completionHandler: completionHandler)
  }
}
extension CategoryBroadcast {
  func restore(playerViewController: UIViewController, completionHandler: @escaping (Bool) -> Void) {
      if let presentedViewController = presentedViewController as? PlayerViewVC {
        presentedViewController.playerViewController?.player?.rate = 0
      presentedViewController.dismiss(animated: true) { [weak self] in
        self?.present(playerViewController, animated: true) {
          completionHandler(true)
        }
      }
    } else {
      present(playerViewController, animated: true) {
        completionHandler(true)
      }
    }
  }
}
