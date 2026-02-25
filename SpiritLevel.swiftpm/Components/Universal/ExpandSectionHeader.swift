import SwiftUI

struct ExpandableSectionHeader: View {
    let title: LocalizedStringKey
    @Binding var expanded: Bool
    
    var body: some View {
        Button(action: {
            withAnimation { expanded.toggle() }
        }, label: {
            HStack {
                Text(title)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: .chevronImage)
                    .font(.caption.weight(.semibold))
                    .rotationEffect(.degrees(expanded ? .expandedRotation : .collapsedRotation))
            }
        })
        .accessibilityValue(expanded ? "expanded" : "collapsed")
        .accessibilityHint("Double tap to toggle")
        .buttonStyle(.plain)
    }
}

// MARK: - Constants

private extension String {
    static let chevronImage = "chevron.down"
}
private extension Double {
    static let expandedRotation: Self = 0
    static let collapsedRotation: Self = -90
}

// MARK: - Preview

#Preview("Expanded - Light Mode") {
    @Previewable @State var expanded = true
    List {
        Section {
            Text("Content goes here")
        } header: {
            ExpandableSectionHeader(title: "Section Title", expanded: $expanded)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Collapsed - Light Mode") {
    @Previewable @State var expanded = false
    List {
        Section {
            Text("Content goes here")
        } header: {
            ExpandableSectionHeader(title: "Section Title", expanded: $expanded)
        }
    }
    .preferredColorScheme(.light)
}

#Preview("Expanded - Dark Mode") {
    @Previewable @State var expanded = true
    List {
        Section {
            Text("Content goes here")
        } header: {
            ExpandableSectionHeader(title: "Section Title", expanded: $expanded)
        }
    }
    .preferredColorScheme(.dark)
}

#Preview("Collapsed - Dark Mode") {
    @Previewable @State var expanded = false
    List {
        Section {
            Text("Content goes here")
        } header: {
            ExpandableSectionHeader(title: "Section Title", expanded: $expanded)
        }
    }
    .preferredColorScheme(.dark)
}

