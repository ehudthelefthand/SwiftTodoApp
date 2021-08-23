//
//  AddGroupViewController.swift
//  TodoApp
//
//  Created by Peerawat Poombua on 23/8/2564 BE.
//

import UIKit


protocol AddGroupViewControllerDelegate: AnyObject {
    func addGroupViewControllerDidCancel(_ controller: AddGroupViewController)
    func addGroupViewController(_ controller: AddGroupViewController, didFinishAdding item: GroupItem)
    func addGroupViewController(_ controller: AddGroupViewController, didFinishEditing item: GroupItem)
}

class AddGroupViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var groupText: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    var delegate: AddGroupViewControllerDelegate?
    var groupToEdit: GroupItem?
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.addGroupViewControllerDidCancel(self)
    }
    
    @IBAction func done(_ sender: Any) {
        delegate?.addGroupViewController(self, didFinishAdding: GroupItem(name: groupText.text!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        doneButton.isEnabled = false
    }
    
    // MARK: - Text Field delegate
    
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
