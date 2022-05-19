//
//  ExtentionSearchVideoVC.swift
//  MakeStep
//
//  Created by Sergey on 13.04.2022.
//

import UIKit

extension SearchVideoVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCCell") as! SearchVCCell
       
        cell.labelDescription.text = listBroadcast[indexPath.row].name
        cell.titleLabel.text = listBroadcast[indexPath.row].categories?.first?.title
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? Constants.defoultImage )
        cell.buttonMore.tag = indexPath.row
        cell.buttonMore.addTarget(self, action: #selector(actionMore), for: .touchUpInside)
        cell.buttonMore.isUserInteractionEnabled = true
        return cell
    }
    @objc func actionMore(_ sender: UIButton) {
        guard token != nil else {
            let sign = SignInViewController()
            self.present(sign, animated: true, completion: nil)
            return
        }
        showDownSheet(moreArtworkOtherUserSheetVC, payload: listBroadcast[sender.tag].id)
    }
    
}
extension SearchVideoVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       let sizeCell:CGFloat = 96
       return sizeCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = PlayerViewVC()
            vc.broadcast = self.listBroadcast[indexPath.row]
            vc.id =  self.listBroadcast[indexPath.row].userId
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)

     }
}

