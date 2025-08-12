//
//  main.swift
//  jsondecoder
//
//  Created by User on 07/08/25.
//

import Foundation

let fileURL = URL(fileURLWithPath: "/Users/user/Documents/ios/generics task/generic json decoder/data4.json")

struct Meta: Decodable {
    let requestId: String
    let timestamp: String
}

struct DataSuccess: Decodable {
    let token: String
    let userId: Int
}

struct DataUsers: Decodable {
    let id: Int
    let name: String
}

enum ResultWrapper<T: Decodable>: Decodable {
    case success(T)
    case failure(String)

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let data = try? container.decode(T.self, forKey: .data) {
            self = .success(data)
        } else if let errorMessage = try? container.decode(String.self, forKey: .error) {
            self = .failure(errorMessage)
        } else {
            throw DecodingError.dataCorruptedError(forKey: .data, in: container, debugDescription: "Neither data nor error found")
        }
    }

    private enum CodingKeys: String, CodingKey {
        case data
        case error
    }
}

struct Response<T: Decodable>: Decodable {
    let meta: Meta
    let payload: ResultWrapper<T>
}

func decodeJSON() {
    do {
        let data = try Data(contentsOf: fileURL)
        if let loginResponse = try? JSONDecoder().decode(Response<DataSuccess>.self, from: data) {
                    print("Request Id: \(loginResponse.meta.requestId)")
                    switch loginResponse.payload {
                    case .success(let loginData):
                        print("Login Response: \(loginData)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    return
                }

        if let usersResponse = try? JSONDecoder().decode(Response<[DataUsers]>.self, from: data) {
                    print("Request Id: \(usersResponse.meta.requestId)")
                    switch usersResponse.payload {
                    case .success(let users):
                        print("Users data: \(users)")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
        
    } catch {
        print("Error decoding JSON: \(error.localizedDescription)")
    }
    
}

decodeJSON()

