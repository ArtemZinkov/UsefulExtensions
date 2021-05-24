
import UIKit

/** How To Implement:
 See `CustomTransitionDelegate` How To Implement block
 */
final class CustomPresentationController: UIPresentationController {
    var screenCase: CustomTransitionScreenCase
    private(set) var interactionController: UIPercentDrivenInteractiveTransition?
    private var shouldCompleteTransition = true
    private var keyboardHeight: CGFloat = 0
    private var panStart: CGFloat?

    private var gestures: [UIGestureRecognizer] = []

    private let dimmingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.alpha = 0
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return view
    }()

    init(npsCase: CustomTransitionScreenCase,
         presentedViewController: UIViewController,
         presenting presentingViewController: UIViewController?) {
        self.screenCase = npsCase
        super.init(presentedViewController: presentedViewController,
                   presenting: presentingViewController)
        self.setupKeyboardObservers()
    }

    override func presentationTransitionWillBegin() {
        setupDimmingView()
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }

    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }

    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView else {
            return .zero
        }
        let size = self.size(forChildContentContainer: presentedViewController,
                             withParentContainerSize: containerView.frame.size)
        let origin = CGPoint(x: 0,
                             y: containerView.frame.height - size.height)
        return CGRect(origin: origin,
                      size: size)
    }

    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView.map { view in
            view.frame = self.frameOfPresentedViewInContainerView
            view.layer.masksToBounds = true
            view.layer.cornerRadius = 10
        }
    }

    override func size(forChildContentContainer container: UIContentContainer,
                       withParentContainerSize parentSize: CGSize) -> CGSize {
        return CGSize(width: parentSize.width,
                      height: screenCase.height + keyboardHeight)
    }
}

private extension CustomPresentationController {
    func setupKeyboardObservers() {
        func addObserver(selector: Selector, name: NSNotification.Name?) {
            NotificationCenter.default.addObserver(self,
                                                   selector: selector,
                                                   name: name,
                                                   object: nil)
        }
        addObserver(selector: #selector(update),
                    name: UIResponder.keyboardWillShowNotification)
        addObserver(selector: #selector(update),
                    name: UIResponder.keyboardWillHideNotification)
        addObserver(selector: #selector(update),
                    name: UIResponder.keyboardWillChangeFrameNotification)
    }

    func setupDimmingView() {
        dimmingView.removeFromSuperview()
        containerView?.insertSubview(dimmingView, at: 0)
        dimmingView.snapToSuperview()
        gestures.forEach { $0.view?.removeGestureRecognizer($0) }

        UITapGestureRecognizer(target: self, action: #selector(handleDimmingTap))
            .applying(dimmingView.addGestureRecognizer)
            .applying { gestures.append($0) }

        guard let containerView = containerView else { return }
        UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            .applying(containerView.addGestureRecognizer)
            .applying { gestures.append($0) }
    }

    @objc func handleDimmingTap() {
        presentingViewController.dismiss(animated: true)
    }

    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: containerView)

        switch recognizer.state {
        case .began:
            panStart = location.y
            interactionController = UIPercentDrivenInteractiveTransition()
            presentedViewController.dismiss(animated: true)
        case .changed:
            let height = screenCase.height + keyboardHeight
            let screenHeight = UIScreen.main.bounds.height
            let startPosition = max((panStart ?? 0), screenHeight - height)
            let delta = location.y - startPosition

            let progress = (delta / height).clamped(in: 0...1)

            shouldCompleteTransition = progress > 0.5
            interactionController?.update(progress)
        case .cancelled:
            panStart = nil
            interactionController?.cancel()
            interactionController = nil
        case .ended:
            panStart = nil
            if shouldCompleteTransition {
                interactionController?.finish()
            } else {
                interactionController?.cancel()
            }
            interactionController = nil
        default:
            break
        }
    }

    @objc func update(from notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = UIScreen.main.bounds.maxY - keyboardRectangle.minY
        }
    }
}
