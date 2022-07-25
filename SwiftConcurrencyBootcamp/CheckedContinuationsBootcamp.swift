//
//  CheckedContinuationsBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Sorawit Trutsat on 25/7/2565 BE.
//

import SwiftUI

class CheckedContinuationsBootcampNetworkManager {
    func getData(url: URL) async throws -> Data {
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        return try await withCheckedThrowingContinuation { continuation in
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    continuation.resume(returning: data)
                } else if let error = error {
                    continuation.resume(throwing: error)
                } else {
                    continuation.resume(throwing: URLError(.cancelled))
                }
            }
            .resume()
        }
    }
    
    func getHeartImageFromDatabase(completion: @escaping (_ image: UIImage) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
            completion(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImage() async -> UIImage {
        return await withCheckedContinuation { continuation in
            self.getHeartImageFromDatabase { image in
                continuation.resume(returning: image)
            }
        }
    }
}

class CheckedContinuationsBootcampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationsBootcampNetworkManager()
    
    func getImage() async {
        guard let url = URL(string: "https://picsum.photos/200") else { return }
        do {
            let data = try await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getHeartImage() {
        networkManager.getHeartImageFromDatabase { [weak self] image in
            self?.image = image
        }
    }
    
    func getHeartImageAsync() async {
        let image = await networkManager.getHeartImage()
        self.image = image
    }
}

struct CheckedContinuationsBootcamp: View {
    @StateObject private var viewModel = CheckedContinuationsBootcampViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200, alignment: .center)
            }
        }
        .task {
            // await viewModel.getImage()
            // viewModel.getHeartImage()
            await viewModel.getHeartImageAsync()
        }
    }
}

struct ContinuationsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckedContinuationsBootcamp()
    }
}
