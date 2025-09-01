//
//  BaseNetworkService.swift
//  Image_Arithmetic
//
//  Created by Carki on 9/1/25.
//

import UIKit

import Alamofire

class BaseNetworkService {
    let session: Session = {
        let configuration = URLSessionConfiguration.af.default
        configuration.timeoutIntervalForRequest = 5 * 60
        configuration.waitsForConnectivity = true
        
        return Session(
            configuration: configuration
        )
    }()
}

extension BaseNetworkService {
    func request<T>(
        _ host: String,
        url: String,
        auth: Bool? = nil,
        method: HTTPMethod,
        headers requestHeaders: [String: String]? = nil,
        parameters: Parameters? = nil,
        httpBody: Any? = nil
    ) async -> Result<T, APIError> where T: Codable {
        var headers: HTTPHeaders = HTTPHeaders()
        headers.add(name: "content-Type", value: "application/json")
        headers.add(name: "accept", value: "application/json")
        
        if let headerItems = requestHeaders {
            headerItems.forEach { (key: String, value: String) in
                headers.add(name: key, value: value)
            }
        }
        
        let baseURL = host + url
        var request = self.session
            .request(baseURL, method: method, parameters: parameters, encoding: URLEncoding.queryString, headers: headers)
            .cURLDescription { description in
                print(description)
            }
        
        
        if let data = httpBody, var req = try? request.convertible.asURLRequest() {
            if let body = try? JSONSerialization.data(withJSONObject: data, options: []) {
                req.httpBody = body
            }
            req.timeoutInterval = 5 * 60
            request = AF.request(req)
                .cURLDescription { description in
                    print(description)
                }
        }
        
        let dataTask = request
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
        
        return handleResponse(await dataTask.response)
    }
    
    func upload<T: Codable>(
        _ host: String,
        url: String,
        fileData: Data,
        fileName: String? = nil,                
        mimeType: String = "image/png",
        method: HTTPMethod = .post,
        headers requestHeaders: [String: String]? = nil
    ) async -> Result<T, APIError> {
        
        let baseURL = host + url
        var headers: HTTPHeaders = [:]
        
        if let headerItems = requestHeaders {
            headerItems.forEach { headers.add(name: $0.key, value: $0.value) }
        }
        
        // 파일명이 없으면 UUID 기반 자동 생성
        let finalFileName = fileName ?? UUID().uuidString + ".png"
        
        let uploadRequest = self.session.upload(
            multipartFormData: { formData in
                formData.append(
                    fileData,
                    withName: "file",         // 서버에서 기대하는 key 값
                    fileName: finalFileName,  // 로그용 파일명
                    mimeType: mimeType
                )
            },
            to: baseURL,
            method: method,
            headers: headers
        )
            .cURLDescription { print($0) }
            .validate(statusCode: 200..<300)
            .serializingDecodable(T.self)
        
        return handleResponse(await uploadRequest.response)
    }
    
    private func handleResponse<T: Codable>(_ response: DataResponse<T, AFError>) -> Result<T, APIError> {
        switch response.result {
        case .success(let value):
            return .success(value)
        case .failure(let error):
            print("------------🔺FAIL🔺------------")
            print("🔺\(error)")
            print("---------------------------------")
            if let data = response.data, !data.isEmpty {
                return .failure(APIError.AFERROR)
            }
            return .failure(APIError.UNKNOWN)
        }
    }
}
