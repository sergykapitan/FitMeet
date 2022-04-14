//
//  ExtentionSearchCategory.swift
//  MakeStep
//
//  Created by Sergey on 14.04.2022.
//

import Foundation
import UIKit

extension SearchCategory: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { 
        return listCategory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchVCCategory") as! SearchVCCategory
        cell.labelDescription.text = listCategory[indexPath.row].title
        return cell
    }
}
extension SearchCategory: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return 40
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
                    let detailVC = CategoryBroadcast()
                    detailVC.categoryid = listCategory[indexPath.row].id
                    detailVC.categoryTitle = listCategory[indexPath.row].title
                    navigationController?.pushViewController(detailVC, animated: true)
                    return
    }
}

