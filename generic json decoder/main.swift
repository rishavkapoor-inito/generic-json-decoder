//
//  main.swift
//  jsondecoder
//
//  Created by User on 07/08/25.
//

import Foundation

let fileURL = URL(fileURLWithPath: "/Users/user/Documents/ios/generics task/generic json decoder/data1.json")

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


enum Payload: Decodable {
    case data(DataSuccess)
    case dataUsers([DataUsers])
    case error(String)
}

struct PayloadFailure: Decodable {
    let error: String
}
struct PayloadSuccess: Decodable {
    let data: DataSuccess
}
struct PayloadUsers: Decodable {
    let data: [DataUsers]
}

struct Response<T: Decodable>: Decodable {
    let meta: Meta
    let payload: T
}

func decodeJSON() {
    do {
        let data = try Data(contentsOf: fileURL)
        if let successResponse = try? JSONDecoder().decode(Response<PayloadSuccess>.self, from: data){
            let meta = successResponse.meta
            let payload = successResponse.payload.data
            print("Request Id: \(meta.requestId)")
            print("Login Response: \(payload)")
            print("")
        } else if let failureResponse = try? JSONDecoder().decode(Response<PayloadFailure>.self, from: data){
            let meta = failureResponse.meta
            let payload = failureResponse.payload.error
            print("Request Id: \(meta.requestId)")
            print("Error: \(payload)")
            print("")
        } else if let usersResponse = try? JSONDecoder().decode(Response<PayloadUsers>.self, from: data){
            let meta = usersResponse.meta
            let payload = usersResponse.payload.data
            print("Request Id: \(meta.requestId)")
            print("Users data: \(payload)")
            print("")
        }
        
    } catch {
        print("Error decoding JSON: \(error.localizedDescription)")
    }
    
}

decodeJSON()
