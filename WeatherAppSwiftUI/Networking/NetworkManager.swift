//
//  NetworkManager.swift
//  WeatherAppSwiftUI
//
//  Created by Helen Poe on 05.03.2022.
//

import Foundation
import SwiftUI
// setevoi manager kotorui neset otvetstvennost za sozdanie vuzovov API
final class NetworkManager<T: Codable> {
    static func fetch(for url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else{
                print(String(describing: error!))
                completion(.failure(.error(err: error!.localizedDescription)))
                return
            }
            // proverka/zawita v sluchae esli pridet ne http:
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                completion(.failure(.invalidResponse))
                return
            }
            //proverka/ zawita dlya bezopasnogo razvorota dannuh,kotorue buli nam predostavlenu, esli oni ne vernue , togda nam nujno otverir ili postavit blok zavershenie
            guard let data = data else{
                completion(.failure(.invalidData))
                return
            }
            // esli dannue proshli vse eti proverki to json mojet decodirovat dannue chto prishli
            do{
                let json = try JSONDecoder().decode(T.self, from: data)
                completion(.success(json))
            // proverka na oshibki pri dekodirovanii
            } catch let err {
                print(String(describing: err))
                completion(.failure(.decodingError(err: error!.localizedDescription)))
            }
        }.resume()
    }
}

enum NetworkError: Error{
    case invalidResponse
    case invalidData
    case error(err: String)
    case decodingError(err: String)
}
