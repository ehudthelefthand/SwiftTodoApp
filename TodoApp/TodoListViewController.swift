//
//  ViewController.swift
//  TodoApp
//
//  Created by pairco on 28/7/2564 BE.
//

import UIKit

class TodoItem {
    var text: String
    var done: Bool

    init(text: String, done: Bool = false) {
        self.text = text
        self.done = done
    }
}

class TodoListViewController: UITableViewController {

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
    }
    
    @IBAction func addItem(_ sender: Any) {
        let index = items.count
        items.append(TodoItem(text: "New Item!"))
        let indexPath = IndexPath(row: index, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
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
    }

    func configureText(for cell: UITableViewCell, with item: TodoItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }

    func configureCheckmark(for cell: UITableViewCell, with item: TodoItem) {
        if item.done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
}

