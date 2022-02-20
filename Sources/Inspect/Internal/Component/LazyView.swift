import SwiftUI

struct LazyView<Content: View>: View {

    private let content: () -> Content

    var body: Content {
        content()
    }

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

}
