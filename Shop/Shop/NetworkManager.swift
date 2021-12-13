import Foundation

public struct UnwrapError<T> : Error, CustomStringConvertible {
    let optional: T?

    public var description: String {
        return "Found nil while unwrapping \(String(describing: optional))!"
    }
}


func unwrap<T>(_ optional: T?) throws -> T {
    if let real = optional {
        return real
    } else {
        print("EROROROROROROROROROROROROROOROROR")
        throw NetworkError.error(UnwrapError(optional: optional))
    }
}

enum NetworkError: Error, Equatable {
    static func == (lhs: NetworkError, rhs: NetworkError) -> Bool {
        switch (lhs, rhs) {
        case (.noData, .noData):
            return true
        case (let .error(error1), let error(error2)):
            return error1.localizedDescription == error2.localizedDescription
        case (.malformedData, .malformedData):
              return true
        default:
            return false
        }
    }

    case noData
    case error(Error)
    case malformedData
}

// Excercise: Create a networking manager to fetch data from an API endpoint
//
// Requirement:
// - Use URLSession for this excercise.
// - Return a NetworkError if error occurs or not data.
//
// Hint: Decodable, URLSession, URLSessionConfiguration, Decoder
protocol NetworkManaging {
    func data<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void)
}

public class NetworkManager: NetworkManaging {

    var session:URLSession? = nil
    var urlRequest:URLRequest? = nil
    
    init() {
        session = URLSession(configuration: .default)
    }

    func data<T: Decodable>(from url: URL, type: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
        urlRequest = URLRequest(url: url)
        urlRequest?.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        session?.dataTask(with: urlRequest!, completionHandler: {data, response, error -> Void in
            do {
                let jsonData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
                var products: [Product]! = []
                let initialProducts: NSArray = jsonData["products"] as! NSArray
                
                for product in initialProducts {
                    let dictionnary = product as! NSDictionary
                    var toAppend: Product = Product()
        
                    do {toAppend.id = try unwrap(dictionnary["id"] as? String)} catch {completion(.failure(error as! NetworkError)); return}
                    do {toAppend.name = try unwrap(dictionnary["name"] as? String)} catch {completion(.failure(error as! NetworkError)); return}
                    do {toAppend.image = try unwrap(dictionnary["image"] as? String)} catch {completion(.failure(error as! NetworkError)); return}
                    do {toAppend.price_cents = try unwrap(dictionnary["price_cents"] as? Int)} catch {completion(.failure(error as! NetworkError)); return}
                    do {toAppend.currency = try unwrap(dictionnary["currency"] as? String)} catch {completion(.failure(error as! NetworkError)); return}
                    products.append(toAppend)
                }
                let shop: Shop = .init(
                    company_name: jsonData["company_name"] as! String,
                    products: products
                )
                completion(.success(shop as! T))
            } catch {
                completion(.failure(error as! NetworkError))
            }
        }).resume()
    }
}
