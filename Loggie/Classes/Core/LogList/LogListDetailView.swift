//
//  LogListDetailView.swift
//  Loggie
//
//  Created by Damjan Dimovski on 29.11.22.
//

import SwiftUI

@available(iOS 13.0, *)
struct LogListDetailView: View {
    
    let log: Log
    
    @State private var segment: Int = 0
    @State private var sharePresented: Bool = false
    
    private var sections: [LogDetailsSection] {
        switch segment {
        case 0:
            return log.overviewDataSource
        case 1:
            return log.requestDataSource
        default:
            return log.responseDataSource
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Picker("", selection:$segment) {
                Text("Overview").tag(0)
                Text("Request").tag(1)
                Text("Response").tag(2)
            }
            .pickerStyle(.segmented)
            .fixedSize()
            
            List(sections, id: \.self) { section in
                Section {
                    ForEach(section.items, id: \.self) { item in
                        switch item {
                        case .text(let text):
                            if let text = text {
                                Text(text)
                                    .font(.system(size: 14, weight: .bold, design: .monospaced))
                            }
                        case .subtitle(let title, let subtitle):
                            HStack(alignment: .top) {
                                if let title = title {
                                    Text(title)
                                        .bold()
                                }
                                
                                if let subtitle = subtitle {
                                    Text(subtitle)
                                }
                            }
                            .font(.system(size: 13))
                        case .image(let image):
                            if let image = image {
                                Image(uiImage: image)
                            }
                        }
                    }
                } header: {
                    if let title = section.headerTitle {
                        Text(title)
                    } else {
                        Spacer(minLength: 0)
                    }
                } footer: {
                    if let title = section.footerTitle {
                        Text(title)
                    } else {
                        Spacer(minLength: 0)
                    }
                }
            }
        }
        .padding(.top)
        .background(Color(.systemGray6))
        .navigationBarTitle(Text("\(log.request.httpMethod ?? "") \(log.request.url?.path ?? "")"), displayMode: .inline)
        .navigationBarItems(trailing: Button { sharePresented = true } label: {
            Image(systemName: "square.and.arrow.up")
        })
        .sheet(isPresented: $sharePresented) {
            ShareSheetView(activityItems: [log.shareRepresentation])
        }
    }
}

@available(iOS 13.0, *)
struct ShareSheetView: UIViewControllerRepresentable {
    typealias Callback = (_ activityType: UIActivity.ActivityType?, _ completed: Bool, _ returnedItems: [Any]?, _ error: Error?) -> Void
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    let excludedActivityTypes: [UIActivity.ActivityType]? = nil
    let callback: Callback? = nil
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities)
        controller.excludedActivityTypes = excludedActivityTypes
        controller.completionWithItemsHandler = callback
        return controller
    }
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // nothing to do here
    }
}

@available(iOS 13.0, *)
struct LogListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            LogListDetailView(log: Log(request: URLRequest(url: URL(string: "https://api.publicapis.org/entries")!)))
        }
    }
}
