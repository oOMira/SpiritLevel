import SwiftUI

struct NoSearchHistoryCell: View {
    var body: some View {
        HStack {
            Image(systemName: "list.bullet")
                .font(.title2)
                .padding(.trailing)
            Text("No search history yet")
                .font(.title3)
                .frame(maxWidth: .infinity)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.top, 60)
        .padding(.horizontal)
    }
}
