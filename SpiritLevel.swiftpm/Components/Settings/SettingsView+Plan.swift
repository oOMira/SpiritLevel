import SwiftUI

extension SettingsView {
    struct TreatmentPlanCellView: View {
        var body: some View {
            HStack {
                Image(systemName: "list.bullet.rectangle.portrait")
                    .font(.title2)
                    .padding(.horizontal, 4)
                VStack {
                    Text("Treatment Plan")
                        .font(.title3)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Text("5mg every 10 days")
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .font(.footnote)
                }
            }
        }
    }
    
}
