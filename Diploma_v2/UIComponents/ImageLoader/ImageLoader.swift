//
//  ImageLoader.swift
//  Diploma_v2
//
//  Created by Алексей Даневич on 02.02.2023.
//

import SwiftUI
import Combine

class ImageLoader: ObservableObject {
    private(set) lazy var didChange = PassthroughSubject<Data, Never>()
    private(set) lazy var onError = PassthroughSubject<Void, Never>()

    var data = Data() {
        didSet {
            didChange.send(data)
        }
    }

    init(urlString:String) {
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        task.resume()
    }
}
