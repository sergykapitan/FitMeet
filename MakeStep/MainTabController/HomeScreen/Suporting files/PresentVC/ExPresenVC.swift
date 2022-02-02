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
