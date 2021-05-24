
import UIKit

/** How To Implement:
 - In UIViewController that need to be presented customly - add snipet
 
 ```
 var customTransitionDelegate: NPSTransitionDelegate? {
     didSet {
         transitioningDelegate = customTransitionDelegate
     }
 }
 ```

And set to this property `CustomTransitionDelegate` instanse
 
 */

final class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var npsCase: CustomTransitionScreenCase {
        didSet {
            presentingController?.screenCase = npsCase
        }
    }
    private weak var presentingController: CustomPresentationController?

    init(npsCase: CustomTransitionScreenCase) {
        self.npsCase = npsCase
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(npsCase: npsCase,
                                         presentedViewController: presented,
                                         presenting: presenting)
            .applying { presentingController = $0 }
    }

    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlidePresentationAnimationController(isPresenting: false)
    }

    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return presentingController?.interactionController
    }
}
