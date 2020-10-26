# SPTKit

SPTKit is a framework build to call Spotify Web API methods directly from Swift code. It is built around Alamofire and Swift's Codable, so the dependency count is kept to a bare minimum. 

## Installation
SPTKit can be installed via Swift Package Manager

`https://github.com/wiencheck/SPTKit.git`

## Usage

To use methods provided by SPTKit you use modules for each endpoint. For example, to [read user's saved albums](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/) you use the `.Album` module, like this
`SPT.Album.getSavedAlbums(...`

Available modules are:
* [Albums](https://developer.spotify.com/documentation/web-api/reference/albums)
* [Artists](https://developer.spotify.com/documentation/web-api/reference/artists)
* [Follow](https://developer.spotify.com/documentation/web-api/reference/follow)
* [Library](https://developer.spotify.com/documentation/web-api/reference/library)
* [Playlists](https://developer.spotify.com/documentation/web-api/reference/playlists)
* [Search](https://developer.spotify.com/documentation/web-api/reference/search/search)
* [Tracks](https://developer.spotify.com/documentation/web-api/reference/tracks)

### Paging

### Handling errors
If a request suceeds but is invalid, the error message will be the error message returned directly from Spotify. 

`{
  "error": {
    "status": 401,
    "message": "Invalid access token"
  }
}`

If request failed, the returned error will be of type `AFError`.

### Authorization
All methods from Web API require an authorization token, obtained from Spotify. This library **does not** handle the authorization process for you, however the example app contains the barebones code required for authenticating using the Spotify-SDK framework. Please follow the official instructions on how to authenticate.
You still need to register your app in developer portal and provide necessary credentials. 

### Missing methods
Not all methods from the Web API are supported at the moment. If you find any missing method you might need in your project, you can submit a PR, or create an issue and I'll do my best to implement it ASAP. 
