
import UIKit

final class ResizableView: DraggableView {
    @IBInspectable private var minHeight: CGFloat = 28
    @IBInspectable private var minWidth: CGFloat = 28
    @IBInspectable private var draggerSideLenght: CGFloat = 24
    @IBInspectable private var maxSideLenghtModifier: CGFloat = 0.3
    private var maxSideLenght: CGFloat { window.map { min($0.bounds.width, $0.bounds.height) * maxSideLenghtModifier } ?? 0 }
    private weak var resizableView: UIView?
    private let draggerView = UIView()
    private lazy var resize = UIPanGestureRecognizer(target: self, action: #selector(resizeGesture(_:)))

    override func didMoveToWindow() {
        super.didMoveToWindow()
        setupDraggerView()
        fitMinMaxSize()
    }

    deinit {
        draggerView.removeFromSuperview()
    }

    func setupDraggerView() {
        draggerView.frame.size = .init(width: draggerSideLenght, height: draggerSideLenght)
        draggerView.layer.cornerRadius = draggerSideLenght / 2
        draggerView.backgroundColor = .purple//R.color.accent()
        draggerView.removeGestureRecognizer(resize)
        draggerView.addGestureRecognizer(resize)
        draggerView.removeFromSuperview()
        window?.addSubview(draggerView)

        draggerView.translatesAutoresizingMaskIntoConstraints = false
        draggerView.centerXAnchor.constraint(equalTo: trailingAnchor).isActive = true
        draggerView.centerYAnchor.constraint(equalTo: bottomAnchor).isActive = true
        draggerView.widthAnchor.constraint(equalTo: draggerView.heightAnchor).isActive = true
        draggerView.heightAnchor.constraint(equalToConstant: draggerSideLenght).isActive = true
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
    }

    func contain(_ view: UIView) {
        addSubview(view)
        self.resizableView?.removeFromSuperview()
        self.resizableView = view
        frame.size = view.frame.size
        widthAnchor.constraint(equalTo: heightAnchor, multiplier: frame.width / frame.height).isActive = true
    }

    @objc private func resizeGesture(_ resize: UIPanGestureRecognizer) {
        let movedPoint = resize.translation(in: self)
        resize.setTranslation(.zero, in: draggerView)
        frame.size.width += movedPoint.x
        frame.size.height += movedPoint.y
        fitMinMaxSize()
        superview.map {
            if shouldStayInBounds {
                var size = frame.size
                size.width -= max(frame.maxX - $0.frame.width, 0)
                size.height -= max(frame.maxY - $0.frame.height, 0)
                frame.size = size
            }
        }
    }

    private func fitMinMaxSize() {
        frame.size.width = min(max(frame.width, minWidth), maxSideLenght)
        frame.size.height = min(max(frame.height, minHeight), maxSideLenght)
    }
}
