import SwiftUI

struct DatePickerButton: View {
    let date: Date
    let onSelect: (Date) -> Void

    @State private var isPresented = false
    @State private var pickerDate: Date

    init(date: Date, onSelect: @escaping (Date) -> Void) {
        self.date = date
        self.onSelect = onSelect
        self._pickerDate = State(initialValue: date)
    }

    var body: some View {
        Button {
            pickerDate = date
            isPresented = true
        } label: {
            HStack {
                Text("Date")
                Text(date, format: .dateTime.day().month().year())
                    .foregroundStyle(.tint)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
        }
        .sheet(isPresented: $isPresented) {
            NavigationStack {
                DatePicker("Date",
                           selection: $pickerDate,
                           displayedComponents: [.date])
                    .navigationTitle("Date")
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button("Done") {
                                onSelect(pickerDate)
                                isPresented = false
                            }
                        }
                    }
            }
        }
    }
}
