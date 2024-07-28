//
//  PodcastEpisodeListViewModel.swift
//  PodsLab
//
//  Created by Miho Shimizu on 5/22/24.
//

import Foundation
import Combine
import SwiftUI

@Observable class PodcastEpisodeListViewModel {
    var podcastEpisodes: [PodcastEpisode] = MockData.mockPodcastEpisodes//[]
    var errorMessage: String? = nil

    var selectedPodcastEpisode: PodcastEpisode?
    var showBigAudioPlayer: Bool = false
    
    var searchTerm: String = ""
    var isFilterSelected: [Bool] = Array(repeating: false, count: GenreFilter.allCases.count)
    
    private let podcastDataService = PodcastDataService()
    private var cancellables = Set<AnyCancellable>()
    
    func resetEpisodeList() {
        podcastEpisodes.removeAll()
    }

    func searchPodcastEpisodes(page: Int = 1) {
        var filteredGenres: [TaddyPodcast.Genre] = []
        
        for (index, genre) in GenreFilter.allCases.enumerated() {
            if isFilterSelected[index] {
                filteredGenres.append(contentsOf: genre.getTaddyGenres())
            }
        }
        
        podcastDataService.searchPodcastEpisodes(searchTerm: searchTerm, genres: filteredGenres, page: page) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let episodes):
                    self?.podcastEpisodes.append(contentsOf: episodes)
                case .failure(let error):
                    print(error.localizedDescription)
                    self?.errorMessage = error.localizedDescription
                }
            }
        }
    }
    
    func playSelectedEpisode() {
        do {
            try AudioManager.shared.play(url: selectedPodcastEpisode!.audioUrl, seekTo: isSelectedEpisodeEnded() ? 0.0 : selectedPodcastEpisode?.playbackProgress ?? 0.0)
            startPlaybackProgressMonitor()
            if let episode = selectedPodcastEpisode {
                episode.playbackStatus = .play
            }

        } catch {
            print("Failed playing the audio url")
        }
    }
    
    func pauseSelectedEpisode() {
        AudioManager.shared.pause()
        stopPlaybackProgressMonitor()
        if let episode = selectedPodcastEpisode {
            episode.playbackStatus = .pause
        }
    }
    
    func isSelectedEpisodeEnded() -> Bool {
        guard let episode = selectedPodcastEpisode else {
            return true
        }
        return Int(episode.playbackProgress) >= episode.duration
    }
    
    func startPlaybackProgressMonitor() {
        AudioManager.shared.addPeriodicTimeObserver() { [weak self] progress in
            guard let self else { return }
            if let episode = selectedPodcastEpisode {
                episode.playbackProgress = progress
                episode.playbackProgressRatio = CGFloat(progress / Double(episode.duration))
                if isSelectedEpisodeEnded() {
                    stopPlaybackProgressMonitor()
                    episode.playbackStatus = .stop
                }
            }
        }
    }
    
    func stopPlaybackProgressMonitor() {
        AudioManager.shared.removePeriodicTimeObserver()
    }
}

enum GenreFilter: String, CaseIterable {
    case podcastseriesArts = "Arts"
    case podcastseriesBusiness = "Business"
    case podcastseriesComedy = "Comedy"
    case podcastseriesEducation = "Education"
    case podcastseriesFiction = "Fiction"
    case podcastseriesGovernment = "Government"
    case podcastseriesHistory = "History"
    case podcastseriesHealthAndFitness = "Health and Fitness"
    case podcastseriesKidsAndFamily = "Kids and Family"
    case podcastseriesKidsAndFamilyPetsAndAnimals = "Pets and Animals"
    case podcastseriesLeisureAnimationAndManga = "Animation and Manga"
    case podcastseriesLeisureAutomotive = "Automotive"
    case podcastseriesLeisureAviation = "Aviation"
    case podcastseriesLeisureCrafts = "Crafts"
    case podcastseriesLeisureGames = "Games"
    case podcastseriesLeisureHomeAndGarden = "Home and Garden"
    case podcastseriesMusic = "Music"
    case podcastseriesNews = "News"
    case podcastseriesReligionAndSpirituality = "Religion and Spirituality"
    case podcastseriesScience = "Science"
    case podcastseriesSocietyAndCulture = "Society and Culture"
    case podcastseriesSports = "Sports"
    case podcastseriesTechnology = "Technology"
    case podcastseriesTrueCrime = "True Crime"
    case podcastseriesTvAndFilm = "TV and Film"
    case comicseriesAction = "Comics"
    
    var color: Color {
        switch self {
        case .podcastseriesArts:
            return Color(hex: "#E57373")!
        case .podcastseriesBusiness:
            return Color(hex: "#FF7043")!
        case .podcastseriesComedy:
            return Color(hex: "#FF8A65")!
        case .podcastseriesEducation:
            return Color(hex: "#FFB74D")!
        case .podcastseriesFiction:
            return Color(hex: "#FFD54F")!
        case .podcastseriesGovernment:
            return Color(hex: "#FFF176")!
        case .podcastseriesHistory:
            return Color(hex: "#DCE775")!
        case .podcastseriesHealthAndFitness:
            return Color(hex: "#D4E157")!
        case .podcastseriesKidsAndFamily:
            return Color(hex: "#AED581")!
        case .podcastseriesKidsAndFamilyPetsAndAnimals:
            return Color(hex: "#81C784")!
        case .podcastseriesLeisureAnimationAndManga:
            return Color(hex: "#66BB6A")!
        case .podcastseriesLeisureAutomotive:
            return Color(hex: "#4DB6AC")!
        case .podcastseriesLeisureAviation:
            return Color(hex: "#4DD0E1")!
        case .podcastseriesLeisureCrafts:
            return Color(hex: "#4FC3F7")!
        case .podcastseriesLeisureGames:
            return Color(hex: "#29B6F6")!
        case .podcastseriesLeisureHomeAndGarden:
            return Color(hex: "#26C6DA")!
        case .podcastseriesMusic:
            return Color(hex: "#00BCD4")!
        case .podcastseriesNews:
            return Color(hex: "#03A9F4")!
        case .podcastseriesReligionAndSpirituality:
            return Color(hex: "#2196F3")!
        case .podcastseriesScience:
            return Color(hex: "#3F51B5")!
        case .podcastseriesSocietyAndCulture:
            return Color(hex: "#5C6BC0")!
        case .podcastseriesSports:
            return Color(hex: "#7986CB")!
        case .podcastseriesTechnology:
            return Color(hex: "#9575CD")!
        case .podcastseriesTrueCrime:
            return Color(hex: "#8E24AA")!
        case .podcastseriesTvAndFilm:
            return Color(hex: "#BA68C8")!
        case .comicseriesAction:
            return Color(hex: "#F06292")!
        }
    }
    
    func getTaddyGenres() -> [TaddyPodcast.Genre] {
        var taddyGenres: [TaddyPodcast.Genre] = []
        
        switch self {
        case .podcastseriesArts:
            taddyGenres.append(contentsOf: [.podcastseriesArts, .podcastseriesArtsBooks, .podcastseriesArtsDesign, .podcastseriesArtsFashionAndBeauty, .podcastseriesArtsFood, .podcastseriesArtsPerformingArts, .podcastseriesArtsVisualArts])
        case .podcastseriesBusiness:
            taddyGenres.append(contentsOf: [.podcastseriesBusiness, .podcastseriesBusinessCareers, .podcastseriesBusinessEntrepreneurship, .podcastseriesBusinessInvesting, .podcastseriesBusinessManagement, .podcastseriesBusinessMarketing, .podcastseriesBusinessNonProfit])
        case .podcastseriesComedy:
            taddyGenres.append(contentsOf: [.podcastseriesComedy, .podcastseriesComedyInterviews, .podcastseriesComedyImprov, .podcastseriesComedyStandup])
        case .podcastseriesEducation:
            taddyGenres.append(contentsOf: [.podcastseriesEducation, .podcastseriesEducationCourses, .podcastseriesEducationHowTo, .podcastseriesEducationLanguageLearning, .podcastseriesEducationSelfImprovement])
        case .podcastseriesFiction:
            taddyGenres.append(contentsOf: [.podcastseriesFiction, .podcastseriesFictionComedyFiction, .podcastseriesFictionDrama, .podcastseriesFictionScienceFiction])
        case .podcastseriesGovernment:
            taddyGenres.append(contentsOf: [.podcastseriesGovernment])
        case .podcastseriesHistory:
            taddyGenres.append(contentsOf: [.podcastseriesHistory])
        case .podcastseriesHealthAndFitness:
            taddyGenres.append(contentsOf: [.podcastseriesHealthAndFitness, .podcastseriesHealthAndFitnessAlternativeHealth, .podcastseriesHealthAndFitnessFitness, .podcastseriesHealthAndFitnessMedicine, .podcastseriesHealthAndFitnessMentalHealth, .podcastseriesHealthAndFitnessNutrition, .podcastseriesHealthAndFitnessSexuality, ])
        case .podcastseriesKidsAndFamily:
            taddyGenres.append(contentsOf: [.podcastseriesKidsAndFamily, .podcastseriesKidsAndFamilyEducationForKids, .podcastseriesKidsAndFamilyParenting, .podcastseriesKidsAndFamilyStoriesForKids])
        case .podcastseriesKidsAndFamilyPetsAndAnimals:
            taddyGenres.append(contentsOf: [.podcastseriesKidsAndFamilyPetsAndAnimals])
        case .podcastseriesLeisureAnimationAndManga:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureAnimationAndManga])
        case .podcastseriesLeisureAutomotive:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureAutomotive])
        case .podcastseriesLeisureAviation:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureAviation])
        case .podcastseriesLeisureCrafts:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureCrafts])
        case .podcastseriesLeisureGames:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureGames, .podcastseriesLeisureVideoGames])
        case .podcastseriesLeisureHomeAndGarden:
            taddyGenres.append(contentsOf: [.podcastseriesLeisureHobbies, .podcastseriesLeisureHomeAndGarden])
        case .podcastseriesMusic:
            taddyGenres.append(contentsOf: [.podcastseriesMusic, .podcastseriesMusicCommentary, .podcastseriesMusicHistory, .podcastseriesMusicInterviews])
        case .podcastseriesNews:
            taddyGenres.append(contentsOf: [.podcastseriesNews, .podcastseriesNewsBusiness, .podcastseriesNewsDailyNews, .podcastseriesNewsEntertainment, .podcastseriesNewsCommentary, .podcastseriesNewsPolitics, .podcastseriesNewsSports, .podcastseriesNewsTech])
        case .podcastseriesReligionAndSpirituality:
            taddyGenres.append(contentsOf: [.podcastseriesReligionAndSpirituality, .podcastseriesReligionAndSpiritualityBuddhism, .podcastseriesReligionAndSpiritualityChristianity, .podcastseriesReligionAndSpiritualityHinduism, .podcastseriesReligionAndSpiritualityIslam, .podcastseriesReligionAndSpiritualityJudaism, .podcastseriesReligionAndSpiritualityReligion, .podcastseriesReligionAndSpiritualitySpirituality])
        case .podcastseriesScience:
            taddyGenres.append(contentsOf: [.podcastseriesScience, .podcastseriesScienceAstronomy, .podcastseriesScienceChemistry, .podcastseriesScienceEarthSciences, .podcastseriesScienceLifeSciences, .podcastseriesScienceMathematics, .podcastseriesScienceNaturalSciences, .podcastseriesScienceNature, .podcastseriesSciencePhysics, .podcastseriesScienceSocialSciences])
        case .podcastseriesSocietyAndCulture:
            taddyGenres.append(contentsOf: [.podcastseriesSocietyAndCulture, .podcastseriesSocietyAndCultureDocumentary, .podcastseriesSocietyAndCulturePersonalJournals, .podcastseriesSocietyAndCulturePhilosophy, .podcastseriesSocietyAndCulturePlacesAndTravel, .podcastseriesSocietyAndCultureRelationships])
        case .podcastseriesSports:
            taddyGenres.append(contentsOf: [.podcastseriesSports, .podcastseriesSportsBaseball, .podcastseriesSportsBasketball, .podcastseriesSportsCricket, .podcastseriesSportsFantasySports, .podcastseriesSportsFootball, .podcastseriesSportsGolf, .podcastseriesSportsHockey, .podcastseriesSportsRugby, .podcastseriesSportsRunning, .podcastseriesSportsSoccer, .podcastseriesSportsSwimming, .podcastseriesSportsTennis, .podcastseriesSportsVolleyball, .podcastseriesSportsWilderness, .podcastseriesSportsWrestling])
        case .podcastseriesTechnology:
            taddyGenres.append(contentsOf: [.podcastseriesTechnology])
        case .podcastseriesTrueCrime:
            taddyGenres.append(contentsOf: [.podcastseriesTrueCrime])
        case .podcastseriesTvAndFilm:
            taddyGenres.append(contentsOf: [.podcastseriesTvAndFilm, .podcastseriesTvAndFilmAfterShows, .podcastseriesTvAndFilmHistory, .podcastseriesTvAndFilmInterviews, .podcastseriesTvAndFilmFilmReviews, .podcastseriesTvAndFilmTvReviews])
        case .comicseriesAction:
            taddyGenres.append(contentsOf: [.comicseriesAction, .comicseriesComedy, .comicseriesCrime, .comicseriesDrama, .comicseriesDystopia, .comicseriesEducational, .comicseriesFantasy, .comicseriesHighSchool, .comicseriesHistorical, .comicseriesHorror, .comicseriesHarem, .comicseriesIsekai, .comicseriesMystery, .comicseriesRomance, .comicseriesSciFi, .comicseriesSliceOfLife, .comicseriesSuperhero, .comicseriesSupernatural, .comicseriesBl, .comicseriesGl, .comicseriesLgbtq, .comicseriesThriller, .comicseriesZombies, .comicseriesPostApocalyptic, .comicseriesSports, .comicseriesAnimals, .comicseriesGaming])
        }
        
        return taddyGenres
    }
}
