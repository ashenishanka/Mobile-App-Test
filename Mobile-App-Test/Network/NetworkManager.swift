//
//  NetworkManager.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-26.
//

import Foundation

enum HotelError: Error{
    case wrongURL
    case emptyData
    case decodingError
    
}
class NetworkManager{
    //from this class we are going handle the API
    //In our case url is https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json
    func getHotels(completion: @escaping(Result<HotelsData,HotelError> ) -> Void){
        guard let url = URL(string: K.dataUrl) else{
            return completion(.failure(.wrongURL))
        }
        URLSession.shared.dataTask(with: url){
            data, response, error in
            guard let data = data, error == nil else{
                return completion(.failure(.emptyData))
            }
            
            
            
            
            do {
                
                let hotelResponse = try? JSONDecoder().decode(HotelsData.self, from: data)
                
                if let hotelResponse = hotelResponse{
                    
                    return completion(.success(hotelResponse))
                }else{
                    
                    completion(.failure(.decodingError))
                }
            }catch let error{
                print(error)
            }
        }.resume()
    }
}
