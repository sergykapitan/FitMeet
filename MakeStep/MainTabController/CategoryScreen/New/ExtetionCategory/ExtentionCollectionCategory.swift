//
//  ExtentionCollectionCategory.swift
//  FitMeet
//
//  Created by novotorica on 08.06.2021.
//

import Foundation
import UIKit


extension CategoryVC: UICollectionViewDataSource {
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      //  return listBroadcast.count
        return filtredBroadcast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else { return CategoryCell()}
        let newUrl = URL(string:filtredBroadcast[indexPath.row].resizedPreview?["preview_m"]?.jpeg ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_eee66711-a824-415f-a64e-3e0857e37956.jpeg")
       
        guard let url = newUrl,
              let title = filtredBroadcast[indexPath.row].title else { return cell }
        
        cell.buttonLike.addTarget(self, action: #selector(editButtonTapped), for: .touchUpInside)
        cell.buttonLike.tag = indexPath.row
        cell.buttonLike.isUserInteractionEnabled = true
        
        if filtredBroadcast[indexPath.row].isFollow ?? false {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
        } else {
            cell.buttonLike.setImage(#imageLiteral(resourceName: "LikeNot"), for: .normal)
        }
        if filtredBroadcast[indexPath.row].isPopular {
            cell.viewOverlay.isHidden = false
            cell.textOverlay.text = "Popular"
            cell.textOverlay.textColor = .red
            
        } else {
            cell.viewOverlay.isHidden = true
        }

    
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .white
        cell.configureCell(albumName: filtredBroadcast[indexPath.row].followersCount, url: url, artistName: title)
        stopSpiners()
        return cell
    }
}

extension CategoryVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let detailVC = CategoryBroadcast()
        detailVC.categoryid = filtredBroadcast[indexPath.row].id
        detailVC.categoryTitle = filtredBroadcast[indexPath.row].title
        navigationController?.pushViewController(detailVC, animated: true)
                
     }
}
extension CategoryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = (self.view.frame.size.width - 12 * 4) / 2 //some width
        let height = width * 1.4 //ratio

      return CGSize(width: width,
                    height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize.zero
    }
}
