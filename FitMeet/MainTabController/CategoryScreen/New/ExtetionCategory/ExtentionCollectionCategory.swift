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
        return listBroadcast.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCell.reuseID, for: indexPath) as? CategoryCell else { return CategoryCell()}
        let newUrl = URL(string:listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_eee66711-a824-415f-a64e-3e0857e37956.jpeg")
        guard let url = newUrl,
              let name = listBroadcast[indexPath.row].followersCount,
              let title = listBroadcast[indexPath.row].title else { return cell }
        cell.contentView.layer.cornerRadius = 8
        cell.contentView.layer.borderWidth = 1.0
        cell.contentView.layer.borderColor = UIColor.clear.cgColor
        cell.contentView.layer.masksToBounds = true
        cell.backgroundColor = .white
        cell.configureCell(albumName: name, url: url, artistName: title)
        stopSpiners()
        return cell
    }
}

extension CategoryVC: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print(listBroadcast[indexPath.row].followersCount)
        print(listBroadcast[indexPath.row].datumDescription)
        print(listBroadcast[indexPath.row].rate)
                
     }
}
extension CategoryVC: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
      
      return CGSize(width: collectionView.bounds.width * 0.45,
                    height: UIScreen.main.bounds.width * 0.50)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
      return CGSize.zero
    }
}
