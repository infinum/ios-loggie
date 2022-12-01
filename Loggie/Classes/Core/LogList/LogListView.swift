//
//  LogListView.swift
//  Loggie
//
//  Created by Damjan Dimovski on 29.11.22.
//

// TODO: Cleanup code 🧹
// TODO: Make different entry points for iOS 13+ & macOS (SwiftUI) and lower iOS versions (UIKit) 💻📱
// On iOS <13 import and use old UIKit classes for UI
// On iOS 13+ and macOS use the SwiftUI files for UI

import SwiftUI

@available(iOS 13.0, *)
struct LogListItemView: View {
    
    @State var log: Log
    private static let greenColor = Color(red: 55.0/255.0, green: 188.0/255.0, blue: 155.0/255.0)
    private static let redColor = Color(red: 218.0/255.0, green: 68.0/255.0, blue: 83.0/255.0)
    
    var body: some View {
        HStack(spacing: 13) {
            Text("\(log.response?.statusCode ?? 0)")
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(
                    Array(200..<300)
                        .contains(log.response?.statusCode ?? 0) ? LogListItemView.greenColor : LogListItemView.redColor
                )
            
            VStack(alignment: .leading, spacing: 3) {
                HStack(spacing: 8) {
                    Text(log.request.httpMethod ?? "")
                        .font(.system(size: 17, weight: .medium))
                    Text(log.request.url?.path ?? "")
                        .font(.system(size: 15))
                }
                .foregroundColor(.black)
                
                Text(log.request.url?.host ?? "")
                    .font(.system(size: 13))
                
                HStack {
                    Text(DateFormatter.localizedString(from: log.startTime ?? Date(), dateStyle: .none, timeStyle: .medium))
                    Spacer()
                    Text(log.durationString ?? "")
                }
                .font(.system(size: 13, weight: .bold))
            }
            .foregroundColor(.gray)
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
    }
}

@available(iOS 13.0, *)
public struct LogListView: View {
    
    @State var logs: [Log]
    @State private var searchText = ""
    
    public init(logs: [Log], filter: ((Log) -> Bool)? = nil) {
        self.logs = logs.filter(filter ?? { _ in true })
    }
    
    public var body: some View {
        NavigationView {
            ZStack {
                VStack(spacing: 0) {
                    SearchBar(text: $searchText)
                        .background(Color(.systemGray6))
                    
                    List {
                        Section(header: Spacer(minLength: 0)) {
                            ForEach(logs.filter({ searchText.isEmpty ? true : $0.searchKeywords.contains(where: {
                                $0.range(of: searchText, options: .caseInsensitive) != nil
                            }) }), id: \.self) { log in
                                LogListItemView(log: log)
                                    .listRowInsets(EdgeInsets())
                                    .background(NavigationLink("", destination: LogListDetailView(log: log)).opacity(0))
                            }
                        }
                    }
                }
                .navigationBarTitle(Text("Logs"), displayMode: .inline)
            }
            .padding(.top)
            .background(Color(.systemGray6))
        }
    }
}

@available(iOS 13.0, *)
struct LogListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        ZStack {
            Rectangle()
                .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: .constant(true)) {
            LogListView(logs: [
                Log(request: URLRequest(url: URL(string: "https://google.com/images")!)),
                Log(request: URLRequest(url: URL(string: "https://api.publicapis.org/entries")!))
            ])
        }
    }
}

@available(iOS 13.0, *)
struct SearchBar: View {
    @Binding var text: String
    
    @State private var isEditing = false
    
    var body: some View {
        HStack {
            TextField("Filter logs", text: $text)
                .padding(8)
                .padding(.horizontal, 24)
                .background(Color(.systemGray5))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                        
                        if isEditing {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 20)
                .onTapGesture {
                    self.isEditing = true
                }
            
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    // Dismiss the keyboard
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
    }
}

