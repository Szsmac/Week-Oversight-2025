import SwiftUI

struct ClientGroupDetailView: View {
    let group: ClientGroup
    @EnvironmentObject private var clientManager: ClientManager
    @EnvironmentObject private var navigationManager: NavigationManager
    @State private var selectedOversight: WeekOversight?
    @State private var isLoading = false
    
    var body: some View {
        Group {
            if isLoading {
                LoadingView(message: "Loading oversights...")
            } else {
                content
            }
        }
        .toolbar {
            ToolbarItem {
                Menu {
                    Button("New Week Oversight") {
                        withAnimation(AppAnimation.standard) {
                            navigationManager.showSheet(.createClientOversight(group))
                        }
                    }
                    
                    Button("Import Excel") {
                        withAnimation(AppAnimation.standard) {
                            navigationManager.showSheet(.importExcel)
                        }
                    }
                    
                    Divider()
                    
                    Button("Delete Group", role: .destructive) {
                        withAnimation(AppAnimation.standard) {
                            navigationManager.showSheet(.deleteClientGroup(group))
                        }
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .navigationTitle(group.name)
    }
    
    private var content: some View {
        List {
            Section {
                ForEach(group.weekOversights) { oversight in
                    WeekOversightRow(oversight: oversight)
                        .contentTransition(.symbolEffect(.automatic))
                        .onTapGesture {
                            withAnimation(AppAnimation.standard) {
                                navigationManager.navigate(to: .weekOversight(oversight))
                            }
                        }
                }
            } header: {
                SectionHeader(
                    title: "Week Oversights",
                    systemImage: "calendar",
                    action: {
                        withAnimation(AppAnimation.standard) {
                            navigationManager.showSheet(.createClientOversight(group))
                        }
                    }
                )
            }
        }
        .animation(AppAnimation.standard, value: group.weekOversights)
    }
}

#Preview {
    NavigationStack {
        ClientGroupDetailView(group: ClientGroup(name: "Test Group"))
            .withPreviewEnvironment()
    }
} 