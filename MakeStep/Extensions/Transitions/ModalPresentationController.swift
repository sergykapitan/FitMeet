import UIKit
//import Cartography

class ModalPresentationController: UIPresentationController {

    lazy var fadeView: UIView = .make(backgroundColor: UIColor.black.withAlphaComponent(0.3), alpha: 0.0,cornerRadius: 30)
    private let tapGestureRecognizer = UITapGestureRecognizer()
    private let panGestureRecognizer = UIPanGestureRecognizer()
    
    // MARK: Initialization
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        configureGestureRecognizers()
    }
    
    
    override func presentationTransitionWillBegin() {
        super.presentationTransitionWillBegin()
       
        configureGestureRecognizers()
        presentedView?.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        presentedView?.layer.cornerRadius = 30
    
    }

    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            fadeView.alpha = 0.0
            return
        }

        if !coordinator.isInteractive {
            coordinator.animate(alongsideTransition: { _ in
                self.fadeView.alpha = 0.0
            })
        }
    }

    override func containerViewWillLayoutSubviews() {
        presentedView?.frame = frameOfPresentedViewInContainerView
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView, let presentedView = presentedView else { return .zero }
        let safeAreaFrame = containerView.bounds.inset(by: containerView.safeAreaInsets)

        let targetWidth = safeAreaFrame.width - 2
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        
        let targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height
        let height =  presentedView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
        let originY: CGFloat = containerView.bounds.height - targetHeight
        var frame = safeAreaFrame
        frame.origin.x = 0
        frame.origin.y = originY
        frame.size.width = targetWidth
        frame.size.height = height

        return frame
    }
}

private extension ModalPresentationController {
    func configureGestureRecognizers() {
        tapGestureRecognizer.addTarget(self, action: #selector(handleTap))
        containerView?.addGestureRecognizer(tapGestureRecognizer)
        
        panGestureRecognizer.addTarget(self, action: #selector(handlePan))
        containerView?.addGestureRecognizer(panGestureRecognizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        presentedViewController.dismiss(animated: true)
    }
    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .changed:
            guard
                let presentedView = presentedView
            else {
                return
            }
            
            let translationY = sender.translation(in: presentedView).y
            let originY = frameOfPresentedViewInContainerView.minY
            let updatedOriginY = originY + translationY
            
            // Update position
            presentedView.frame.origin.y = max(updatedOriginY, originY)
            
            // Update alpha
           
            
            // Workaround for inconsistent view layout during transition.
            // Adjusting safe area because safe area disappears when frame is changed.
            presentedViewController.additionalSafeAreaInsets.bottom = updatedOriginY > originY ?
                containerView?.safeAreaInsets.bottom ?? 0 :
                0.0
        case .ended:
            guard let presentedView = presentedView else {
                return
            }
            
            let velocityY = sender.velocity(in: presentedView).y
            let originY = frameOfPresentedViewInContainerView.minY
            let viewHeight = presentedView.frame.height
            
            // Dismiss only if the gesture is in the correct direction
            let directionCheck = velocityY > 0
            
            // Dismiss only if more than 40% of modal is hidden or there is a significant velocity
            let distanceCheck = presentedView.frame.origin.y > originY + (viewHeight * 0.4)
            let velocityCheck = velocityY > 500
            
            if directionCheck, distanceCheck || velocityCheck {
                presentedViewController.dismiss(animated: true)
            } else {
                UIView.animate(withDuration: 0.25, delay: 0, options: .curveEaseOut) {
                    self.presentedView?.frame.origin.y = originY
                    self.presentedViewController.additionalSafeAreaInsets.bottom = 0
                }
            }
        default:
            break
        }
    }
}
