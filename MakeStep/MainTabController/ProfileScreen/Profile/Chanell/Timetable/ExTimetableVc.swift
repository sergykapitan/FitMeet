//
//  ExTimetableVc.swift
//  MakeStep
//
//  Created by Sergey on 01.12.2021.
import TimelineTableViewCell
import UIKit
//

extension TimetableVC: UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return data.count
//    }
//
//     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        guard let sectionData = data[section] else {
//            return 0
//        }
//        return sectionData.count
//    }
//    
//     func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return "Day " + String(describing: section + 1)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "TimelineTableViewCell", for: indexPath) as! TimelineTableViewCell
//
//        // Configure the cell...
//        guard let sectionData = data[indexPath.section] else {
//            return cell
//        }
//        
//        let (timelinePoint, timelineBackColor, title, description, lineInfo, thumbnails, illustration) = sectionData[indexPath.row]
//        var timelineFrontColor = UIColor.clear
//        if (indexPath.row > 0) {
//            timelineFrontColor = sectionData[indexPath.row - 1].1
//        }
//        cell.timelinePoint = timelinePoint
//        cell.timeline.frontColor = timelineFrontColor
//        cell.timeline.backColor = timelineBackColor
//        cell.titleLabel.text = title
//        cell.descriptionLabel.text = description
//        cell.lineInfoLabel.text = lineInfo
//        
//        if let thumbnails = thumbnails {
//            cell.viewsInStackView = thumbnails.map { thumbnail in
//                return UIImageView(image: UIImage(named: thumbnail))
//            }
//        }
//        else {
//            cell.viewsInStackView = []
//        }
//
//        if let illustration = illustration {
//            cell.illustrationImageView.image = UIImage(named: illustration)
//        }
//        else {
//            cell.illustrationImageView.image = nil
//        }
//   
//        return cell
//    }
//    
//   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        guard let sectionData = data[indexPath.section] else {
//            return
//        }
//        
//        print(sectionData[indexPath.row])
//    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
