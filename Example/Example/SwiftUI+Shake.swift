import SwiftUI

extension UIDevice {

    static let didShakeNotification = Notification.Name("ShakeEnded")

}

extension UIWindow {

    open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            NotificationCenter.default.post(name: UIDevice.didShakeNotification, object: nil)
        }
    }

}

struct ShakeViewModifier: ViewModifier {
    let onShake: () -> Void

    func body(content: Content) -> some View {
        content
            .onAppear()
            .onReceive(NotificationCenter.default.publisher(for: UIDevice.didShakeNotification)) { _ in
                onShake()
            }
    }
}

public extension View {
    func onShake(perform action: @escaping () -> Void) -> some View {
        self.modifier(ShakeViewModifier(onShake: action))
    }
}
