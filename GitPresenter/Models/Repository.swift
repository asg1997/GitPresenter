//
//  Repository.swift
//  GitPresenter
//
//  Created by Максим on 05.08.2021.
//

import Foundation

struct Repository: Decodable {
    var id: Int
    var name: String
    var owner: Owner
    var description: String?
    var htmlUrl: URL
    
}
