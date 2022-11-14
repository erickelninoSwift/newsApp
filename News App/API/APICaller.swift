//
//  APICaller.swift
//  News App
//
//  Created by Erick El nino on 2022/11/13.
//  Copyright © 2022 Erick El nino. All rights reserved.
//

import Foundation

final class APICaller
{
    static let shared = APICaller()
    
    struct Constant
    {
        static let topHeadlinesURL = URL(string: "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=e8772b0d460f47328230cef9da249306")
        
       
    }
    
    private init(){}
    
    
    func getTopStories(completion: @escaping(Result<[Article],Error>) -> Void)
    {
        guard let url = Constant.topHeadlinesURL else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (Data, _, Error) in
            if let error  = Error
            {
                completion(.failure(error))
            }else if let data = Data
            {
                do
                {
                    let results = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(results.articles))
                }catch
                {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    
    
    func searchWithQuery(with Query: String, completion: @escaping(Result<[Article],Error>) -> Void)
    {
        let searchQuer1 = "https://newsapi.org/v2/everything?q=\(Query)&from=2022-11-13&to=2022-11-13&sortBy=popularity&apiKey=e8772b0d460f47328230cef9da249306"
         print(searchQuer1)
//        guard !searchQuer1.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        
        
        guard let url = URL(string: searchQuer1) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { (Data, _, Error) in
            if let error  = Error
            {
                completion(.failure(error))
                
            }else if let data = Data
            {
                do
                {
                    let results = try JSONDecoder().decode(APIResponse.self, from: data)
                    
                    completion(.success(results.articles))
                }catch
                {
                    completion(.failure(error))
                }
            }
        }
        
        task.resume()
    }
    
    
}

struct APIResponse: Codable
{
    let articles:[Article]
}

struct Article: Codable
{
    let source:Source
    let title: String?
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String?
    
}

struct Source: Codable
{
    let name: String
}


