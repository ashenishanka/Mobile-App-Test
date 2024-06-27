//
//  HotelService.swift
//  Mobile-App-Test
//
//  Created by Ashen Ishanka on 2024-06-27.
//

import Foundation

class HotelService{
    // MARK: - We are going to use this hotel service class to call to network manager and recieve data from it. this will help to reduce complexity 
    private let mNetworkManager: NetworkManager
    init(mNetworkManager: NetworkManager) {
        self.mNetworkManager = mNetworkManager
    }
    
    func getAllHotels(completion: @escaping(Result<[HotelItem], Error>) -> Void){
        mNetworkManager.getConnect { result in
           
            switch result {
              case .success(let hotelData):
                    completion(.success(hotelData.data))
              case .failure(let error):
                    completion(.failure(error))
            }
        }
    }
}
