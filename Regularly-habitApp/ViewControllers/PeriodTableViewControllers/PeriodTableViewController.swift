//
//  PeriodTableViewController.swift
//  Regularly-habitApp
//
//  Created by Leonardo Prasetyo on 29/5/2023.
//

import UIKit

protocol SelectedPeriodDelegate: AnyObject {
    func setSelectedPeriod(_ selectedPeriod: [String])
}

//Table View controller when user pressed "Choose Period" on AddHabitViewController
class PeriodTableViewController: UITableViewController {
    
    weak var delegate: SelectedPeriodDelegate?
    var selectedItems: [Int] = []
    var items = ["Every Monday", "Every Tuesday", "Every Wednesday","Every Thursday", "Every Friday", "Every Saturday", "Every Sunday"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let periodCell = tableView.dequeueReusableCell(withIdentifier: "periodCell", for: indexPath) as? PeriodTableViewCell{
            periodCell.setTitle(title: items[indexPath.row])
            periodCell.accessoryType = self.selectedItems.contains(indexPath.row) ? .checkmark : .none
            periodCell.backgroundColor = self.selectedItems.contains(indexPath.row) ? UIColor.systemTeal : UIColor.clear
            return periodCell
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //update selectedItems
        if selectedItems.contains(indexPath.row){
            let index = self.selectedItems.firstIndex(of: indexPath.row)
            self.selectedItems.remove(at: index!)
        }else{
            self.selectedItems.append(indexPath.row)
        }
        
        var selectedPeriod: [String] = []
        for index in selectedItems{
            let item = items[index]
            selectedPeriod.append(item)
        }
        delegate?.setSelectedPeriod(selectedPeriod)
        tableView.reloadData()
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
