import SwiftUI

struct SettingsView: View {
    @State var isSyncing: Bool = false
    @State private var isPlanPresented: Bool = false
    @Namespace private var planNamespace
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        Button {
                            withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                                isPlanPresented = true
                            }
                        } label: {
                            PlanCellView(namespace: planNamespace)
                        }
                        .buttonStyle(.plain)
                    }
                    Section("Support") {
                        Link(destination: URL(string: "https://github.com")!) {
                            HStack {
                                Text("GitHub")
                                Spacer()
                                Image(systemName: "doc.badge.arrow.up")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Link(destination: URL(string: "https://google.com")!) {
                            HStack {
                                Text("Data")
                                Spacer()
                                Image(systemName: "doc.badge.arrow.up")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Link(destination: URL(string: "https://github.com/tiliaqt/transkit")!) {
                            HStack {
                                Text("Inspiration")
                                Spacer()
                                Image(systemName: "doc.badge.arrow.up")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        Link(destination: URL(string: "mailto:feedback@example.com")!) {
                            HStack {
                                Text("Feedback")
                                Spacer()
                                Image(systemName: "doc.badge.arrow.up")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    Section("Data Managment") {
                        HStack {
                            Text("Sync")
                            Toggle("Sync", isOn: $isSyncing)
                        }
                        HStack {
                            Text("Import")
                            Spacer()
                            Button {
                                print("import")
                            } label: {
                                Image(systemName: "square.and.arrow.down")
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                        }
                        HStack {
                            Text("Export")
                            Spacer()
                            Button {
                                print("export")
                            } label: {
                                Image(systemName: "square.and.arrow.up")
                                    .font(.title2)
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Section {
                        Button {
                            print("delete")
                        } label: {
                            Text("Delete Data")
                                .font(.title3)
                                .fontWeight(.bold)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
                .navigationTitle("Settings")
                
                if isPlanPresented {
                    PlanDetailView(isPresented: $isPlanPresented, namespace: planNamespace)
                        .zIndex(1)
                }
            }
        }
    }
}

private struct PlanCellView: View {
    let namespace: Namespace.ID
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text("Current Plan")
                    .font(.headline)
                Text("Free")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .matchedGeometryEffect(id: "planCard", in: namespace)
    }
}

private struct PlanDetailView: View {
    @Binding var isPresented: Bool
    let namespace: Namespace.ID
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                        isPresented = false
                    }
                }
            
            VStack(spacing: 16) {
                HStack {
                    Text("Current Plan")
                        .font(.title2)
                        .fontWeight(.semibold)
                    Spacer()
                    Button {
                        withAnimation(.spring(response: 0.45, dampingFraction: 0.85)) {
                            isPresented = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Text("You are on the Free plan.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                
                Button("Manage Plan") {
                    print("manage plan")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .matchedGeometryEffect(id: "planCard", in: namespace)
            .padding(24)
        }
    }
}

#Preview {
    SettingsView()
}

