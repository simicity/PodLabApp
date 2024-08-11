# PodLab: Podcast Finder & Listener

iOS app for searching and listening to podcasts 🎧 It's built in SwiftUI, utilizing SwiftData for local data storage. Podcast data is sourced from [Taddy Podcast API](https://taddy.org/developers) (GraphQL).

<img src="https://imgur.com/SeOZDdY.gif" width="240px" />

## Features
- **Search & Filter:** Find podcasts by keyword and genre.
- **Episode Management:** Save your favorite episodes for easy access.
- **Playback:** Enjoy playback controls, including fast forward, rewind, and a draggable progress bar for precise seeking.
- **Dark Mode:** Full support for Dark Mode to match your system preferences.
  
## How to Use
To get started with PodLab, you’ll need to set up your Taddy API credentials. Add the following enum to your project and fill in your Taddy user ID and API key in the placeholders.

```swift
enum TaddyCredential {
    static let API_ENDPOINT = "https://api.taddy.org"
    static let TADDY_USER_ID = "" // Your Taddy user ID
    static let TADDY_API_KEY = "" // Your Taddy API key
}
```
