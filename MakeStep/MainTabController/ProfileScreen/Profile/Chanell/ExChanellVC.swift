//
//  ExChanellVC.swift
//  MakeStep
//
//  Created by novotorica on 22.09.2021.
//

import Foundation
import UIKit

extension ChanellVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard let broadcast = self.brodcast else { return 0 }
        return  brodcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        cell.setImage(image: brodcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = brodcast[indexPath.row].description
        
        
        
        cell.titleLabel.text = brodcast[indexPath.row].name
        guard let category = brodcast[indexPath.row].categories?.first?.title,
              let category2 = brodcast[indexPath.row].categories?.last?.title,
              let id = brodcast[indexPath.row].userId,
              let broadcastID = self.brodcast[indexPath.row].id
              else { return cell}
        if brodcast[indexPath.row].status == "OFFLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "fiber_manual_record_24px1")
            cell.labelLive.text = "Offline"
            cell.imageEye.isHidden = true
            cell.labelEye.isHidden = true
        } else if brodcast[indexPath.row].status == "ONLINE" {
            cell.imageLive.image = #imageLiteral(resourceName: "rec")
            cell.labelLive.text = "Live"
            cell.imageEye.isHidden = false
            cell.labelEye.isHidden = false
        }
//        self.arrayIdUser.append(id)
//       // self.bindingUserMap(ids: arrayIdUser)
//        self.bindingUser(id: id)
//        let us = usersd.map { key,user in
//            return user
//        }
        
//        self.ids.append(broadcastID)
//        self.getMapWather(ids: [broadcastID])
//        cell.labelEye.text = "\(self.watch)"
 
        let categorys = brodcast[indexPath.row].categories
        let s = categorys!.map{$0.title!}
        //let arrarID = categorys!.map{$0.id!}
        //let fullStack = Dictionary(uniqueKeysWithValues: zip(s, arrarID))
        //fullStack.tag = indexPath.row
        //.reduce("") { $0.title +  + $1.title }
        //let array = s.components(separatedBy: " ")
        let arr = s.map { String("\u{0023}" + $0)}
        cell.tagView.removeAllTags()
        cell.tagView.addTags(arr)
       // cell.tagView.delegate = self
        cell.tagView.isUserInteractionEnabled = true
        cell.tagView.tag = indexPath.row
  
        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        

       
        
        if brodcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }
    
       // print("SELF US ==== \(us.count)")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            cell.setImageLogo(image: self.user?.avatarPath ?? "https://logodix.com/logo/1070633.png")
        }
       
 //       self.url = self.brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
//
//
//        cell.buttonLike.tag = indexPath.row
//        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
//        cell.buttonLike.isUserInteractionEnabled = true
//
//        cell.buttonMore.tag = indexPath.row
//        cell.buttonMore.addTarget(self, action: #selector(moreButtonTapped), for: .touchUpInside)
//        cell.buttonMore.isUserInteractionEnabled = true
//
        
        
        return cell
    }
    
    
    
    
}
