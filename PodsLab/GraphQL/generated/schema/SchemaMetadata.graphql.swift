// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

protocol TaddyPodcast_SelectionSet: ApolloAPI.SelectionSet & ApolloAPI.RootSelectionSet
where Schema == TaddyPodcast.SchemaMetadata {}

protocol TaddyPodcast_InlineFragment: ApolloAPI.SelectionSet & ApolloAPI.InlineFragment
where Schema == TaddyPodcast.SchemaMetadata {}

protocol TaddyPodcast_MutableSelectionSet: ApolloAPI.MutableRootSelectionSet
where Schema == TaddyPodcast.SchemaMetadata {}

protocol TaddyPodcast_MutableInlineFragment: ApolloAPI.MutableSelectionSet & ApolloAPI.InlineFragment
where Schema == TaddyPodcast.SchemaMetadata {}

extension TaddyPodcast {
  typealias ID = String

  typealias SelectionSet = TaddyPodcast_SelectionSet

  typealias InlineFragment = TaddyPodcast_InlineFragment

  typealias MutableSelectionSet = TaddyPodcast_MutableSelectionSet

  typealias MutableInlineFragment = TaddyPodcast_MutableInlineFragment

  enum SchemaMetadata: ApolloAPI.SchemaMetadata {
    static let configuration: ApolloAPI.SchemaConfiguration.Type = SchemaConfiguration.self

    static func objectType(forTypename typename: String) -> ApolloAPI.Object? {
      switch typename {
      case "Query": return TaddyPodcast.Objects.Query
      case "SearchResults": return TaddyPodcast.Objects.SearchResults
      case "PodcastEpisode": return TaddyPodcast.Objects.PodcastEpisode
      case "PodcastSeries": return TaddyPodcast.Objects.PodcastSeries
      default: return nil
      }
    }
  }

  enum Objects {}
  enum Interfaces {}
  enum Unions {}

}