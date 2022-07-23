//
//  AsyncAwaitBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Sorawit Trutsat on 23/7/2565 BE.
//

import SwiftUI

class AsyncAwaitBootcampViewModel: ObservableObject {
    @Published var dataList: [String] = []
    
    func addTitle1() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.dataList.append("Title1: \(Thread.current)")
        }
    }
    
    func addTitle2() {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let title = "Title2: \(Thread.current)"
            DispatchQueue.main.async {
                self.dataList.append(title)
            }
        }
    }
    
    func addAuthor1() async {
        let author1 = "Author1: \(Thread.current)"
        self.dataList.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        let author2 = "Author2: \(Thread.current)"
        
        await MainActor.run {
            self.dataList.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataList.append(author3)
        }
    }
}

struct AsyncAwaitBootcamp: View {
    @StateObject private var viewModel = AsyncAwaitBootcampViewModel()
    var body: some View {
        List {
            ForEach(viewModel.dataList, id: \.self) { data  in
                Text(data)
            }
        }.onAppear {
            // viewModel.addTitle1()
            // viewModel.addTitle2()
            Task {
                await viewModel.addAuthor1()
            }
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
