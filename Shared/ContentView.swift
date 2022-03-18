//
//  ContentView.swift
//  Shared
//
//  Created by Dan Hart on 3/18/22.
//

import SwiftUI
import Splash

struct ContentView: View {
    var font: Splash.Font {
        .init(size: 18)
    }
    
    var theme: Splash.Theme {
        .presentation(withFont: font)
    }
    
    var highlighter: Splash.SyntaxHighlighter<AttributedStringOutputFormat> {
        SyntaxHighlighter(format: AttributedStringOutputFormat(theme: theme))
    }
    
    let text =
    """
    //
    //  CoreDataStack.swift
    //  FoodTracker
    //
    //  Created by Dan Hart on 2/13/19.
    //  Copyright © 2019 Dan Hart. All rights reserved.
    //
    import Foundation
    import CoreData
    
    /// This class provides a wrapper for Apple's CoreData elements
    class CoreDataStack {
        // MARK: - Core Data stack
        static var persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "FoodTrackerModels")
            container.loadPersistentStores(completionHandler: { (_, error) in
            })
            return container
        }()
        static var managedContext: NSManagedObjectContext = {
            return CoreDataStack.persistentContainer.viewContext
        }()
    
        // MARK: - Core Data Saving support
        /// Using the current Core Data persistent container, save the current context if there are changes
        ///
        /// - Returns: True if the context was saved, false if the context was not saved
        static func saveContext() -> Bool {
            let context = CoreDataStack.persistentContainer.viewContext
            if context.hasChanges {
                do {
                    try context.save()
                    return true
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this
                    // function in a shipping application, although it may be useful during development.
                    let nserror = error as NSError
                }
            }
            return false
        }
    
        // MARK: - Retrieve Data
        /// Retrieve all data matching the entity string
        ///
        /// - Parameter entity: string specifying the entity name
        /// - Returns: an NSManagedObject array of all the elements matching the entity name
        static func retrieveAll(for entity: String) -> [NSManagedObject] {
            let fetchRequest =
                NSFetchRequest<NSManagedObject>(entityName: entity)
    
            do {
                let result = try CoreDataStack.managedContext.fetch(fetchRequest)
                return result
            } catch let error as NSError {
            }
    
            return [NSManagedObject]()
        }
    
        // MARK: - Danger Zone
        /// Delete all Core Data entries for the specified entity name
        ///
        /// - Parameter entity: Name of the object in which all elements should be deleted
        static func deleteAll(for entity: String) {
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
            fetchRequest.returnsObjectsAsFaults = false
            do {
                let results = try CoreDataStack.persistentContainer.viewContext.fetch(fetchRequest)
                for object in results {
                    guard let objectData = object as? NSManagedObject else {continue}
                    CoreDataStack.persistentContainer.viewContext.delete(objectData)
                }
            } catch let error {
            }
        }
    }
    """
    
    var body: some View {
        ScrollView([.horizontal, .vertical]) {
                ForEach(text.components(separatedBy: "\n"), id: \.self) { text in
                    NSASLabel { label in
                        label.attributedText = highlighter.highlight(text)
                    }
                }
                .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

struct NSASLabel: UIViewRepresentable {
    typealias TheUIView = UILabel
    fileprivate var configuration = { (view: TheUIView) in }
    
    func makeUIView(context: UIViewRepresentableContext<Self>) -> TheUIView { TheUIView() }
    func updateUIView(_ uiView: TheUIView, context: UIViewRepresentableContext<Self>) {
        configuration(uiView)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.light)
    }
}
