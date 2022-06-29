//
//  ExtentionSearchUser.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//
import UIKit

extension SearchUserVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let listUsers = listUsers else { return 0 }
        return listUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCUserCell") as! SearchVCUserCell
        guard let listUsers = listUsers else { return cell }
        cell.setImage(image: listUsers[indexPath.row].avatarPath ?? "http://getdrawings.com/free-icon/male-avatar-icon-52.png" )
        cell.layoutIfNeeded()
      
        
        guard let userID = listUsers[indexPath.row].channelIds?.last else { return cell}
        guard let followers = self.channellsd[userID]?.followersCount else { return cell}
        cell.labelDescription.text = channellsd[userID]?.name
        cell.titleLabel.text = "\(followers)" + "  Folowers"
        return cell
    }
   
    
}
extension SearchUserVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 77
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let listUsers = listUsers else { return  }
        let user = listUsers[indexPath.row]
        guard let ids = user.id else { return }
        
        DispatchQueue(label: "getPhotos").sync {
            self.getBroadcast(userId: "\(ids)")

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                           let vc = ChannelCoach()
                           vc.modalPresentationStyle = .fullScreen
                           vc.user = user
               self.navigationController?.pushViewController(vc, animated: true)

           }
       }
    }
}

