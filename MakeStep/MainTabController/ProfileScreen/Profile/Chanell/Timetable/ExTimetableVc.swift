//
//  ExTimetableVc.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
import TimelineTableViewCell
//

extension TimetableVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
 
        return 30
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
   
       return 7
        
 
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    
        let calendar = Calendar.current
        return "Week " + String(describing: section + 1)
    }
 
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell

        // Configure the cell...
    
       // guard let sectionData2 = ddd[indexPath.section] else { return cell}
        
        
        
     
        
        var timelineFrontColor = UIColor.clear
        
        if (indexPath.row > 0) {
           // timelineFrontColor = sectionData[indexPath.row - 1].1
        }
        
        cell.timelinePoint = TimelinePoint(color: UIColor.red, filled: true)
        cell.timeline.frontColor = UIColor(hexString: "#3B58A4")
        cell.timeline.backColor = UIColor(hexString: "#3B58A4")
        cell.titleLabel.text = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "MMM d")
        cell.descriptionLabel.text = "\(brodcast!.data![indexPath.row].name!)/n" + "\(brodcast!.data![indexPath.row].description!)/n" + "\(brodcast!.data![indexPath.row].categories?.first?.description!)"
        cell.descriptionLabel.backgroundColor = UIColor(hexString: "#3B58A4")
        cell.descriptionLabel.layer.cornerRadius = 6
        cell.descriptionLabel.layer.borderWidth = 1
        cell.descriptionLabel.layer.borderColor = UIColor.black.cgColor
        cell.descriptionLabel.layer.masksToBounds = true

        cell.lineInfoLabel.text = brodcast!.data![indexPath.row].scheduledStartDate!.getFormattedDate(format: "HH:mm")
        
//        if let thumbnails = "thumbnails" {
        
        cell.viewsInStackView = [UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail")),UIImageView(image: UIImage(named: "thumbnail"))]
        
 //            thumbnails.map { thumbnail in
  //              return UIImageView(image: UIImage(named: thumbnail))
//            }
//        }
      //  else {
            cell.viewsInStackView = []
     //   }

//        if let illustration = illustration {
            cell.illustrationImageView.image = UIImage(named: "illustration")
//        }
//        else {
  //          cell.illustrationImageView.image = nil
      //  }
   
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let sectionData = brodcast?.data?[indexPath.section] else {
             
            return
        }
       let g =  brodcast?.asDictionaryInt()
        
        for i in brodcast!.data! {
            print("iiiiiiiii====\(i)")
        }
        let f = brodcast!.data![indexPath.row]
        print("ffffffffffff======\(f)")
        
        print("Dict ==== \(g)")
        
        print(sectionData.name)
    }


}
