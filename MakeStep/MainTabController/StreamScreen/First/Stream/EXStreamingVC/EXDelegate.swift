//
//  EXDelegate.swift
//  FitMeet
//
//  Created by novotorica on 01.05.2021.
//

import Foundation
import UIKit

extension StreamingVC: UITableViewDelegate {
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 128
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 88
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let navVC = LiveStreamViewController()
        navVC.modalPresentationStyle = .fullScreen
        guard  let chanellID = listChanell[indexPath.row].id else { return }
        print(chanellID)
        navVC.idBroadcast = chanellID
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
