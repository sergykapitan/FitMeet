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
            return  listBroadcast.count
            case 1:
            return  listBroadcast.count
            case 2:
            return  listBroadcast.count
            
        default:
            break
        }
        return  listBroadcast.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return titleSection[section]
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            
            view.textLabel?.backgroundColor = UIColor.clear
            view.textLabel?.textColor = UIColor.black
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
     
   
              let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell
               cell.setImage(image: listBroadcast[indexPath.row].resizedPreview?["preview_l"]?.jpeg  ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
               cell.labelDescription.text = listBroadcast[indexPath.row].name
               guard let id = listBroadcast[indexPath.row].userId else { return cell}
               
               cell.setImageLogo(image: self.userMap[id]?.resizedAvatar?["avatar_120"]?.png ?? "https://logodix.com/logo/1070633.png")
               cell.titleLabel.text = self.userMap[id]?.fullName
               
               cell.buttonMore.tag = indexPath.row
               cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
               cell.buttonMore.isUserInteractionEnabled = true
            return cell
      
    }
  
    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return
        }
        guard let broadcastId = self.listBroadcast[sender.tag].id else { return }
            showDownSheet(moreArtworkOtherUserSheetVC, payload: broadcastId)
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  let like = listBroadcast[indexPath.row].followersCount else { return }
        guard let status = listBroadcast[indexPath.row].status  else { return }
        switch status {
          
        case .online:
           print("To Do")
        case .offline:
            print("To Do")
        case .planned:
            print("To Do")
        case .banned:
            print("To Do")
        case .finished:
            print("To Do")
        case .wait_for_approve:
            print("To Do")
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
