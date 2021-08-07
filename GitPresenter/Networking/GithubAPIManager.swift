//
//  GithubAPIManager.swift
//  GitPresenter
//
//  Created by Максим on 06.08.2021.
//

import Foundation

struct GithubAPIManager {
    
    static let shared = GithubAPIManager()
    
    func getRepositories(sinceId: Int? = nil, complition: @escaping(([Repository]?) -> Void)) {
        
        var components = URLComponents(string: "https://api.github.com/repositories?accept=application/vnd.github.nebula-preview+json")!
                                        
        components.queryItems = [
            URLQueryItem(name: "since", value: (sinceId != nil) ? "\(sinceId!)" : "0")
        ]
        
        guard let url = components.url else {
            print("invalid url")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: urlRequest) { data, response, error in
            

            guard let data = data else { return }
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            do {
                let repos = try decoder.decode([Repository].self, from: data)
                complition(repos)
            } catch {
                print(error)
            }
        }.resume()
        
    }
}
