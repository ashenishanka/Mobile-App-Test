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
    let apiHandler: APIHandler
    let responseHandler: ResponseHandler
    init(apiHandler: APIHandler, responseHandler: ResponseHandler) {
        self.apiHandler = apiHandler
        self.responseHandler = responseHandler
    }
    //from this class we are going handle the API
    //In our case url is https://dl.dropboxusercontent.com/s/6nt7fkdt7ck0lue/hotels.json
    func getConnect(completion: @escaping(Result<HotelsData,HotelError> ) -> Void){
        guard let url = URL(string: K.dataUrl) else{
            return completion(.failure(.wrongURL))
        }
        apiHandler.getHotels(url: url) { result in
            
            switch (result){
            case .success(let mHotelData):
                self.responseHandler.parseHotelInformation(data: mHotelData) { result in
                    switch(result){
                    case .success(let hotelsData):
                        completion(.success(hotelsData))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
            
        }
    }
}
class APIHandler{
    func getHotels(url: URL, completion: @escaping(Result<Data, HotelError>) -> Void){
        URLSession.shared.dataTask(with: url){
            data, response, error in
            guard let data = data, error == nil else{
                return completion(.failure(.emptyData))
            }
            
            completion(.success(data))
            
            
            
        }.resume()
    }
}

class ResponseHandler{
    func parseHotelInformation(data: Data, completion: @escaping(Result<HotelsData,HotelError>) -> Void){
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
    }
}
