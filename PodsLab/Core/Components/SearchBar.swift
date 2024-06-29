//
//  SearchBar.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/25/24.
//

import SwiftUI

struct SearchBar: View {
    @Environment(PodcastEpisodeListViewModel.self) private var viewModel
    @Binding var showSheet: Bool
    @FocusState private var textFieldIsFocused: Bool

    var body: some View {
        @Bindable var viewModel = viewModel
        HStack {
            Button {
                textFieldIsFocused = false
                showSheet = false
                viewModel.searchPodcastEpisodes()
            } label: {
                Image(systemName: "magnifyingglass")
                    .tint(.primary)
            }
            .disabled(viewModel.searchTerm.isEmpty)
            
            TextField("Search by word...", text: $viewModel.searchTerm)
                .focused($textFieldIsFocused)
                .foregroundStyle(.primary)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .padding()
                        .offset(x: 10)
                        .foregroundColor(.primary)
                        .opacity(viewModel.searchTerm.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.inputView?.endEditing(true)
                            viewModel.searchTerm = ""
                        }
                    , alignment: .trailing
                )
                .onSubmit {
                    textFieldIsFocused = false
                    if !viewModel.searchTerm.isEmpty {
                        showSheet = false
                        viewModel.searchPodcastEpisodes()
                    }
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color(UIColor.systemBackground).opacity(viewModel.searchTerm.isEmpty ? 0.5 : 0.7))
                .shadow(color: Color(UIColor.systemGray).opacity(0.3), radius: 5, x: 0, y: 0)
        )
    }
}

#Preview {
    SearchBar(showSheet: .constant(false))
        .environment(PodcastEpisodeListViewModel())
}
