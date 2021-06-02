
protocol Applicable {}

extension Applicable {
    @discardableResult
    func applying(_ action: (Self) -> Void) -> Self {
        action(self)
        return self
    }
}

extension Collection where Element: Applicable {
    @discardableResult
    func applying(_ action: (Element) -> Void) -> Self {
        self.forEach { $0.applying(action) }
        return self
    }
}

extension NSObject: Applicable {}
