//
//  NetworkClient.swift
//  TextCharsCounter
//
//  Created by Vladyslav Pavelko on 10.11.2021.
//

import Foundation

final class NetworkClient {
    private let decoder = JSONDecoder()
    private let baseURL = URL(string: "http://apiecho.cf")!

    func performSignUp(name: String, email: String, password: String, completion: @escaping (Result<AuthResponse, DataResponseError>) -> Void) {
        let parameters = SignUpRequestParameters(name: name, email: email, password: password)
        let signUpRequest = SignUpRequest(parameters: parameters)
        fetchData(with: signUpRequest, type: AuthResponse.self, completion: completion)
    }

    func performSignIn(email: String, password: String, completion: @escaping (Result<AuthResponse, DataResponseError>) -> Void) {
        let parameters = LoginEmailRequestParameters(email: email, password: password)
        let loginEmailRequest = LoginEmailRequest(parameters: parameters)
        fetchData(with: loginEmailRequest, type: AuthResponse.self, completion: completion)
    }
    
    func performGetText(localeCode: String, completion: @escaping (Result<TextSampleResponse, DataResponseError>) -> Void) {
        let parameters = GetTextRequestParameters(locale: localeCode)
        let getTextRequest = GetTextRequest(parameters: parameters)
        fetchData(with: getTextRequest, type: TextSampleResponse.self, completion: completion)
    }

    private func fetchData<T: Codable, RequestType: Requestable>(with request: RequestType, type: T.Type, completion: @escaping (Result<T, DataResponseError>) -> Void) {
        let urlRequest = try! request.urlRequest(baseURL: baseURL)

        let task = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }

            guard let decodedResponse = try? JSONDecoder().decode(type.self, from: data) else {
                DispatchQueue.main.async {
                    completion(Result.failure(DataResponseError.decoding))
                }
//                guard let object = try? JSONSerialization.jsonObject(with: data, options: []),
//                              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
//                              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
//                print("prettyPrintedString \(prettyPrintedString)")
                return
            }
            DispatchQueue.main.async {
                completion(Result.success(decodedResponse))
            }
        }

        task.resume()
    }
}
