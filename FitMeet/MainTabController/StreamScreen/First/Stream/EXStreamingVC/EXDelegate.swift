//
//  EXDelegate.swift
//  FitMeet
//
//  Created by novotorica on 01.05.2021.
//

import Foundation
import UIKit

extension StreamingVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let navVC = LiveStreamViewController()
        
       // let indexPath = tableView.indexPathForSelectedRow
       // let currentCell = tableView.cellForRow(at: indexPath)! as UITableViewCell
        navVC.modalPresentationStyle = .fullScreen
       // navVC.idBroadcast = listBroadcast[indexPath.row].id
        let album = listBroadcast[indexPath.row].id
        print("currentCell.textLabel?.text ======== \(album)")
        navVC.idBroadcast = album
        self.present(navVC, animated: true, completion: nil)

    }
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//       
//       // let his = viewModel.shared()[indexPath.row]
//       // let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") {  (contextualAction, view, boolValue) in
//
//        //    self.viewModel.delete(text: his)
//        //    tableView.reloadData()
//       }
//     //  let swipeActions = UISwipeActionsConfiguration(actions: [deleteAction])
//
//     //  return swipeActions
//   }
}
