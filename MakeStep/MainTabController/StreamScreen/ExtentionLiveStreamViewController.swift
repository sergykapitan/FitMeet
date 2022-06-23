//
//  ExtentionLiveStreamViewController.swift
//  MakeStep
//
//  Created by Sergey on 17.06.2022.
//

import Foundation
import UIKit


    extension LiveStreamViewController: UICollectionViewDataSource {
        

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filtredBroadcast.count
        }

        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
     
            
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserPlayerCell.reuseID, for: indexPath) as? UserPlayerCell else { return UserPlayerCell()}
            let newUrl = URL(string:filtredBroadcast[indexPath.row].resizedPreview?["cat_preview_l"]?.jpeg ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_eee66711-a824-415f-a64e-3e0857e37956.jpeg")
           
            guard let url = newUrl,
                  let title = filtredBroadcast[indexPath.row].title else { return cell }
            cell.contentView.layer.cornerRadius = 8
            cell.contentView.layer.borderWidth = 1.0
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.masksToBounds = true
            cell.backgroundColor = .white
            cell.configureCell(albumName: filtredBroadcast[indexPath.row].followersCount, url: url, artistName: title)
            return cell
        }
    }

    extension LiveStreamViewController: UICollectionViewDelegate {

        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
 
                    
         }
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
    
        }

      func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
         
        }
      

   

    }
    extension LiveStreamViewController: UICollectionViewDelegateFlowLayout {

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            sizeForItemAt indexPath: IndexPath) -> CGSize {
            
            let width = 80
            let height = 188

          return CGSize(width: width, height: height)
        }

        func collectionView(_ collectionView: UICollectionView,
                            layout collectionViewLayout: UICollectionViewLayout,
                            referenceSizeForHeaderInSection section: Int) -> CGSize {
            return  CGSize.zero
        }
    }
