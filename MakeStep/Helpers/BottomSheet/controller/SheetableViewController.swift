//
//  SheetableViewController.swift
//  MakeStep
//
//  Created by Sergey on 07.04.2022.
//

import UIKit


class SheetableViewController: UIViewController, DownSheetViewControllerDelegate {
    
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
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
    ], topTitle: ("Do you really want to delete item", UIColor(red: 165.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0))
    )
    
    lazy var linkCopiedSheetVC = DownSheetViewController(items:[
//        (LinkCopiedActionType.copied, .regular)
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
   
          //  self.view.addBlur()
         //   self.addBlurEffect()
        controller.payload = payload
        controller.modalPresentationStyle = .overCurrentContext
        controller.delegate = self
        if let vc = view.getCurrentViewController() {
            vc.present(controller, animated: false)
        }
    }
    func showDownSheetAll(_ controller: DownSheetViewController, payload: Int?) {
   
       // self.addBlurEffect()
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
    func addBlurEffect() {
        let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
        let bounds = self.navigationController?.navigationBar.bounds.insetBy(dx: 0, dy: -(statusBarHeight)).offsetBy(dx: 0, dy: -(statusBarHeight))
        visualEffectView.frame = bounds ?? CGRect.zero
        visualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        visualEffectView.backgroundColor = .black
        visualEffectView.alpha = 0.2
        self.navigationController?.navigationBar.addSubview(visualEffectView)
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
                shareAtrwork(id: id)
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
                print("delete")
            case .notDelete:
                break
            }
        }
        
    }
    
    private func shareAtrwork(id: Int) {
        #if QA
            "https://makestep.com/broadcastQA/\(id)".share()
        #elseif DEBUG
            "https://makestep.com/broadcast/\(id)".share()
        #endif
    }
    
    private func copyLink(id: Int) {
        let urlShare = "https://makestep.com/broadcast/\(id)"
        UIPasteboard.general.string = urlShare
    }
    
    func deleteArtwork(with id: Int32) {
        
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
            print("refrech")
        }
    }
    
}
