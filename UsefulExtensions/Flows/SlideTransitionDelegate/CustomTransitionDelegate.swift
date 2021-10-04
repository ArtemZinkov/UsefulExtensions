
import UIKit

/** How To Implement:
 - In UIViewController that need to be presented customly - add snipet
 
 ```
 var customTransitionDelegate: CustomTransitionScreenCase? {
     didSet {
         transitioningDelegate = customTransitionDelegate
     }
 }
 ```

And set to this property `CustomTransitionDelegate` instance
 
 */

final class CustomTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var screenCase: CustomTransitionScreenCase {
        didSet {
            presentingController?.screenCase = screenCase
        }
    }
    private weak var presentingController: CustomPresentationController?

    init(npsCase: CustomTransitionScreenCase) {
        self.screenCase = npsCase
        super.init()
    }

    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(npsCase: screenCase,
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
