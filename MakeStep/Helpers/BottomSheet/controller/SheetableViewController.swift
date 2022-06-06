//
//  SheetableViewController.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit
import Combine
import Loaf


class SheetableViewController: UIViewController, DownSheetViewControllerDelegate, RefreshList {
    
    
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    @Inject var fitMeetStreams: FitMeetStream
    var deleteBroad: AnyCancellable?
    var deleteAkk: AnyCancellable?
    var editBroad: AnyCancellable?
    
    lazy var moreArtworkOtherUserSheetVC = DownSheetViewController(items:[
        (ArtworkItemActionType.copyLink, .regular),
        (ArtworkItemActionType.share, .regular),
        (ArtworkItemActionType.sendComplaint, .regular),
    ]
    )
    
    lazy var moreArtworKMeUserSheetVC = DownSheetViewController(items: [
        (ArtworkItemActionType.share, .regular),
        (ArtworkItemActionType.copyLink, .regular),
        (ArtworkItemActionType.edit, .regular),
        (ArtworkItemActionType.delete, .regular),
    ]
    )
    
    lazy var blockUserSheetVC = DownSheetViewController(items:[
        (BlockUserActionType.block, .regular),
        (BlockUserActionType.notBlock, .regular),
    ], topTitle: ("Do you really want block the user?", UIColor(red: 165.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    )
    
    lazy var deleteItemSheetVC = DownSheetViewController(items:[
        (DeleteItemActionType.delete, .regular),
        (DeleteItemActionType.notDelete, .regular),
    ], topTitle: ("Do you really want to delete broadcast?", .black)
    )
    
    lazy var deleteAccountSheetVC = DownSheetViewController(items:[
        (DeleteAccountType.delete, .regular),
        (DeleteAccountType.notDelete, .regular),
    ], topTitle: ("Do you really want to delete your account?", .black)
    )
    
    lazy var linkCopiedSheetVC = DownSheetViewController(items:[
        (LinkCopiedActionType.copied, .regular)
    ], topTitle: ("Link copied", .black)
    )
    
    lazy var complaintSheetVC = DownSheetViewController(items:[
        (ArtworkSendComplaint.spam, .regular),
        (ArtworkSendComplaint.inappropriateContent, .regular),
        (ArtworkSendComplaint.other, .regular),
    ], topTitle: ("Send a complaint", .black)
    )
    
    lazy var complaintOtherSheetVC = DownSheetViewController(items:[
        (ArtworkSendOtherComplaint.nudity, .regular),
        (ArtworkSendOtherComplaint.hostileLanguage, .regular),
        (ArtworkSendOtherComplaint.violence, .regular),
        (ArtworkSendOtherComplaint.saleIllegal, .regular),
        (ArtworkSendOtherComplaint.bullyingOrStalking, .regular),
        (ArtworkSendOtherComplaint.violationRights, .regular),
        (ArtworkSendOtherComplaint.suicide, .regular),
        (ArtworkSendOtherComplaint.fraud, .regular),
        (ArtworkSendOtherComplaint.fake, .regular),
        (ArtworkSendOtherComplaint.dontLike, .regular),
    ]
    )
    
    lazy var complaintFinalSheetVC = DownSheetViewController(customView: ComplaintSuccessView(), customViewHeight: 160)
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for:.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.layoutIfNeeded()
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .white
            appearance.shadowImage = UIImage()
            appearance.shadowColor = .clear
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        }
        self.navigationController?.navigationBar.isHidden = false
        AppUtility.lockOrientation(.portrait)
        
    }
    
    func showDownSheet(_ controller: DownSheetViewController, payload: Int?) {
        controller.payload = payload
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        if let vc = view.getCurrentViewController() {
            vc.present(controller, animated: false)
        }
    }
    func showDownSheetAll(_ controller: DownSheetViewController, payload: Int?) {
        controller.payload = payload
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        if let vc = view.getCurrentViewController() {
            vc.present(controller, animated: false)
        }
    }
    func closeView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
            self.view.removeBlurA()
            self.visualEffectView.removeFromSuperview()
            }
        }
  
    func downSheetItemTappedWith(_ controller: DownSheetViewController, type: DownSheetActionType, payload: Int?) {
      

        if let type = type as? ArtworkItemActionType {
            if type == .sendComplaint {
                showDownSheet(complaintSheetVC, payload: payload)
            }
        }
        
        if let type = type as? ArtworkSendComplaint {
            if type == .other {
                showDownSheet(complaintOtherSheetVC, payload: payload)
                return
            }
            showFinalComplaintSheet()
        }
        
        if let _ = type as? ArtworkSendOtherComplaint {
            showFinalComplaintSheet()
            return
        }
        
        if let type = type as? ArtworkItemActionType {
            switch type {
            case .share:
                guard let id = payload else { return }
                shareBroadcast(id: id)
            case .copyLink:
                guard let id = payload else { return }
                copyLink(id: id)
            case .makePrivate: break
            case .delete:
                showDownSheet(deleteItemSheetVC, payload: payload)
                return
            case .edit:
                guard let id = payload else { return }
                showEditArtworkController(payload: id)
            case .sendComplaint: break
            case .block:
                showDownSheet(blockUserSheetVC, payload: payload)
                return
            }
        }
        
        if let type = type as? BlockUserSendComplaint {
            switch type {
            case .block:
                print("block")
            case .notBlock:
                break
            }
        }
        
        if let type = type as? DeleteItemActionType {
            switch type {
            case .delete:
                guard let id = payload else { return }
                deleteBroadcast(with: id)
            case .notDelete:
                break
            }
        }
        if let type = type as? DeleteAccountType {
            switch type {
            case .delete:
                deleteAccountSheet()
            case .notDelete:
                break
            }
        }
        
    }
    
    private func shareBroadcast(id: Int) {
        #if QA
            "https://dev.makestep.com/broadcastQA/\(id)".share()
        #elseif DEBUG
            "https://makestep.com/broadcast/\(id)".share()
        #endif
    }
    
    func copyLink(id: Int) {
       
    #if QA
        let urlShare = "https://dev.makestep.com/broadcastQA/\(id)"
    #elseif DEBUG
        let urlShare = "https://makestep.com/broadcast/\(id)"
    #endif
        Loaf("Copy Link :" + urlShare, state: Loaf.State.success, location: .bottom, sender:  self).show(.short){ disType in
                       switch disType {
                       case .tapped:
                           self.stopLoaf()
                       case .timedOut:
                           self.stopLoaf()
                       }
                     }
        UIPasteboard.general.string = urlShare
    }
    
    func deleteBroadcast(with id: Int) {
        deleteBroad = fitMeetStreams.deleteBroadcast(id: id)
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil  {
                    self.needUpdateAfterSuccessfullyCreate()
                    Loaf("Delete Broadcaast : " + response.name!, state: Loaf.State.success, location: .bottom, sender:  self).show(.short)
            }
        })
    }
    func stopLoaf() {
      
    }
    func deleteAccountSheet() {
        deleteAkk = fitMeetStreams.deleteAccont()
            .mapError({ (error) -> Error in
                Loaf("Error : \(error.localizedDescription)", state: Loaf.State.error, location: .bottom, sender:  self).show(.short)
                return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response {
                    self.needUpdateAfterSuccessfullyCreate()
                    Loaf("Delete Account", state: Loaf.State.success, location: .bottom, sender:  self).show(.short){ disType in
                        switch disType {
                        case .tapped:
                            self.stopLoaf()
                        case .timedOut:
                            self.stopLoaf()
                        }
                }
            }
        })
    }
    
    func blockUserById(with id: Int32) {
        
    }
    
    func showEditArtworkController(payload: Int) {
        editBroad = fitMeetStreams.getBroadcastId(id: "\(payload)")
            .mapError({ (error) -> Error in return error })
            .sink(receiveCompletion: { _ in }, receiveValue: { response in
                if response.id != nil  {
                    let vc = EditStreamVC()
                    vc.broadcast = response
                    vc.delegate = self
                    self.present(vc, animated: true, completion: nil)
            }
        })
    }
    func refrechList() {
        needUpdateAfterSuccessfullyCreate()
    }
    func showFinalComplaintSheet() {
        showDownSheet(complaintFinalSheetVC, payload: nil)
    }
    
    func needUpdateAfterSuccessfullyCreate() {
        guard let nc = self.navigationController else {return}
        for i in nc.viewControllers {
            if let r = i as? Refreshable {
                r.refresh()
            }
        }
    }
    func makeNavItem(title: String,hide: Bool) {
        let attributes = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 20)]
        UINavigationBar.appearance().titleTextAttributes = attributes
                    let titleLabel = UILabel()
                    titleLabel.text = title
                    titleLabel.textAlignment = .center
                    titleLabel.font = UIFont.boldSystemFont(ofSize: 22)
                    let backButton = UIButton()
                    backButton.setBackgroundImage(#imageLiteral(resourceName: "backButton"), for: .normal)
                    backButton.addTarget(self, action: #selector(rightBack), for: .touchUpInside)
                    backButton.isHidden = hide
                    let stackView = UIStackView(arrangedSubviews: [backButton,titleLabel])
                    stackView.distribution = .equalSpacing
                    stackView.alignment = .center
                    stackView.axis = .horizontal
                    let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(rightBack))
                    stackView.addGestureRecognizer(tap)

                   let customTitles = UIBarButtonItem.init(customView: stackView)
                   self.navigationItem.leftBarButtonItems = [customTitles]
       
        let startItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Search"), style: .plain, target: self, action:  #selector(searchAction))
        startItem.tintColor = UIColor(hexString: "#7C7C7C")
//        let timeTable = UIBarButtonItem(image: #imageLiteral(resourceName: "Time"),  style: .plain,target: self, action: #selector(timeHandAction))
//        timeTable.tintColor = UIColor(hexString: "#7C7C7C")
        
        
        self.navigationItem.rightBarButtonItems = [startItem]
    }
    @objc func timeHandAction() {
        print("timeHandAction")
        let tvc = Timetable()
        navigationController?.present(tvc, animated: true, completion: nil)
        
        
    }
    @objc func searchAction() {
        let searchvc = SearchVC()
        navigationController?.pushViewController(searchvc, animated: true)
        print("searchAction")
    }
    @objc func rightBack() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
