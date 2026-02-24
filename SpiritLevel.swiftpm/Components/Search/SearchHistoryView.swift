import SwiftUI

struct SearchHistoryView: View {
    var searchHistory: [String]
    let clearHistory: () -> Void
    
    var body: some View {
        HStack {
            Text("Recent Searches")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)
            Button(action: {
                withAnimation {
                    clearHistory()
                }
            }, label: {
                Text("Clear history")
                    .font(.footnote.bold())
                    .foregroundStyle(.red)
            })
        }
        .listRowSeparator(.hidden)
        ForEach(searchHistory.enumerated(), id: \.offset) { _, query in
            Text(query)
                .listRowBackground(Color.clear)
        }
        .onTapGesture { }
    }
}
