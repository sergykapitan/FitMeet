//
//  PresentVC.swift
//  MakeStep
//
//  Created by novotorica on 09.07.2021.
//


import Combine
import UIKit

class PresentVC: UIViewController {
    
//    func changeBackgroundColor() {
//        print("GoodStaf")
//
//    }
    

    let homeView = PresentVCCode()
    @Inject var fitMeetStream: FitMeetStream
    private var takeBroadcast: AnyCancellable?
    var listBroadcast: [BroadcastResponce] = []
    private let refreshControl = UIRefreshControl()
    var  playerContainerView: PlayerContainerView?
    lazy var slideInTransitioningDelegate = SlideInPresentationManager()
    var Url: String?

    override  var shouldAutorotate: Bool {
        return false
    }
    override  var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    //MARK - LifeCicle
    override func loadView() {
        view = homeView
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
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
        navigationItem.largeTitleDisplayMode = .always
        loadPlayer()
        let chatVC = ChatVC()
        slideInTransitioningDelegate.direction = .bottom
        slideInTransitioningDelegate.disableCompactHeight = true
        chatVC.transitioningDelegate = slideInTransitioningDelegate
        chatVC.modalPresentationStyle = .custom
      //  chatVC.delegate = self
        self.present(chatVC, animated: true, completion: nil)
       // makeNavItem()

    }
    func makeNavItem() {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
        let titleLabel = UILabel()
                   titleLabel.text = "Home"
                   titleLabel.textAlignment = .center
                   titleLabel.font = .preferredFont(forTextStyle: UIFont.TextStyle.headline)
                   titleLabel.font = UIFont.boldSystemFont(ofSize: 22)

                   let stackView = UIStackView(arrangedSubviews: [titleLabel])
                   stackView.distribution = .equalSpacing
                   stackView.alignment = .leading
                   stackView.axis = .vertical

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: #imageLiteral(resourceName: "Note"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction)),
                                                   UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(rightHandAction))]
    }
    func loadPlayer() {
        self.playerContainerView = Bundle.main.loadNibNamed("videoPlayerContainerNib", owner: self, options: nil)?.first as? PlayerContainerView
        self.playerContainerView?.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.view.addSubview(self.playerContainerView!)
        self.playerContainerView?.initializeView()
        self.playerContainerView?.link = Url
        self.playerContainerView?.minimizedOrigin = {
            let x = UIScreen.main.bounds.width/2
            let y = UIScreen.main.bounds.height - (UIScreen.main.bounds.width * 9 / 32)
            let coordinate = CGPoint.init(x: x, y: y)
            return coordinate
        }()
        self.playerContainerView?.initializeView()
    
    }
    @objc
    func rightHandAction() {
        print("right bar button action")
    }

    @objc
    func leftHandAction() {
        print("left bar button action")
    }
    //MARK: - Selectors
    @objc private func refreshAlbumList() {

       }
    func binding() {
        takeBroadcast = fitMeetStream.getBroadcast(status: "ONLINE")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.data != nil  {
                    self.listBroadcast = response.data!
                    self.refreshControl.endRefreshing()
                }
        })
    }
}

