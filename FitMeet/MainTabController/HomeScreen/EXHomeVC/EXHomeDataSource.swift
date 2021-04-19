//
//  EXHomeDataSource.swift
//  FitMeet
//
//  Created by novotorica on 19.04.2021.
//

import UIKit


extension HomeVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableviewCell.reuseID, for: indexPath) as? HomeTableviewCell else { return HomeTableviewCell() }
       // let text = viewModel.shared()[indexPath.row].searchText
        cell.video = videos[indexPath.row]
        return cell
    }
}
