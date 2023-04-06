//
//  Auth.swift
//  vaporwave
//
//  Created by Kevin Bernfeld on 4/6/23.
//

import Foundation

struct ClientTokenResponse: Decodable {
    var token: String
}

struct AuthRequest: Encodable {
    var username: String
    var password: String
}
