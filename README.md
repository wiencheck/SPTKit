![sptkit-logo](https://i.imgur.com/knXnBP8.png)

# SPTKit

SPTKit is a lightweight, elegant and easy to use **Spotify Web API** wrapper written in pure Swift. It is built around Swift's [Codable](https://developer.apple.com/documentation/foundation/archives_and_serialization/encoding_and_decoding_custom_types) to offer great perfomance and simplicity. SPTKit makes calls to Web API and returns clean, easy to use objects which can be then easily stored on the device via good old JSONEncoder.

## Requirements
* iOS 10+ / macOS 10.12+ / tvOS 10+ / watchOS 3+

## Installation
### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the swift compiler. 
In order to do add SPTKit to your project, use the following URL:

`https://github.com/wiencheck/SPTKit.git`

## Usage
SPTKit supports most of Web API's endpoints and methods. To use any of the methods you have to obtain an authorization token

### How to get an authorization token?
SPTKit doesn't handle authorization with Spotify, you have to manage that yourself. How to do that is described in great depth
* [On Spotify iOS SDK official github repo](https://github.com/spotify/ios-sdk)
* [In various articles](https://medium.com/@brianhans/getting-started-with-the-spotify-ios-sdk-435607216ecc)

However, the Example app contains barebones code needed to perform the authorization. You'll still need to set you application in [Spotify Dashboard](https://developer.spotify.com/dashboard/login) before continuing.
After obtaining auth token, you have to tell framework about it:
`SPT.authorizationToken = "my_unique_token"`

### Working with different markets
Some methods have to declare user's country code to properly return available objects. SPTKit reads this information from `Locale.current` by default, but you can override it by setting
`SPT.countryCode = "de"`

### How to call the methods
To use methods provided by SPTKit you use **Modules** for each endpoint. Spotify's Web API has various endpoints for calling methods for albums, library, search etc. and that structure is reflected in SPTKit. Methods are contained inside modules and each module represents API endpoint like you'd see in the [API reference docs](https://developer.spotify.com/documentation/web-api/reference/)

![api-reference](https://i.imgur.com/31oYFzL.png)

For example, to [get an Album](https://developer.spotify.com/documentation/web-api/reference/albums/get-album/) method, you'd use the `Album` module and its `getAlbum` method, like this:
`SPT.Album.getAlbum(...`
To [read user's saved albums](https://developer.spotify.com/documentation/web-api/reference/library/get-users-saved-albums/) you use the `Library` module, like this
`SPT.Library.getSavedAlbums(...`

You get the idea.

Available modules are:
* [Albums](https://developer.spotify.com/documentation/web-api/reference/albums)
* [Artists](https://developer.spotify.com/documentation/web-api/reference/artists)
* [Follow](https://developer.spotify.com/documentation/web-api/reference/follow)
* [Library](https://developer.spotify.com/documentation/web-api/reference/library)
* [Playlists](https://developer.spotify.com/documentation/web-api/reference/playlists)
* [Search](https://developer.spotify.com/documentation/web-api/reference/search/search)
* [Tracks](https://developer.spotify.com/documentation/web-api/reference/tracks)
* [Users](https://developer.spotify.com/documentation/web-api/reference/users-profile/)

### Paging
Some methods, which can return more than a few objects ([like getting Playlist's tracks](https://developer.spotify.com/documentation/web-api/reference/playlists/get-playlists-tracks/)), return them wrapped in a paging objects instead. 
### What is a paging object? 
    
It's a generic class that holds an array of objects, and some metadata like page's offset and URLs for calling next, or previous pages.
```swift
public class SPTPagingObject<T: Codable>: Codable {
    public let items: [T]
    public let limit: Int
    public let next: URL?
    public let offset: Int
    public let previous: URL?
    public let total: Int
    
    public var canMakeNextRequest: Bool {
        return next != nil
    }
    
    public var canMakePreviousRequest: Bool {
        return previous != nil
    }
    ...
    }
```
### How to use a paging object?
You would typically extract objects from current page and then try to obtain next page and repeat the process until reaching the last page.
**Example usage**
```swift
func handlePage<T>(_ page: SPTPagingObject<T>) where T: Decodable {
    print(page.items)
    
    guard page.canMakeNextRequest else {
        return
    }
    page.getNext { result in
        switch result {
        case .success(let newPage):
            self.handlePage(newPage)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
```
`SPTPagingObject` defines helper methods `getNext` and `getPrevious`  to quickly obtain related pages.

### Handling errors
There are 3 cases in which errors can be raised, each one returning different type of an error:
* Request error - Request couldn't be completed because of faulty internet connection or something like that
* Service error - Request sucseeded but was invalid. This can happen if authorization token was not provided, parameters passed to method were in incorrect format, etc.
**Example service error structure**
```
{
  "error": {
    "status": 401,
    "message": "Invalid access token"
  }
}
```
* Decoding error. This type of error should not happen, but in case it does, what it means is that there was a change in returned JSON and it couldn't be decoded correctly. Or I screwed up something along the way, which we know can't happen, right? Please report if you encounter this error.

### Missing methods
Not all methods from the Web API are supported at the moment. Especially podcasts are currently not existent in this library. I am still working on this library so if you need any methods that are not implemented yet, please create an issue or better, submit a PR!

## License
SPTKit is available under the MIT license. See the LICENSE file for more info.
