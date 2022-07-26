//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootcamp
//
//  Created by Sorawit Trutsat on 26/7/2565 BE.
//

import SwiftUI

/*
Topics include:
1) Structs vs Classes vs Actors
2) Value vs Reference Types
3) Stack vs Heap memory
4) Automatic Reference Counting (ARC) in Swift
5) Weak vs Strong References
 
 VALUE TYPES:
 - Struct, Enum, String, Int, etc.
 - Stored in the Stack
 - Faster
 - Thread safe!
 - When you assign or pass value type a new copy of data is created
 
 REFERENCE TYPES:
 - Class, Function, Actor
 - Stored in the Heap
 - Slower, but synchronized
 - NOT Thread safe!
 - When you assign or pass reference type a new reference to original instance will be created (pointer)
 
 STACK:
 - Stored Value types
 - Variables allocated on the stack are stored directly to the memory, and access to this memory is very fast.
 - Each thread has it's own stack!
 
 HEAP:
 - Stored Reference types
 - Shared across threads!

 
 STRUCT:
 - Based on VALUES
 - Can be mutated (immutated by default)
 - Stored in the Stack!
 
 CLASS:
 - Based on REFERENCE (INSTANCES)
 - Stored in the Heap!
 - Inherit from other classes
 
 ACTOR:
 - Same as Class, but Thread safe!
 
 
 Structs: Data Models, Views (SwiftUI)
 Classes: ViewModels
 Actors: Shared 'Manager' and 'Data Store'
 

Links:
- https://blog.onewayfirst.com/ios/post...
- https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language
- https://medium.com/@vinayakkini/swift-basics-struct-vs-class-31b44ade28ae
- https://stackoverflow.com/questions/24217586/structure-vs-class-in-swift-language/59219141#59219141
- https://stackoverflow.com/questions/27441456/swift-stack-and-heap-understanding
- https://stackoverflow.com/questions/24232799/why-choose-struct-over-class/24232845
- https://www.backblaze.com/blog/whats-the-diff-programs-processes-and-threads/
- https://medium.com/doyeona/automatic-reference-counting-in-swift-arc-weak-strong-unowned-925f802c1b99
*/

class ViewModelKong: ObservableObject {
    let title: String
    
    init() {
        self.title = "vm title"
        print("XD vm init")
    }
}
struct KongView: View {
    @StateObject var vm = ViewModelKong()
    var isActive: Bool
    init(isActive: Bool) {
        self.isActive = isActive
        print("XD init view")
    }
    var body: some View {
        Text("Kong")
            .background(isActive ? Color.green : Color.red)
            .frame(width: 200, height: 200, alignment: .center)
    }
}

struct StructClassActorBootcamp: View {
    @State var isActive: Bool = false
    var body: some View {
        KongView(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

struct StructClassActorBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp()
    }
}

struct MyStruct {
    var title: String
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func changeTitle(title: String) {
        self.title = title
    }
}

actor MyActor {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func changeTitle(title: String) {
        self.title = title
    }
}

struct CustomStruct {
    var title: String
    
    mutating func changeTitle(title: String) {
        self.title = title
    }
}

extension StructClassActorBootcamp {
    private func runTest() {
        print("test started")
    }
    
    private func runStructTest() {
        let objectA = MyStruct(title: "starting title")
        print("ObjectA \(objectA.title)")
        
        var objectB = objectA
        print("ObjectB \(objectB.title)")
        
        objectB.title = "changed title"
        print(objectB)
    }
    
    private func runClassTest() {
        let objectA = MyClass(title: "starting title")
        print("ObjectA \(objectA.title)")
        
        let objectB = objectA
        objectB.title = "changed title"
        print("ObjectA \(objectA.title)")
        print("ObjectB \(objectB.title)")
    }
    
    private func runActorTest() {
        Task {
            let objectA = MyActor(title: "starting title")
            await print("ObjectA \(objectA.title)")
            
            let objectB = objectA
            await objectB.changeTitle(title: "kong")
            await print("ObjectA \(objectA.title)")
            await print("ObjectB \(objectB.title)")
        }
    }
}
