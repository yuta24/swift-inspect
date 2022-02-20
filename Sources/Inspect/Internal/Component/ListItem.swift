import SwiftUI

struct ListItem: View {

    enum Style {

        case subtitle(text: String, detail: String)
        case value1(text: String, detail: String)

    }

    let style: Style

    var body: some View {
        switch style {
        case .subtitle(let text, let detail):
            VStack(alignment: .leading) {
                Text(text)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.headline)

                Spacer()

                Text(detail)
                    .foregroundColor(Color(UIColor.label))
                    .font(.body)
            }
        case .value1(let text, let detail):
            VStack(alignment: .leading) {
                Text(text)
                    .foregroundColor(Color(UIColor.secondaryLabel))
                    .font(.headline)

                Spacer()

                Text(detail)
                    .foregroundColor(Color(UIColor.label))
                    .font(.body)
            }
        }
    }

    init(style: Style) {
        self.style = style
    }

    static func subtitle(text: String, detail: String) -> Self {
        return .init(style: .subtitle(text: text, detail: detail))
    }

    static func value1(text: String, detail: String) -> Self {
        return .init(style: .value1(text: text, detail: detail))
    }

}
