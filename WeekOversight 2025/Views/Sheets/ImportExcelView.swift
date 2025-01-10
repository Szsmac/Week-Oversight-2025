import SwiftUI
import UniformTypeIdentifiers

struct ImportExcelView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var errorHandler: ErrorHandler
    @ObservedObject var viewModel: ClientGroupViewModel
    
    @State private var isLoading = false
    @State private var isShowingPicker = false
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Import Excel")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Select an Excel file to import truck data")
                .foregroundStyle(.secondary)
            
            Button {
                isShowingPicker = true
            } label: {
                Label("Choose File", systemImage: "doc.badge.plus")
            }
            .buttonStyle(.bordered)
            .disabled(isLoading)
        }
        .padding()
        .frame(width: 300)
        .fileImporter(
            isPresented: $isShowingPicker,
            allowedContentTypes: [.xlsx, .xlsm],
            allowsMultipleSelection: false
        ) { result in
            Task {
                await handleFileSelection(result)
            }
        }
        .overlay {
            if isLoading {
                LoadingView()
            }
        }
    }
    
    private func handleFileSelection(_ result: Result<[URL], Error>) async {
        isLoading = true
        defer { isLoading = false }
        
        do {
            guard let url = try result.get().first else { return }
            try await viewModel.importExcel(from: url)
            dismiss()
        } catch {
            errorHandler.handle(error)
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let group = PreviewData.createPreviewClientGroup(in: context)
    let viewModel = ClientGroupViewModel(context: context, clientGroup: group)
    return ImportExcelView(viewModel: viewModel)
        .withPreviewEnvironment()
}