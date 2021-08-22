//
//  AddTodoTableViewController.swift
//  TodoApp
//
//  Created by pairco on 12/8/2564 BE.
//

import UIKit


protocol AddTodoViewControllerDelegate: AnyObject {
    func addTodoViewControllerDidCancel(_ controller: AddTodoViewController)
    func addTodoViewController(_ controller: AddTodoViewController, didFinishAdding item: TodoItem)
    func addTodoViewController(_ controller: AddTodoViewController, didFinishEditing item: TodoItem)
}

class AddTodoViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var todoText: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    weak var delegate: AddTodoViewControllerDelegate?
    var itemToEdit: TodoItem?

    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.text = todoText.text!
            delegate?.addTodoViewController(self, didFinishEditing: item)
        } else {
            let item = TodoItem(text: todoText.text!)
            delegate?.addTodoViewController(self, didFinishAdding: item)
        }
    }

    @IBAction func cancel(_ sender: Any) {
        itemToEdit = nil
        delegate?.addTodoViewControllerDidCancel(self)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        if let item = itemToEdit {
            title = "Edit Item"
            todoText.text = item.text
            doneButton.isEnabled = true
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        todoText.becomeFirstResponder()
    }

    // MARK: - TextField

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText = textField.text!
        let stringRange = Range(range, in: oldText)!
        let newText = oldText.replacingCharacters(in: stringRange, with: string)
        if newText.isEmpty {
            doneButton.isEnabled = false
        } else {
            doneButton.isEnabled = true
        }
        return true
    }

    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneButton.isEnabled = false
        return true
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
