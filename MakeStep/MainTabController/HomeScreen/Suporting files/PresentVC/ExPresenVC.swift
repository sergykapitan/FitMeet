//
//  ExPresenVC.swift
//  MakeStep
//
//  Created by novotorica on 27.09.2021.
//


import UIKit
import EasyPeasy
import TimelineTableViewCell

extension PresentVC: UITableViewDataSource, UITableViewDelegate {
   
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return  brodcast.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//            let cell = tableView.dequeueReusableCell(withIdentifier: PlayerViewCell.reuseID, for: indexPath) as! PlayerViewCell
//
//
//
//        if brodcast[indexPath.row].previewPath == "/path/to/file.jpg" {
//            cell.setImage(image:"https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
//        } else {
//            cell.setImage(image: brodcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
//        }
//
//
//        cell.buttonLandscape.isHidden = true
//        if indexTab == 1 {
//
//            cell.data = brodcast[indexPath.row]
//            self.mmPlayerLayer.playView?.isHidden = false
//
//        }
//        if indexTab == 2 {
//            cell.data = nil
//            self.mmPlayerLayer.playView?.isHidden = false
//        }
//
//
//        cell.labelDescription.text = brodcast[indexPath.row].description
//        cell.titleLabel.text = brodcast[indexPath.row].name
//
//        guard let id = brodcast[indexPath.row].userId,
//              let broadcastID = self.brodcast[indexPath.row].id
//              else { return cell}
//        if brodcast[indexPath.row].status == "PLANNED" {
//            cell.imageLive.image = #imageLiteral(resourceName: "clock")
//            cell.labelLive.text = brodcast[indexPath.row].scheduledStartDate?.getFormattedDate(format: "dd.MM.yy")
//
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//
//        } else if brodcast[indexPath.row].status == "ONLINE" {
//            cell.imageLive.image =  #imageLiteral(resourceName: "slider")
//            cell.labelLive.text = "Live"
//            cell.imageEye.isHidden = false
//            cell.labelEye.isHidden = false
//
//
//        } else if brodcast[indexPath.row].status == "OFFLINE" {
//            cell.imageLive.image =  #imageLiteral(resourceName: "slider")
//            cell.imageLive.setImageColor(color: .gray)
//            cell.labelLive.text = "Offline"
//            cell.imageEye.isHidden = true
//            cell.labelEye.isHidden = true
//
//
//        }
//
//        let categorys = brodcast[indexPath.row].categories
//        let s = categorys!.map{$0.title!}
//        let arr = s.map { String("\u{0023}" + $0)}
//        cell.tagView.removeAllTags()
//        cell.tagView.addTags(arr)
//        cell.tagView.isUserInteractionEnabled = true
//        cell.tagView.tag = indexPath.row
//
//        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
//        cell.setImageLogo(image: self.usersd[id]?.avatarPath ?? "https://logodix.com/logo/1070633.png")
//
//
//
//        if brodcast[indexPath.row].isFollow ?? false {
//            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
//        } else {
//            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
//        }
//
//
//
//        self.url = self.brodcast[indexPath.row].streams?.first?.hlsPlaylistUrl
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
////        cell.buttonLandscape.tag = indexPath.row
////        cell.buttonLandscape.addTarget(self, action: #selector(editButtonLandscape), for: .touchUpInside)
////        cell.buttonLandscape.isUserInteractionEnabled = true
//
//       return cell
//    }
//    @objc func editButtonTapped(_ sender: UIButton) -> Void {
//        if sender.currentImage == UIImage(named: "LikeNot") {
//            sender.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
//           guard let id = brodcast[sender.tag].id else { return }
//            self.followBroadcast(id: id)
//        } else {
//            sender.setImage(UIImage(named: "LikeNot"), for: .normal)
//           guard let id = brodcast[sender.tag].id else { return }
//            self.unFollowBroadcast(id: id)
//        }
//    }
//    @objc func moreButtonTapped(_ sender: UIButton) -> Void {
//
//        let detailViewController = SendVC()
//        actionSheetTransitionManager.height = 0.2
//        detailViewController.modalPresentationStyle = .custom
//        detailViewController.transitioningDelegate = actionSheetTransitionManager
//        detailViewController.url = self.url
//        present(detailViewController, animated: true)
//
//    }
//    @objc func editButtonLandscape(_ sender: UIButton) -> Void {
//
//        sender.isSelected.toggle()
//
//        if sender.isSelected {
//            guard let path = self.findCurrentPath() else { return }
//            let cell = self.findCurrentCell(path: path) as! PlayerViewCell
//            myCell = cell
//
//           guard let viewss = self.mmPlayerLayer.playView else { return }
//            cell.overlay.removeFromSuperview()
//            cell.labelLive.removeFromSuperview()
//            cell.imageLive.removeFromSuperview()
//            AppUtility.lockOrientation(.landscapeLeft, andRotateTo: .landscapeLeft)
//
//
//            UIView.animate(withDuration: 0.3) {
//                self.view.insertSubview(viewss, aboveSubview: self.view)
//                viewss.easy.layout(Top(0),Left(0),Right(0),Bottom(0))
//                self.mmPlayerLayer.playView = cell.backgroundImage
//
//                self.view.insertSubview(cell.buttonLandscape, aboveSubview: self.view)
//                cell.buttonLandscape.anchor(right:self.mmPlayerLayer.playView?.rightAnchor,bottom: self.mmPlayerLayer.playView?.bottomAnchor,paddingRight: 40,paddingBottom: 2)
//                self.view.layoutIfNeeded()
//            }
//            print("Frame = \(self.mmPlayerLayer.playView?.frame)")
//
//            homeView.tableView.isUserInteractionEnabled = true
//      self.tabBarController?.tabBar.isHidden = true
//      self.navigationController?.isNavigationBarHidden = true
//
//        } else {
//
//            AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
//            UIView.animate(withDuration: 0.3) {
//                guard let view = self.mmPlayerLayer.playView , let cell = self.myCell else { return }
//                self.mmPlayerLayer.playView = nil
//                cell.backgroundImage.removeFromSuperview()
//                cell.buttonLandscape.removeFromSuperview()
//                view.layoutIfNeeded()
//            }
//            self.homeView.tableView.scrollToRow(at: IndexPath(row: sender.tag, section: 0), at: .top, animated: true)
//          //  self.profileView.tableView.reloadData()
//            self.tabBarController?.tabBar.isHidden = false
//            self.navigationController?.isNavigationBarHidden = false
//        }
//    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        guard let sectionData = brodcastTime?.data! else { return 0}
        return sectionData.count
  
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return ""
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell

        
        let string = brodcastTime!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "yyyy-MM-dd")
        let dateFormat = "yyyy-MM-dd"

        let dateFormatter = DateFormatter()
        
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = dateFormat
        let g = dateFormatter.date(from: string)!
        let today = dateFormatter.date(from: Date().getFormattedDate(format: "yyyy-MM-dd"))
        cell.backgroundColor = UIColor(hexString: "#F6F6F6")
        
       
        cell.viewBack.layer.cornerRadius = 6
        cell.viewBack.layer.borderWidth = 1
        cell.viewBack.layer.borderColor = UIColor(hexString: "#B7B7B7").cgColor
        cell.viewBack.layer.masksToBounds = true
        cell.selectionStyle = .none
        
        cell.lineInfoLabel.textColor = UIColor(hexString: "#B7B7B7")
        
        let str = brodcastTime!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "yyyy-MM-dd HH:mm:ss")
        let dateFormatTime = "yyyy-MM-dd HH:mm:ss"

        let dateFormatterTime = DateFormatter()
        dateFormatterTime.dateFormat = dateFormatTime
        
        let dateStartStreamTime = dateFormatterTime.date(from: str)
        let todayTime = Date()
        
        if g < today! {
            cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
            cell.labelDescription.textColor = UIColor(hexString: "#B7B7B7")
            cell.imageLogo.isHidden = true
            cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
            cell.viewBack.backgroundColor = UIColor(hexString: "#F6F6F6")
            cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
            cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
            cell.timeline.backColor = UIColor(hexString: "#3B58A4")
        }
        if g > today! {
            cell.imageLogo.isHidden = true
            cell.titleLabel.textColor = .black
            cell.viewBack.backgroundColor = UIColor.white
            cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
            cell.timeline.frontColor = UIColor.clear
            cell.timeline.backColor = UIColor.clear
        }
        if g == today! {
            if dateStartStreamTime! >= todayTime {
            cell.labelDescription.textColor = .white
            cell.imageLogo.isHidden = false
            cell.imageLogo.backgroundColor = .red
            cell.imageLogo.makeRounded()
            cell.titleLabel.textColor = UIColor(hexString: "#3B58A4")
            cell.viewBack.backgroundColor = UIColor(hexString: "#3B58A4")
            if i == 0 {
                    cell.timelinePoint = TimelinePoint(color: UIColor(hexString: "#3B58A4"), filled: true)
                    cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
                    cell.timeline.backColor = UIColor.clear
                    i = 1
            } else {
                cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
                cell.timeline.frontColor = UIColor.clear
                cell.timeline.backColor = UIColor.clear
            }
            
            let url = URL(string: brodcastTime!.data![indexPath.row].previewPath!)
            cell.imageLogo.kf.setImage(with: url)
            } else {
                cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
                cell.labelDescription.textColor = UIColor(hexString: "#B7B7B7")
                cell.imageLogo.isHidden = true
                cell.titleLabel.textColor = UIColor(hexString: "#B7B7B7")
                cell.viewBack.backgroundColor = UIColor(hexString: "#F6F6F6")
                cell.timelinePoint = TimelinePoint(color: UIColor.clear, filled: true)
                cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
                cell.timeline.backColor = UIColor(hexString: "#3B58A4")
            }
        }
        
        
        cell.bubbleEnabled = false
        cell.titleLabel.font = UIFont.boldSystemFont(ofSize: 14)
        cell.titleLabel.text = brodcastTime!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "MMMM d")
        
        cell.labelDescription.font = UIFont.systemFont(ofSize: 12)
        cell.labelDescription.numberOfLines = 3
        cell.labelDescription.text = "\(brodcastTime!.data![indexPath.row].name!)\n" + "\(brodcastTime!.data![indexPath.row].description!)"

        cell.lineInfoLabel.text = brodcastTime!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "h a")
        
        
        cell.viewsInStackView = [UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail"))]

            cell.viewsInStackView = []
            cell.illustrationImageView.image = UIImage(named: "illustration")

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = brodcastTime?.data?[indexPath.section] else { return }
      
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.red
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
 
}
