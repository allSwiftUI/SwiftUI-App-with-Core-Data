// -----------------------------------------------------------------------------
// File: ContentView.swift
// Package: CoreDataDemo
//
// Created by: ALLSWIFTUI on 17-07-20
// Copyright © 2020 allSwiftUI · https://allswiftui.com · @allswiftui
// -----------------------------------------------------------------------------

import SwiftUI

//MARK: - ContentView
struct ContentView: View {
    // We're retrieve the managed object context
    @Environment(\.managedObjectContext) var managedObjectContext
    
    // We're retrieves the entity and your data from a Core Data Store and store in the variable 'cats'
    @FetchRequest(
        entity: Cats.entity(),
        sortDescriptors: [
            NSSortDescriptor(keyPath: \Cats.createAt, ascending: false)
        ]
    ) var cats: FetchedResults<Cats>
    
    @State private var showSheet: Bool = false
    @State private var catName: String = ""
    @State private var createAt: Date = Date()
    
    static let releaseFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("SwiftUI Life Cycle App with Core Data").font(.subheadline).foregroundColor(.blue)
                List {
                    ForEach(cats, id:\.self) { cat in
                        VStack(alignment: .leading) {
                            Text("Name: \(Text(cat.name!).foregroundColor(.blue))").foregroundColor(.gray)
                            Text("Created at: \(Text(ContentView.releaseFormatter.string(from: cat.createAt!)).foregroundColor(.red))")
                        }
                    }.onDelete { indexSet in
                        DeleteCatFromList(at: indexSet)
                    }
                }
                .sheet(isPresented: $showSheet) {
                    Form {
                        Section(header: Text("Cat name")) {
                            TextField("Name", text: $catName)
                        }
                        Section {
                            DatePicker(
                                selection: $createAt,
                                displayedComponents: .date) {
                                Text("Create Date").foregroundColor(Color(.gray))
                            }
                        }
                        Section {
                            Button(action: {
                                AddCatToList(name: catName, create: createAt)
                                showSheet.toggle()
                            }) {
                                Text("Add Cat")
                            }.disabled(catName.isEmpty)
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Cats"))
            .navigationBarItems(trailing: Button(action: { showSheet.toggle() }) {
                Text(Image(systemName: "plus.circle.fill")).font(.title)
            })
        }
    }
    
    // We add a Cat to the list by retrieving the entity associated with the managed object context, modify the attributes of the entity and call saveContext to persist the changes.
    func AddCatToList(name: String, create: Date) {
        let newCat = Cats(context: managedObjectContext)
        newCat.name = catName
        newCat.createAt = createAt
        
        CoreDataStack.saveContext()
    }
    
    // We erase the Cat object by retrieving it by its index and then we call saveContext to persist the changes
    func DeleteCatFromList(at offset: IndexSet) {
        offset.forEach {index in
            let cat = cats[index]
            managedObjectContext.delete(cat)
            CoreDataStack.saveContext()
        }
    }
}

//MARK: - ContentView Previews
// We passed the managed object context for that our preview to work OK!
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, CoreDataStack.context)
    }
}
