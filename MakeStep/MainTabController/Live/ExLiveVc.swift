//
//  ExLiveVc.swift
//  MakeStep
//
//  Created by Sergey on 06.05.2022.
//


import UIKit

extension LiveVC: UITableViewDataSource, UITableViewDelegate {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return titleSection.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case 0 :
            return  liveBroadcast.count
            case 1:
            return  recentBroadcast.count
            case 2:
            return  plannedBroadcast.count
            
        default:
            break
        }
        return  listBroadcast.count
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            view.backgroundColor = .white
            let label = UILabel(frame: CGRect(x: 16, y: 5, width: tableView.frame.width, height: 20))
            label.text = titleSection[section]
            label.backgroundColor = UIColor.clear
            label.font = UIFont.boldSystemFont(ofSize: 20)
            view.addSubview(label)
            return view
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     
   
              let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell
        switch indexPath.section {
        case 0:
              cell.setImage(image: liveBroadcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
              cell.labelDescription.text = liveBroadcast[indexPath.row].name
              guard let id = liveBroadcast[indexPath.row].userId else { return cell}
              
              cell.setImageLogo(image: self.userMap[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
              cell.titleLabel.text = self.userMap[id]?.fullName
              
              cell.buttonMore.tag = self.liveBroadcast[indexPath.row].id!
              cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
              cell.buttonMore.isUserInteractionEnabled = true
        case 1:
            cell.setImage(image: recentBroadcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
            cell.labelDescription.text = recentBroadcast[indexPath.row].name
            guard let id = recentBroadcast[indexPath.row].userId else { return cell}
            
            cell.setImageLogo(image: self.userMap[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
            cell.titleLabel.text = self.userMap[id]?.fullName
            
            cell.buttonMore.tag = self.recentBroadcast[indexPath.row].id!
            cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
            cell.buttonMore.isUserInteractionEnabled = true
        case 2:
            cell.setImage(image: plannedBroadcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
            cell.labelDescription.text = plannedBroadcast[indexPath.row].name
            guard let id = plannedBroadcast[indexPath.row].userId else { return cell}
            
            cell.setImageLogo(image: self.userMap[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
            cell.titleLabel.text = self.userMap[id]?.fullName
            
            cell.buttonMore.tag = self.plannedBroadcast[indexPath.row].id!
            cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
            cell.buttonMore.isUserInteractionEnabled = true
            
        default:
            break
        }
            return cell
      
    }
  
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return
        }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: sender.tag)
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = PlayerViewVC()
        var status:BroadcastStatus  = .offline
        switch indexPath.section {
        case 0:
            guard let statuslive = liveBroadcast[indexPath.row].status  else { return }
            status = statuslive
        case 1:
            guard let statuslive = recentBroadcast[indexPath.row].status  else { return }
            status = statuslive
        case 2:
            guard let statuslive = plannedBroadcast[indexPath.row].status  else { return }
            status = statuslive
        default:
            break
        }
        switch status {
          
        case .online:
            guard let broadcastID = self.liveBroadcast[indexPath.row].id,
                    let channelId = self.liveBroadcast[indexPath.row].channelIds else { return }
            self.connectUser(broadcastId:"\(broadcastID)", channellId: "\(channelId)")
            vc.broadcast = self.liveBroadcast[indexPath.row]
            vc.id =  self.liveBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = false
            vc.homeView.playerSlider.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.liveBroadcast[indexPath.row].followersCount!))"
            vc.homeView.buttonPlayPause.isHidden = true
            vc.homeView.buttonSkipNext.isHidden = true
            vc.homeView.buttonSkipPrevious.isHidden = true
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        case .offline:
            guard let _ = recentBroadcast[indexPath.row].streams?.first?.vodUrl else { return }
            vc.broadcast = self.recentBroadcast[indexPath.row]
            vc.id = self.recentBroadcast[indexPath.row].userId
            vc.homeView.buttonChat.isHidden = true
            vc.homeView.overlay.isHidden = true
            vc.homeView.imageLive.isHidden = true
            vc.homeView.labelLive.isHidden = true
            vc.homeView.imageEye.isHidden = true
            vc.homeView.labelEye.isHidden = true
            vc.homeView.labelLike.text = "\(String(describing: self.recentBroadcast[indexPath.row].followersCount!))"
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
    }
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
            let cell = tableView.cellForRow(at: indexPath)
            let selectedColor: UIColor
            let selectedView = UIView(frame: CGRect.zero)
            if tableView.isEditing == true {
                selectedColor = .clear
            } else {
                selectedColor = .lightGray
            }
            selectedView.backgroundColor = selectedColor
            cell?.multipleSelectionBackgroundView = selectedView
            return true
        }
  
}
