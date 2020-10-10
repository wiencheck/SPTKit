
import Foundation
import Alamofire
import SPTKitModels

public class SPT {
    /**
     A valid access token from the Spotify Accounts service. This library does not take the responsibility of authentication. You have to implement it by yourself. [Read more](https://developer.spotify.com/documentation/general/guides/authorization-guide/)
     */
    public static var authorizationToken: String?
    
    /**
     An ISO 3166-1 alpha-2 country code.
     Supply this parameter to limit the response to one particular geographical market. For example, for albums available in Sweden: country=SE.
     If not given, results will be returned for all countries and you are likely to get duplicate results per album, one for each country in which the album is available!
     Default value is current `Locale`'s region code.
     */
    public static var countryCode: String? = Locale.current.regionCode
    
    // MARK: Internal stuff
    class func call<T>(method: SPTMethod, pathParam: String?, queryParams: [String: String]?, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {
        
        guard let request = forgeRequest(for: method, pathParam: pathParam, queryParams: queryParams) else {
            completion(.failure(SPTError.badRequest))
            return
        }
        perform(request: request, completion: completion)
    }
    
    // MARK: Private stuff
    private class func perform<T>(request: URLRequestConvertible, completion: @escaping (Result<T, Error>) -> Void) where T: Decodable {

        AF.request(request).responseData { response in
            if let error = response.error {
                completion(.failure(error))
            }
            guard let data = response.value else {
                completion(.failure(SPTError.noDataReceivedError))
                return
            }
            if let error = try? SPTJSONDecoder().decode(SPTError.self, from: data) {
                completion(.failure(error))
            } else {
                do {
                    let object = try SPTJSONDecoder().decode(T.self, from: data)
                    completion(.success(object))
                } catch let DecodingError.dataCorrupted(context) {
                    print(context)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.keyNotFound(key, context) {
                    print("Key '\(key)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.valueNotFound(value, context) {
                    print("Value '\(value)' not found:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch let DecodingError.typeMismatch(type, context)  {
                    print("Type '\(type)' mismatch:", context.debugDescription)
                    print("codingPath:", context.codingPath)
                    completion(.failure(context.underlyingError ?? SPTError.decodingError))
                } catch {
                    print("error: ", error)
                }
            }
        }
    }
    
    private class func forgeRequest(for method: SPTMethod, pathParam: String?, queryParams: [String: String]?) -> URLRequest? {
        
        guard let token = SPT.authorizationToken, !token.isEmpty else {
            print("*** Authorization token cannot be empty ***")
            return nil
        }
        let header = HTTPHeader(name: "Authorization", value: "Bearer " + token)
        guard let url = method.composed(pathParam: pathParam, queryParams: queryParams),
            let request = try? URLRequest(url: url, method: method.method, headers: HTTPHeaders(arrayLiteral: header)) else {
                return nil
        }
        return request
    }
    
    private init() {}
}
