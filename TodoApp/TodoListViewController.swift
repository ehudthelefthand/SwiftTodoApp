//
//  ViewController.swift
//  TodoApp
//
//  Created by pairco on 28/7/2564 BE.
//

import UIKit

class TodoItem: NSObject, Codable {
    var text: String
    var done: Bool

    init(text: String, done: Bool = false) {
        self.text = text
        self.done = done
    }
}

class TodoListViewController: UITableViewController, AddTodoViewControllerDelegate {

    var items: [TodoItem] = {
        var data = [TodoItem]()
        data.append(TodoItem(text: "Buy Milk"))
        data.append(TodoItem(text: "Do Homework"))
        data.append(TodoItem(text: "Practice TableView", done: true))
        data.append(TodoItem(text: "Kiss the ass"))
        data.append(TodoItem(text: "Kill the bear with bare hand"))
        return data
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        loadTodolist()
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoItem", for: indexPath)

        let item = items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.done.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)

        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        saveTodolist()
    }

    func configureText(for cell: UITableViewCell, with item: TodoItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func configureCheckmark(for cell: UITableViewCell, with item: TodoItem) {
        let checkmark = cell.viewWithTag(1001) as! UIImageView
        if item.done {
            checkmark.isHidden = false
        } else {
            checkmark.isHidden = true
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller  = segue.destination as! AddTodoViewController
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            let controller  = segue.destination as! AddTodoViewController
            controller.delegate = self

            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }


    // MARK: - Add Todo

    func addTodoViewControllerDidCancel(_ controller: AddTodoViewController) {
        navigationController?.popViewController(animated: true)
    }

    func addTodoViewController(_ controller: AddTodoViewController, didFinishAdding item: TodoItem) {
        let newRowIndex = items.count
        items.append(item)

        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveTodolist()
    }

    func addTodoViewController(_ controller: AddTodoViewController, didFinishEditing item: TodoItem) {
        if let row = items.firstIndex(of: item) {
            if let cell = tableView.cellForRow(at: IndexPath(row: row, section: 0)) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveTodolist()
    }

    // MARK: - Save Data

    func saveTodolist() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(
                to: dataFilePath(),
                options: Data.WritingOptions.atomic
            )
        } catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }

    func loadTodolist() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                items = try decoder.decode(
                    [TodoItem].self,
                    from: data
                )
            } catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Todolist.plist")
    }

}
