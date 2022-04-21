//
//  SheetableViewController.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit
import Combine
import Loaf


class SheetableViewController: UIViewController, DownSheetViewControllerDelegate {
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    @Inject var fitMeetStreams: FitMeetStream
    var deleteBroad: AnyCancellable?
    
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
        (ArtworkItemActionType.delete, .destructive),
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
    ], topTitle: ("Do you really want to delete broadcast?", UIColor(red: 165.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
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
            case .edit: showEditArtworkController(payload: payload)
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
        
    }
    
    private func shareBroadcast(id: Int) {
        #if QA
            "https://dev.makestep.com/broadcastQA/\(id)".share()
        #elseif DEBUG
            "https://makestep.com/broadcast/\(id)".share()
        #endif
    }
    
    private func copyLink(id: Int) {
       
    #if QA
        let urlShare = "https://dev.makestep.com/broadcastQA/\(id)"
    #elseif DEBUG
        let urlShare = "https://makestep.com/broadcast/\(id)"
    #endif
        Loaf("Copy Link :" + urlShare, state: Loaf.State.success, location: .bottom, sender:  self).show(.short)
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
    
    func blockUserById(with id: Int32) {
        
    }
    
    func showEditArtworkController(payload: Int?) {
        print("showEditArtworkController")
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
    
}
