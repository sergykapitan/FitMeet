//
//  CoreDataManager.swift
//  FitMeet
//
//  Created by novotorica on 29.04.2021.
//

import Foundation
import CoreData

final class CoreManager {
    
    static let shared = CoreManager()
    private init() {}
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "CoreDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescrip, err) in
            if let error = err {
                fatalError(error.localizedDescription)
            }
        })
        
        return container
    }()

    //MARK: Save
    func save(id:Int,phone: Int,email: String,login: String,name: String) {
        
        let entity = NSEntityDescription.entity(forEntityName: "CoreUser", in: context)!
        let core = CoreUser(entity: entity, insertInto: context)
        //KVC - Key Value Coding - access object property by String
        core.setValue(id, forKey: "id")
        core.setValue(phone, forKey: "phone")
        core.setValue(email, forKey: "email")
        core.setValue(login, forKey: "login")
        core.setValue(name, forKey: "name")
        print("Saved Fact To Core")
        saveContext()
    }

    //MARK: Delete
    
    func deleteText(id:Int,phone: Int,email: String,login: String,name: String) {
    
        let fetchRequest = NSFetchRequest<CoreUser>(entityName: "CoreUser")
        let predicate = NSPredicate(format: "searchText==%@", id)
        
        fetchRequest.predicate = predicate
        var trackResult = [CoreUser]()
        
        do {
            trackResult = try context.fetch(fetchRequest)
            guard let core = trackResult.first else { return }
            context.delete(core)
            
        } catch {
            print("Couldn't Fetch Fact: \(error.localizedDescription)")
        }
        
        saveContext()
    }

    //MARK: Load
    //func history() -> [History]
    func history() -> Int32 {
        
        let fetchRequest = NSFetchRequest<CoreUser>(entityName: "CoreUser")
        var id: Int32 = 0
    
    do {
        let coreTracks = try context.fetch(fetchRequest)
        for core in coreTracks {
            id = core.id
           // history.append(History(searchText: core.searchText))
        }
    } catch {
        print("Couldn't Fetch Fact: \(error.localizedDescription)")
    }
    return id
    
    }
    //MARK: Helpers
    
    private func saveContext() {
        do {
            try context.save()
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
}
