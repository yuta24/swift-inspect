import SwiftUI

private struct ActivityWrapper: UIViewControllerRepresentable {

    let activityItems: [Any]
    let applicationActivities: [UIActivity]?

    func makeUIViewController(context: Context) -> some UIViewController {
        return UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

}

struct Activity: View {

    let activityItems: [Any]

    var body: some View {
        ActivityWrapper(activityItems: activityItems, applicationActivities: nil)
    }

}
