//
//  Service.swift
//  AnimeClassifier
//
//  Created by Ali Eldeeb on 1/21/23.
//

import Foundation

enum NetworkError: Error {
    case BadResponse
    case BadStatusCode(Int)
    case BadData
}

final class Service {
    static let shared = Service()
    private let session = URLSession(configuration: .default)
    private var images = NSCache<NSString, NSData>()
    
    func fetchData(completion: @escaping(Result<Moe, NetworkError>) -> ()) {
        guard let url = URL(string: "https://api.trace.moe/search?url=https://images.plurk.com/32B15UXxymfSMwKGTObY5e.jpg") else { return }
        
        session.dataTask(with: url) { data, response, error in
            guard error == nil else{
                completion(.failure(NetworkError.BadData))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(.failure(NetworkError.BadResponse))
                return
            }
            
            guard(200...299).contains(response.statusCode) else {
                completion(.failure(NetworkError.BadStatusCode(response.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(NetworkError.BadData))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let safeData = try decoder.decode(Moe.self, from: data)
                completion(.success(safeData))
            } catch let error {
                print(error)
            }
        }.resume()
    }
    
    func fetchImage(urlString: String, completion: @escaping(Data?, NetworkError?) -> ()) {
        
        guard let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed), let url = URL(string: encodedString) else { return }
        
        if let imageData = images.object(forKey: url.absoluteString as NSString) {
            completion(imageData as Data, nil)
            return
        }
        
        session.downloadTask(with: url) { localUrl, response, error in
            guard error == nil else{
                completion(nil, NetworkError.BadData)
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                completion(nil, NetworkError.BadResponse)
                return
            }
            
            guard(200...299).contains(response.statusCode) else {
                completion(nil, NetworkError.BadStatusCode(response.statusCode))
                return
            }
            
            guard let localUrl = localUrl else {
                completion(nil, NetworkError.BadData)
                return
            }
            
            do {
                let safeData = try Data(contentsOf: localUrl)
                self.images.setObject(safeData as NSData, forKey: url.absoluteString as NSString)
                completion(safeData, nil)
            } catch let error  {
                print(error)
            }
        }.resume()
    }
}
