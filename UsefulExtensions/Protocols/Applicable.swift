
protocol Applicable {}

extension Applicable {
    @discardableResult
    func applying(_ action: (Self) -> Void) -> Self {
        action(self)
        return self
    }
}

extension NSObject: Applicable {}
