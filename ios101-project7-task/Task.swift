//
//  Task.swift
//

import UIKit

// The Task model
struct Task: Codable {

    // The task's title
    var title: String

    // An optional note
    var note: String?

    // The due date by which the task should be completed
    var dueDate: Date

    // Initialize a new task
    // `note` and `dueDate` properties have default values provided if none are passed into the init by the caller.
    init(title: String, note: String? = nil, dueDate: Date = Date()) {
        self.title = title
        self.note = note
        self.dueDate = dueDate
    }

    // A boolean to determine if the task has been completed. Defaults to `false`
    var isComplete: Bool = false {

        // Any time a task is completed, update the completedDate accordingly.
        didSet {
            if isComplete {
                // The task has just been marked complete, set the completed date to "right now".
                completedDate = Date()
            } else {
                completedDate = nil
            }
        }
    }

    // The date the task was completed
    // private(set) means this property can only be set from within this struct, but read from anywhere (i.e. public)
    private(set) var completedDate: Date?

    // The date the task was created
    // This property is set as the current date whenever the task is initially created.
    let createdDate: Date = Date()

    // An id (Universal Unique Identifier) used to identify a task.
    let id: String = UUID().uuidString
}

// MARK: - Task + UserDefaults
extension Task {

    // Given an array of tasks, encodes them to data and saves to UserDefaults.
    static func save(_ tasks: [Task]) {
        
        let encoder = JSONEncoder()
        // TODO: Save the array of tasks
        
        do {
            let jsonTaskData = try encoder.encode(tasks)
            UserDefaults.standard.set(jsonTaskData, forKey: "tasks")
        } catch {
            print("Task encoding error: \(error)")
        }
    }

    // Retrieve an array of saved tasks from UserDefaults.
    static func getTasks() -> [Task] {
        
        // TODO: Get the array of saved tasks from UserDefaults
        guard let jsonData = UserDefaults.standard.data(forKey: "tasks") else {
            return []
        }
        
        let decoder = JSONDecoder()
        
        do {
            return try decoder.decode([Task].self, from: jsonData)
        } catch {
            print("Failed to decode tasks: \(error)")
            return []
        }

    }

    // Add a new task or update an existing task with the current task.
    func save() {

        // TODO: Save the current task
        var tasks = Task.getTasks()
        
        if let index = tasks.firstIndex(where: { $0.id == self.id }) {
            tasks.remove(at: index)
            tasks.insert(self, at: index)
        } else {
            tasks.append(self)
        }
        
        Task.save(tasks)
    }
}
