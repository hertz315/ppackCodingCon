//
//  NetworkManager.swift
//  CatDiary
//
//  Created by Hertz on 9/4/22.
//

import Foundation

enum NetworkError: Error {
    case urlStringError
    case networkingError
    case dataError
    case parseError
}

//MARK: - Networking (서버와 통신하는) 클래스 모델
final class NetworkManager {
    
    // 정대리 카카오 로그인 영상 참고 - 시크릿 키 설정
    // https://youtu.be/7Y4UR0UhgHs
    static let api = "live_zdptpAOW4xhcBRgNFvpPsqvx6pxX3bp2XTc8aQ7tenVKOuymKgOpqnVBpdZpnpMx"
    static let apiHeaderField = "x-api-key"
    
    #if DEBUG
    static let BASE_URL = "https://api.thecatapi.com/v1/"
    #else
    static let BASE_URL = "https://www.thecatapi.com/v1/"
    #endif
    
    static let FAVORITE_URL = BASE_URL + "favourites"
    
    
    
    // 싱글톤
    static let shared = NetworkManager()
    private init() {}
    
    
    // getMethod
    // MARK: - Get 메서드(이미지를 가져오는 메서드)
    func fetchData(completionHandler: @escaping ([CatGetModel]) -> Void) {
        
        // URL구조체 만들기
        guard let url = URL(string: "https://api.thecatapi.com/v1/images/search?format=json&limit=30&page=0&has_breeds=true" ) else {
            print("Error: cannot create URL")
            return
        }
        
        // api 인증 키
        let api = "live_zdptpAOW4xhcBRgNFvpPsqvx6pxX3bp2XTc8aQ7tenVKOuymKgOpqnVBpdZpnpMx"
        let apiHeaderField = "x-api-key"
        
        // URL요청 생성
        var request = URLRequest(url: url)
        request.addValue(api, forHTTPHeaderField: apiHeaderField)
        request.httpMethod = "GET"
        
        // 요청을 가지고 작업세션시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // 에러가 없어야 넘어감
            guard error == nil else {
                print("Error: error calling GET")
                print("⭐️에러⭐️")
                print(error!)
                return
            }
            
            // 옵셔널 바인딩
            guard let safeData = data else {
                print("Error: Did not receive data")
                print("⭐️데이터에러⭐️")
                return
            }
            
            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print("⭐️통신에러⭐️")
                return
            }
            
            // 데이터모델을, JSONDecoder로 decode코드로 구현 ⭐️
            do {
                let decoder = JSONDecoder()
                let catData = try decoder.decode([CatGetModel].self, from: safeData)
                print("파싱 성공 - \(catData)")
                completionHandler(catData)
                return
            } catch {
                print("⭐️파싱에러⭐️")
                return
            }
        }.resume()     // 시작
        
        
    }
    
    
    /// 즐겨찾기 추가하고 즐겨찾기한 녀석들 가져오기
    /// - Parameters:
    ///   - imageId:
    ///   - completionHandler: 즐겨찾기한 녀석들
    func addToFavoriteAndFetchFavorite(_ imageId: String, completionHandler: @escaping([FavoriteCatModel]) -> Void) {
        self.addToFavorite(imageId: imageId, completionHandler: { [weak self] () in
            guard let self = self else { return }
            self.fetchFavorites { (myFavorites : [FavoriteCatModel]) in
                completionHandler(myFavorites)
            }
        })
    }
    
    // MARK: - 즐겨찾기 추가한 것 패치하기
    func fetchFavorites(completionHandler: @escaping([FavoriteCatModel]) -> Void) {
        // URL구조체 만들기
        guard let url = URL(string: NetworkManager.FAVORITE_URL ) else {
            print("Error: cannot create URL")
            return
        }
        
        // URL요청 생성
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(NetworkManager.api, forHTTPHeaderField: NetworkManager.apiHeaderField)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입 JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입 JSON
        
        // 요청을 가지고 작업세션시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 에러가 없어야 넘어감
            guard error == nil else {
                print("Error: error calling GET")
                print("⭐️에러⭐️")
                print(error!)
                return
            }
            
            // 옵셔널 바인딩
            guard let safeData = data else {
                print("Error: Did not receive data")
                print("⭐️데이터에러⭐️")
                return
            }
            
            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print("⭐️통신에러⭐️")
                return
            }
            
            // 데이터모델을, JSONDecoder로 decode코드로 구현 ⭐️
            do {
                let decoder = JSONDecoder()
                let catData = try decoder.decode([FavoriteCatModel].self, from: safeData)
                print("파싱 성공 - \(catData)")
                completionHandler(catData)
                return
            } catch {
                print("fetchFavorites - ⭐️파싱에러⭐️")
                return
            }
        }.resume()
        
    }
    
    // MARK: - 즐겨찾기 추가
    func addToFavorite(imageId: String,  completionHandler: @escaping() -> Void) {
        
//    https://api.thecatapi.com/v1/favourites

        // URL구조체 만들기
        guard let url = URL(string: NetworkManager.FAVORITE_URL ) else {
            print("Error: cannot create URL")
            return
        }
        
        // URL요청 생성
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        request.setValue(NetworkManager.api, forHTTPHeaderField: NetworkManager.apiHeaderField)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type") // 요청타입 JSON
        request.setValue("application/json", forHTTPHeaderField: "Accept") // 응답타입 JSON
        
        // 파라미터 생성
        let params = ["image_id": imageId]
        
        print("imageId: \(imageId)")
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else {
            return
        }
        
        request.httpBody = httpBody
        
        // 요청을 가지고 작업세션시작
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            // 에러가 없어야 넘어감
            guard error == nil else {
                print("Error: error calling GET")
                print("⭐️에러⭐️")
                print(error!)
                return
            }
            
            // 옵셔널 바인딩
            guard let safeData = data else {
                print("Error: Did not receive data")
                print("⭐️데이터에러⭐️")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: safeData, options: [])
                print(json)
            } catch {
                print(error)
            }
            
            
            // HTTP 200번대 정상코드인 경우만 다음 코드로 넘어감
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("Error: HTTP request failed")
                print("⭐️통신에러⭐️")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: safeData, options: [])
            } catch {
                print(error)
            }
            
            // 🍎 네트워크 터트리는 코드
            completionHandler()
            
        }.resume()
        
    }
    
}
