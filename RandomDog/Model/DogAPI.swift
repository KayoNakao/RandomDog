//
//  DogAPI.swift
//  RandomDog
//
//  Created by 中尾 佳代 on 2019/03/20.
//  Copyright © 2019 Kayo Nakao. All rights reserved.
//

import Foundation
import UIKit

class DogAPI{
    enum EndPoint {
        
        case randomDogByAllBreed
        case randomDogByBreed(String)
        case listAllTheBreed
        
        var url:URL {
            return URL(string: self.stringValue)!
        }
        
        var stringValue: String {
            switch self {
            case .randomDogByAllBreed:
                return "https://dog.ceo/api/breeds/image/random"
            case .randomDogByBreed(let breed):
                return "https://dog.ceo/api/breed/\(breed)/images/random"
            case .listAllTheBreed:
                return "https://dog.ceo/api/breeds/list/all"
            }
        }
        
    }
    
    class func requestAllBreed(completion:@escaping ([String], Error?)->Void){
        
        let listAllBreedEndpoint = DogAPI.EndPoint.listAllTheBreed.url
        let task = URLSession.shared.dataTask(with: listAllBreedEndpoint) { (data, response, error) in
            
            guard let data = data else {
                completion([], error)
                return
            }
            
            let decoder = JSONDecoder()
            let breedResponse = try! decoder.decode(BreedList.self, from: data)
            let breeds = breedResponse.message.keys.map({$0})
            completion(breeds, nil)
        }
        task.resume()
    }
    
    class func requestRandomImageData(breed:String, completion:@escaping (DogImage?, Error?)->Void){
        
        let randomImageEndpoint = DogAPI.EndPoint.randomDogByBreed(breed).url
        let task = URLSession.shared.dataTask(with: randomImageEndpoint) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return}
            
            let decoder = JSONDecoder()
            do{
                let imageData = try decoder.decode(DogImage.self, from: data)
                completion(imageData, nil)

            }catch{
                print("error: decoding random image data")
            }
            //print(imageData)
        }
        task.resume()
    }
    
    
    class func requestDogImage(url: URL, completion: @escaping (UIImage?, Error?) -> Void){
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else {
                completion(nil, error)
                return
            }
            let image = UIImage(data: data)
            completion(image, nil)
        }
        task.resume()
    }
    
}
