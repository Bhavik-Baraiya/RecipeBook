//
//  SwiftDataManager.swift
//  RecipeBook
//
//  Created by Bhavik Baraiya on 25/04/25.
//

import SwiftData
import SwiftUI

class DataManager {
    
    private var modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    public func insert(data: RecipeData) {
        modelContext.insert(data)
        do {
            try modelContext.save()
        } catch {
            print(error)
        }
    }
    
    public func fetch() -> [RecipeData] {
        do {
            let descriptor = FetchDescriptor<RecipeData>()
            return try modelContext.fetch(descriptor)
        } catch {
            print("Fetch failed with error: \(error)")
            return []
        }
    }
    
    public func delete(data: RecipeData) {
        return modelContext.delete(data)
    }
}
