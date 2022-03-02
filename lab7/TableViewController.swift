//
//  TableViewController.swift
//  lab7
//
//  Created by Arturo on 20/11/21.
//

import UIKit

class TableViewController: UITableViewController {
    
    var taskList = [String]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        
       let usrDefaults = UserDefaults.standard
        if !usrDefaults.bool(forKey: "firstRun"){
            usrDefaults.set(true, forKey: "firstRun")
            usrDefaults.set(0, forKey:"index")
        }
        
       loadTasks()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func addTask(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add Task", message: "Write the task you want to add.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addTextField { textField in
            textField.placeholder = "Write an Item/Task"
            textField.clearButtonMode = .whileEditing
            textField.keyboardType = .default
        }
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: {action in
            guard let textField = alert.textFields, textField.count==1 else {
                return
            }
            let taskField = textField[0]
            guard let task = taskField.text, !task.isEmpty else{
                return
            }
            self.saveTask(task: task)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func saveTask(task:String){
        
        let usrDefaults=UserDefaults.standard
        var index = (usrDefaults.value(forKey: "index") as? Int)!
        index+=1
        usrDefaults.set(index,forKey: "index")
        usrDefaults.set(task, forKey: "item\(index)")
        
       
        
        taskList.append(task)
        tableView.reloadData()
        
    }
    func loadTasks(){
        taskList.removeAll()
        
      
       let usrDefaults=UserDefaults.standard
        let index = (usrDefaults.value(forKey: "index") as? Int)!
        if index != 0 {
        for i in 1...index{
            if let item = usrDefaults.value(forKey: "item\(i)") as? String{
                taskList.append(item)
            }
            
        }
        }
        
        
        tableView.reloadData()
    }
    func deleteTask(row:Int){
        let usrDefaults=UserDefaults.standard
        taskList.remove(at: row)
        usrDefaults.removeObject(forKey: "item\(row+1)")
        reIndexDefaults()
        // tableView.reloadData()
    }
    func reIndexDefaults(){
        let usrDefaults=UserDefaults.standard
        
        if taskList.count != 0{
            for i in 0..<taskList.count{
                usrDefaults.set(taskList[i], forKey: "item\(i+1)")
            }
            
        }
        usrDefaults.set(taskList.count, forKey: "index")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return taskList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath)

        // Configure the cell...
        cell.textLabel?.text = taskList[indexPath.row]

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            deleteTask(row: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    

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
