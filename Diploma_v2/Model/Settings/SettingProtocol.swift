//
//  SettingProtocol.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 12.04.2023.
//

import Foundation

protocol SettingProtocol {
    var title: String { get }
    var hasNextPage: Bool { get }
    var imageName: String? { get }
}
