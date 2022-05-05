//
//  Router.swift
//  CityXcape
//
//  Created by James Allan on 5/1/22.
//

import Foundation



class Router: ObservableObject {
    
    static let shared = Router()
    private init(){}
    @Published var postId: String?
    @Published var link: DeepLink?
    
    func handleUrl(url: URL) {
        guard let components = NSURLComponents(url: url, resolvingAgainstBaseURL: true),
              let items = components.query
              else {return}
        let arrays = items.components(separatedBy: "&")
        let scheme = arrays[2]
        let schemeComponent = scheme.components(separatedBy: "//")
        let host = schemeComponent[1]
        let id = schemeComponent[2]
        postId = id
        link = .init(rawValue: host)
    }
}
