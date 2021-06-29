//
//  FirstVC.swift
//  FitMeet
//
//  Created by novotorica on 16.06.2021.
//

import Foundation
import UIKit
import Combine
import AVFoundation
import AVKit
import Foundation
import Combine
import UIKit

class FirstVC: UIViewController  {
    

  
    let homeView = FirstVCCode()
    var parentView: ParView?
    
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    
    var listBroadcast: [BroadcastResponce] = []
    var filtredBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()

    private let searchController = UISearchController(searchResultsController: nil)
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        homeView.tableView.reloadData()
        self.navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
     //   homeView.tableView.reloadData()
    
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        makeTableView()
        navigationItem.largeTitleDisplayMode = .always
       // makeNavItem()
        binding()
        homeView.tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshAlbumList), for: .valueChanged)
        parentView?.delegate = self
    }

    //MARK: - Selectors
    @objc private func refreshAlbumList() {
        print("refrech")
        binding()
       // makeReguest(searchText:viewModel.lastRequestName)
       }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
               // print("RESPONCE ====== \(response)")
                if response.data != nil  {
                    print("Responce ====== \(response)")
                    self.listBroadcast = response.data!
                    self.homeView.tableView.reloadData()
                    self.refreshControl.endRefreshing()
                }
        })
    }
    

    private func makeTableView() {
        homeView.tableView.dataSource = self
        homeView.tableView.delegate = self
        homeView.tableView.register(FirstVCCell.self, forCellReuseIdentifier: FirstVCCell.reuseID)
    }
    func filterContentForSearchText(_ searchText: String,category: BroadcastResponce? = nil) {
        
        filtredBroadcast = listBroadcast.filter { (candy: BroadcastResponce) -> Bool in
            return (candy.name?.lowercased().contains(searchText.lowercased()) ?? true)
          }
          
        homeView.tableView.reloadData()
    }

}


extension FirstVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listBroadcast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FirstVCCell", for: indexPath) as! FirstVCCell
       // let text = viewModel.shared()[indexPath.row].searchText
        cell.setImage(image: listBroadcast[indexPath.row].previewPath ?? "https://dev.fitliga.com/fitmeet-test-storage/azure-qa/files_8b12f58d-7b10-4761-8b85-3809af0ab92f.jpeg")
        cell.labelDescription.text = listBroadcast[indexPath.row].categories?.first?.description
        cell.titleLabel.text = listBroadcast[indexPath.row].name
        guard let category = listBroadcast[indexPath.row].categories?.first?.title, let category2 = listBroadcast[indexPath.row].categories?.last?.title else { return cell}
        cell.labelCategory.text = category + " \u{2665} " +  category2
        
        return cell
    }
}
extension FirstVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 330
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let url = self.listBroadcast[indexPath.row].streams?.first?.hlsPlaylistUrl
        guard let Url = url else { return }
        let videoURL = URL(string: Url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        self.present(playerViewController, animated: true) {
            playerViewController.player!.play()
        }

    }

}

extension FirstVC: SearchTexttoVC {
    func onChangeText() {
        print("FAKAKAKAK")
    }
    
    
}
