//
//  SearchFilter.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/26/24.
//

import SwiftUI
import Flow

struct SearchFilter: View {
    @Environment(PodcastEpisodeListViewModel.self) private var viewModel
    let maxFilterNum = 25

    var body: some View {
        HFlow(spacing: 10) {
            ForEach(Array(GenreFilter.allCases.enumerated()), id: \.element) { index, genre in
                Button {
                    if canSelectMoreFilters() {
                        viewModel.isFilterSelected[index].toggle()
                    } else {
                        //TODO: show alert "Up to 25 filters can be selected."
                    }
                } label: {
                    Text(genre.rawValue)
                        .fontWeight(viewModel.isFilterSelected[index] ? .semibold : .regular)
                        .tint(viewModel.isFilterSelected[index] ? Color(UIColor.systemBackground) : .darkAccent)
                }
                .padding(.vertical, 5)
                .padding(.horizontal, 10)
                .background {
                    if viewModel.isFilterSelected[index] {
                        Capsule()
                            .fill(genre.color)
                    } else {
                        Capsule()
                            .stroke()
                            .foregroundStyle(.darkAccent)
                    }
                }
            }
        }
    }
    
    func canSelectMoreFilters() -> Bool {
        return viewModel.isFilterSelected.filter { $0 }.count >= maxFilterNum
    }
}

#Preview {
    SearchFilter()
        .environment(PodcastEpisodeListViewModel())
}
