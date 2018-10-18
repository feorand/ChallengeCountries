//
// Created by Pavel Prokofyev on 18/10/2018.
// Copyright (c) 2018 Pavel Prokofyev. All rights reserved.
//

import Foundation

class NetworkDownloader {

    func executeRequest( from urlString: String,
                         completionHandler handler: @escaping (Data) -> ()) {

        guard let url = URL(string: urlString) else { return }

        let urlRequest = URLRequest(url: url)

        let urlSession = URLSession.shared.dataTask(with: urlRequest) {
            (data, urlResponse, error) in

            if let error = error {
                print(error)
                return
            }

            guard let data = data else {
                print("Empty data received")
                return
            }

            DispatchQueue.main.async {
                handler(data)
            }
        }

        urlSession.resume()
    }
}
