//
//  GroupViewController.swift
//  TodoApp
//
//  Created by Peerawat Poombua on 22/8/2564 BE.
//

import UIKit

class GroupItem: NSObject {
    var name: String
    
    init(name: String) {
        self.name = name
    }
}

class GroupViewController: UITableViewController, AddGroupViewControllerDelegate {

    var groups: [GroupItem] = {
        var list = [GroupItem]()
        list.append(GroupItem(name: "Benya"))
        list.append(GroupItem(name: "Peerawat"))
        list.append(GroupItem(name: "Future Work"))
        list.append(GroupItem(name: "Banking Reminder"))
        return list
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupItem", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = groups[indexPath.row].name
        return cell
    }
    

    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddGroup" {
            let controller = segue.destination as! AddGroupViewController
            controller.delegate = self
        } else if segue.identifier == "EditGroup" {
            let controller = segue.destination as! AddGroupViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.groupToEdit = groups[indexPath.row]
            }
        }
    }
    
    
    // MARK: - AddGroupViewControllerDelegate
    
    func addGroupViewControllerDidCancel(_ controller: AddGroupViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addGroupViewController(_ controller: AddGroupViewController, didFinishAdding item: GroupItem) {
        let newRowIndex = groups.count
        groups.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func addGroupViewController(_ controller: AddGroupViewController, didFinishEditing item: GroupItem) {
        
    }
}
