// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

extension TaddyPodcast {
  class GetPodcastSeriesQuery: GraphQLQuery {
    static let operationName: String = "GetPodcastSeries"
    static let operationDocument: ApolloAPI.OperationDocument = .init(
      definition: .init(
        #"query GetPodcastSeries($uuid: ID!) { getPodcastSeries(uuid: $uuid) { __typename uuid name description imageUrl episodes(page: 1) { __typename uuid datePublished name description(shouldStripHtmlTags: true) audioUrl } } }"#
      ))

    public var uuid: ID

    public init(uuid: ID) {
      self.uuid = uuid
    }

    public var __variables: Variables? { ["uuid": uuid] }

    struct Data: TaddyPodcast.SelectionSet {
      let __data: DataDict
      init(_dataDict: DataDict) { __data = _dataDict }

      static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.Query }
      static var __selections: [ApolloAPI.Selection] { [
        .field("getPodcastSeries", GetPodcastSeries?.self, arguments: ["uuid": .variable("uuid")]),
      ] }

      ///  Get details on a Podcast 
      var getPodcastSeries: GetPodcastSeries? { __data["getPodcastSeries"] }

      /// GetPodcastSeries
      ///
      /// Parent Type: `PodcastSeries`
      struct GetPodcastSeries: TaddyPodcast.SelectionSet {
        let __data: DataDict
        init(_dataDict: DataDict) { __data = _dataDict }

        static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.PodcastSeries }
        static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("uuid", TaddyPodcast.ID?.self),
          .field("name", String?.self),
          .field("description", String?.self),
          .field("imageUrl", String?.self),
          .field("episodes", [Episode?]?.self, arguments: ["page": 1]),
        ] }

        ///  Taddy's unique identifier (an uuid) 
        var uuid: TaddyPodcast.ID? { __data["uuid"] }
        ///  The name (title) for a podcast 
        var name: String? { __data["name"] }
        ///  The description for a podcast 
        var description: String? { __data["description"] }
        ///  The cover art for a podcast 
        var imageUrl: String? { __data["imageUrl"] }
        ///  A list of episodes for this podcast 
        var episodes: [Episode?]? { __data["episodes"] }

        /// GetPodcastSeries.Episode
        ///
        /// Parent Type: `PodcastEpisode`
        struct Episode: TaddyPodcast.SelectionSet {
          let __data: DataDict
          init(_dataDict: DataDict) { __data = _dataDict }

          static var __parentType: ApolloAPI.ParentType { TaddyPodcast.Objects.PodcastEpisode }
          static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("uuid", TaddyPodcast.ID?.self),
            .field("datePublished", Int?.self),
            .field("name", String?.self),
            .field("description", String?.self, arguments: ["shouldStripHtmlTags": true]),
            .field("audioUrl", String?.self),
          ] }

          ///  Taddy's unique identifier (an uuid) 
          var uuid: TaddyPodcast.ID? { __data["uuid"] }
          ///  Date when the episode was published (Epoch time in seconds) 
          var datePublished: Int? { __data["datePublished"] }
          ///  The name of an episode 
          var name: String? { __data["name"] }
          ///  The description for a episode 
          var description: String? { __data["description"] }
          ///  Link to Audio Content for the episode
          var audioUrl: String? { __data["audioUrl"] }
        }
      }
    }
  }

}