//
//  PodcastDataService.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/19/24.
//

import Foundation
import Apollo

class PodcastDataService {
    func searchPodcastEpisodes(searchTerm: String, genres: [TaddyPodcast.Genre], page: Int, completion: @escaping (Result<[PodcastEpisode], Error>) -> Void) {
        NetworkManager.shared.apollo.fetch(query: TaddyPodcast.SearchPodcastEpisodesQuery(searchValue: searchTerm, genres: genres.map { GraphQLEnum($0) }, page: page)) { result in
            switch result {
            case .success(let graphQLResult):
                var episodes: [PodcastEpisode] = []

                if let errors = graphQLResult.errors {
                    let errorMessages = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessages])
                    completion(.failure(error))
                    return
                }

                if let fetchedEpisodes = graphQLResult.data?.searchForTerm?.podcastEpisodes {
                    for episode in fetchedEpisodes {
                        if let episodeId = episode?.uuid,
                           let episodeName = episode?.name,
                           let episodeAudioUrl = episode?.audioUrl,
                           let episodeDuration = episode?.duration,
                           let seriesId = episode?.podcastSeries?.uuid,
                           let seriesName = episode?.podcastSeries?.name {
                            if episodeDuration < 0 {
                                continue
                            }

                            episodes.append(
                                PodcastEpisode(
                                    id: episodeId,
                                    name: episodeName,
                                    description: episode?.description ?? "",
                                    audioUrl: episodeAudioUrl,
                                    subtitle: episode?.subtitle ?? "",
                                    datePublished: episode?.datePublished ?? 0,
                                    duration: episodeDuration,
                                    podcastSeries: PodcastSeries(
                                        id: seriesId,
                                        name: seriesName,
                                        description: episode?.podcastSeries?.description ?? "",
                                        imageUrl: episode?.podcastSeries?.imageUrl ?? ""))
                            )
                        }
                    }
                }
                completion(.success(episodes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func getPodcastSeries(id: String, completion: @escaping (Result<PodcastSeries, Error>) -> Void) {
        NetworkManager.shared.apollo.fetch(query: TaddyPodcast.GetPodcastSeriesQuery(uuid: id)) { result in
            switch result {
            case .success(let graphQLResult):
                if let errors = graphQLResult.errors {
                    let errorMessages = errors.map { $0.localizedDescription }.joined(separator: "\n")
                    let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMessages])
                    completion(.failure(error))
                    return
                }

                if let fetchedSeries = graphQLResult.data?.getPodcastSeries {
                    if let id = fetchedSeries.uuid,
                       let name = fetchedSeries.name {
                        let series = PodcastSeries(
                            id: id,
                            name: name,
                            description: fetchedSeries.description ?? "",
                            imageUrl: fetchedSeries.imageUrl ?? ""
                        )
                        completion(.success(series))
                        return
                    }
                }
                completion(.failure(NetworkingServiceError.decodingError))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

enum PodcastDataServiceConstants {
    static let maxSearchGenreNum = 25
    static let maxSearchPageNum = 20
}

enum NetworkingServiceError: Error {
    case decodingError
}
