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
    @State var hasReachedToMaxFilters: Bool = false

    var body: some View {
        VStack {
            HFlow(spacing: 10) {
                ForEach(Array(GenreFilter.allCases.enumerated()), id: \.element) { index, genre in
                    Button {
                        if viewModel.isFilterSelected[index] || canSelectMoreFilters() {
                            viewModel.isFilterSelected[index].toggle()
                            if canSelectMoreFilters() {
                                hasReachedToMaxFilters = false
                            }
                        } else {
                            hasReachedToMaxFilters = true
                        }
                    } label: {
                        Text(genre.rawValue)
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
            
            if hasReachedToMaxFilters {
                Text("Reached to max number of filters ⚠️")
                    .font(.callout)
                    .foregroundStyle(.red)
                    .padding(.top, 5)
            }
        }
    }
    
    func canSelectMoreFilters() -> Bool {
        return countSelectedTaddyFilters() < PodcastDataServiceConstants.maxSearchGenreNum
    }
    
    func countSelectedTaddyFilters() -> Int {
        var count: Int = 0
        for (index, genre) in GenreFilter.allCases.enumerated() {
            if viewModel.isFilterSelected[index] {
                count += genre.getTaddyGenres().count
            }
        }
        return count
    }
}

#Preview {
    SearchFilter()
        .environment(PodcastEpisodeListViewModel())
}
