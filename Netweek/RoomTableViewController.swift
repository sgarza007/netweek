//
//  RoomTableViewController.swift
//  Netweek
//
//  Created by Tyler Bullock on 5/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Firebase

class RoomTableViewController: UITableViewController {
    
    var building : Building?
    var currRoomIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let myNib = UINib(nibName: "RoomTableViewCell", bundle: nil)
        tableView.register(myNib, forCellReuseIdentifier: "customRoomCell")
        print(building?.rooms)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return (building?.rooms?.count)!
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customRoomCell", for: indexPath) as! RoomTableViewCell
        cell.roomName.text = building?.rooms![indexPath.row].roomNum
        if (building?.rooms![indexPath.row].status)!{
            cell.status.image = UIImage(named: "checked")
        } else {
            cell.status.image = UIImage(named: "unchecked")
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currRoomIndex = indexPath.row
        retrieveRoomData(forRoom: (building?.rooms![currRoomIndex].roomNum)!)
    }
    
    
    func retrieveRoomData(forRoom : String){
        print(currRoomIndex)
        print(building?.rooms)
        let roomDB = Database.database().reference().child((building?.buildingName)!).child(forRoom)
        roomDB.observeSingleEvent(of: .value) { (snapshot) in
            let students = snapshot.value as! [String:String]
            for (k,v) in students{
                print(k,v)
                let s = Student(name: k, id: v)
                self.building?.rooms![self.currRoomIndex].roommates?.append(s)
            }
            print(self.building?.rooms![self.currRoomIndex].roommates?.count)
            //self.performSegue(withIdentifier: "goToStudentsTV", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToStudentsTV"{
            let destinationVC = segue.destination as! StudentTableViewController
            destinationVC.currRoomIndex = currRoomIndex
            destinationVC.building = building
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        do{
            try Auth.auth().signOut()
        }
        catch{
            print("Error signing out.");
        }
        
        guard (navigationController?.popToRootViewController(animated: true) != nil)
            else{
                print("Already at the Root");
                return
        }
    }
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
