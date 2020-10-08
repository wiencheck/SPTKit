
import Alamofire
import Foundation

public class SPT {
    public static var authorizationToken: String?
    
    public static var countryCode: String?
    
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
            if let error = try? SPTJSONDecoder().decode(SPTErrorResponse.self, from: data) {
                completion(.failure(error.error))
            }
            print(String(data: data, encoding: .utf8))
            do {
                let object = try SPTJSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
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
    
    private class func normalizeJson(_ json: String) -> Data? {
        guard let first = json.firstIndex(of: "["), let last = json.lastIndex(of: "]") else {
            print(json)
            return json.data(using: .utf8)
        }
        let new = String(json[first...last])
        print(new)
        return json.data(using: .utf8)
    }
    
    private init() {}
}
