//
//  APIService.swift
//  WeatherApp
//
//  Created by Nazmi Ceylan on 29.08.2024.
//

import Foundation

class APIService {
    static let shared = APIService()

    enum APIError: Error {
        case error(_ errString: String)
    }

    func getJson<T: Decodable>(
        urlString: String,
        dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate,
        keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,
        completion: @escaping (Result<T,APIError>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(.error("Error Url: Invalid URL")))
            return
        }

        let request = URLRequest(url: url)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(.error("Error: \(error.localizedDescription)")))
                return
            }

            guard let data = data else {
                completion(.failure(.error("Error Data: Data us corrupt")))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = dateDecodingStrategy
            decoder.keyDecodingStrategy = keyDecodingStrategy

            do {
                let decodeData = try decoder.decode(T.self, from: data)
                completion(.success(decodeData))
                return
            } catch let decodingError {
                completion(.failure(APIError.error("Error Decode: \(decodingError.localizedDescription)")))
                return
            }

        }.resume()
    }
}
