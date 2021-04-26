//
//  APIError.swift
//  SMSTome.com
//
//  Created by Yousef on 4/13/21.
//

import Foundation

enum APIError: Error, LocalizedError {
    case unAuthenticated(data: Data?)
    case unAuthorized(data: Data?)
    case notFound(data: Data?)
    case methodNotAllowed(data: Data?)
    case internalServerError(data: Data?)
    case unknown(statusCode: Int, data: Data?, error: Error?)
    case decodingFailed(data: Data?, error: Error?)
    case invalidURL(url: String)
    
    init(rawValue: Int, data: Data?, error: Error?) {
        switch rawValue {
        case 401:
            self = .unAuthenticated(data: data)
        case 403:
            self = .unAuthorized(data: data)
        case 404:
            self = .notFound(data: data)
        case 405:
            self = .methodNotAllowed(data: data)
        case 500:
            self = .internalServerError(data: data)
        default:
            self = .unknown(statusCode: rawValue, data: data, error: error)
        }
    }
    
    var errorDescription: String? {
        switch self {
        case .unAuthenticated(_):
            return "Unexpected Error!, Please Try Again"
        case .unAuthorized(_):
            return "Unexpected Error!, Please Try Again"
        case .notFound(_):
            return "Unexpected Error!, Please Try Again"
        case .methodNotAllowed(_):
            return "Unexpected Error!, Please Try Again"
        case .internalServerError(_):
            return "Unexpected Error!, Please Try Again"
        case .unknown(statusCode: let statusCode, _, _):
            return "Unexpected Error with code\(statusCode)!, Please Try Again"
        case .decodingFailed(_, _):
            return "Unexpected Error!, Please Try Again"
        case .invalidURL(_):
            return "Unexpected Error!, Please Try Again"
        }
    }
    
    var localizedDescription: String {
        errorDescription ?? "Unexpected Error!, Please Try Again"
    }
    
}
