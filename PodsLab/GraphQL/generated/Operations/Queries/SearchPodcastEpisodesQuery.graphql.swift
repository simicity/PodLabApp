// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TaddyPodcast {
  class SearchPodcastEpisodesQuery: GraphQLQuery {
    static let operationName: String = "SearchPodcastEpisodes"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query SearchPodcastEpisodes($searchValue: String!, $genres: [Genre!]!, $page: Int!) { searchForTerm( term: $searchValue includeSearchOperator: OR filterForTypes: PODCASTEPISODE sortByDatePublished: LATEST filterForGenres: $genres filterForLanguages: [ENGLISH] page: $page searchResultsBoostType: BOOST_POPULARITY_A_LOT ) { __typename searchId podcastEpisodes { __typename uuid datePublished name description(shouldStripHtmlTags: true) subtitle audioUrl duration podcastSeries { __typename uuid name description imageUrl } } } }"#
      ))

    public var searchValue: String
    public var genres: [GraphQLEnum<Genre>]
    public var page: Int

    public init(
      searchValue: String,
      genres: [GraphQLEnum<Genre>],
      page: Int
    ) {
      self.searchValue = searchValue
      self.genres = genres
      self.page = page
    }

    public var __variables: Variables? { [
      "searchValue": searchValue,
      "genres": genres,
      "page": page
    ] }

    struct Data: TaddyPodcast.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("searchForTerm", SearchForTerm?.self, arguments: [
          "term": .variable("searchValue"),
          "includeSearchOperator": "OR",
          "filterForTypes": "PODCASTEPISODE",
          "sortByDatePublished": "LATEST",
          "filterForGenres": .variable("genres"),
          "filterForLanguages": ["ENGLISH"],
          "page": .variable("page"),
          "searchResultsBoostType": "BOOST_POPULARITY_A_LOT"
        ]),
      ] }

      ///  Get Search results details for a term 
      var searchForTerm: SearchForTerm? { __data["searchForTerm"] }

      /// SearchForTerm
      ///
      /// Parent Type: `SearchResults`
      struct SearchForTerm: TaddyPodcast.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.SearchResults }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("searchId", TaddyPodcast.ID.self),
          .field("podcastEpisodes", [PodcastEpisode?]?.self),
        ] }

        ///  Identifier for the search query being sent 
        var searchId: TaddyPodcast.ID { __data["searchId"] }
        ///  A list of PodcastEpisode items 
        var podcastEpisodes: [PodcastEpisode?]? { __data["podcastEpisodes"] }

        /// SearchForTerm.PodcastEpisode
        ///
        /// Parent Type: `PodcastEpisode`
        struct PodcastEpisode: TaddyPodcast.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.PodcastEpisode }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("uuid", TaddyPodcast.ID?.self),
            .field("datePublished", Int?.self),
            .field("name", String?.self),
            .field("description", String?.self, arguments: ["shouldStripHtmlTags": true]),
            .field("subtitle", String?.self),
            .field("audioUrl", String?.self),
            .field("duration", Int?.self),
            .field("podcastSeries", PodcastSeries?.self),
          ] }

          ///  Taddy's unique identifier (an uuid) 
          var uuid: TaddyPodcast.ID? { __data["uuid"] }
          ///  Date when the episode was published (Epoch time in seconds) 
          var datePublished: Int? { __data["datePublished"] }
          ///  The name of an episode 
          var name: String? { __data["name"] }
          ///  The description for a episode 
          var description: String? { __data["description"] }
          ///  The subtitle of an episode (shorter version of episode description, limited to 255 characters long) 
          var subtitle: String? { __data["subtitle"] }
          ///  Link to Audio Content for the episode
          var audioUrl: String? { __data["audioUrl"] }
          ///  Duration of Content (in seconds) 
          var duration: Int? { __data["duration"] }
          ///  Details on the podcast for which this episode belongs to 
          var podcastSeries: PodcastSeries? { __data["podcastSeries"] }

          /// SearchForTerm.PodcastEpisode.PodcastSeries
          ///
          /// Parent Type: `PodcastSeries`
          struct PodcastSeries: TaddyPodcast.SelectionSet {
            let __data: DataDict
            init(_dataDict: DataDict) { __data = _dataDict }

            static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.PodcastSeries }
            static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("uuid", TaddyPodcast.ID?.self),
              .field("name", String?.self),
              .field("description", String?.self),
              .field("imageUrl", String?.self),
            ] }

            ///  Taddy's unique identifier (an uuid) 
            var uuid: TaddyPodcast.ID? { __data["uuid"] }
            ///  The name (title) for a podcast 
            var name: String? { __data["name"] }
            ///  The description for a podcast 
            var description: String? { __data["description"] }
            ///  The cover art for a podcast 
            var imageUrl: String? { __data["imageUrl"] }
          }
        }
      }
    }
  }

}