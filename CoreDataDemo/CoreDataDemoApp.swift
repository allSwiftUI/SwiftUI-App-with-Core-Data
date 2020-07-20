// -----------------------------------------------------------------------------
// File: CoreDataDemoApp.swift
// Package: CoreDataDemo
//
// Created by: ALLSWIFTUI on 17-07-20
// Copyright © 2020 allSwiftUI · https://allswiftui.com · @allswiftui
// -----------------------------------------------------------------------------

import SwiftUI

@main
struct CoreDataDemoApp: App {
    @Environment(\.scenePhase) private var scenePhase
    private let context = CoreDataStack.context
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, context)
        }
        .onChange(of: scenePhase ){ phase in
            switch phase {
            case .active:
                print("App active")
            case .inactive:
                print("App inactive")
            case .background:
                print("App in background")
                CoreDataStack.saveContext()
            default:
                print("App in unknown phase")
            }
        }
    }
}
