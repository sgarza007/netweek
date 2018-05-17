//
//  BuildingTableViewController.swift
//  Netweek
//
//  Created by Tyler Bullock on 5/3/18.
//  Copyright © 2018 University of San Diego. All rights reserved.
//

import UIKit
import Firebase

class BuildingTableViewController: UITableViewController {
    
    var buildingNames = ["Camino Hall","Maher Hall","Founders","MissionsA","MissionsB","SAPS","Manchester","Vistas"]
    var buildings = [Building]()
    var rooms = [Room]()
    var currBuilding : String?
    var currIndex = -1
    var callDBFlag = 0
    var dispatchGroup = DispatchGroup()
    var dispatchGroup2 = DispatchGroup()

    override func viewDidLoad() {
        super.viewDidLoad()
        rooms.removeAll()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        initNames()
        
        let myNib = UINib(nibName: "BuildingTableViewCell", bundle: nil)
        tableView.register(myNib, forCellReuseIdentifier: "customBuildingCell")
    }
    
    func initNames(){
        for name in buildingNames {
            buildings.append(Building(buildingName: name))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buildingNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "customBuildingCell", for: indexPath)
        //cell.buildingName.text = buildingNames[indexPath.row]
        //cell.buildingImage.image = UIImage(named: buildings[indexPath.row].buildingName)
        cell.textLabel?.text = buildingNames[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if callDBFlag == 0{
            retriveBuildingData(forBuilding: buildingNames[indexPath.row], atIndex: indexPath.row)
        } else {
            currIndex = indexPath.row
            performSegue(withIdentifier: "goToRooms", sender: self)
        }
    }
    
    func retriveBuildingData(forBuilding : String, atIndex : Int){
        currBuilding = forBuilding
        currIndex = atIndex
        let netweekDB = Database.database().reference().child(forBuilding)
        //self.dispatchGroup.enter()
        netweekDB.observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as! [String:Any]
            for (key,_) in value{
                self.dispatchGroup.enter()
                let room = Room(roomNumber: key)
                //get and create student objects from DB
                let roomsDB = netweekDB.child(key)
                roomsDB.observeSingleEvent(of: .value, with: { (roomSnapshot) in
                    let studentValue = roomSnapshot.value as! [String:Any]
                    for (studentName,studentID) in studentValue{
                        room.roommates?.append(Student(name: studentName, id: studentID as! String))
                    }
                    self.rooms.append(room)
                })
                self.dispatchGroup.leave()
            }
            self.dispatchGroup.notify(queue: .main, execute: {
                self.buildings[atIndex].buildingName = forBuilding
                self.buildings[atIndex].rooms = self.rooms
                self.performSegue(withIdentifier: "goToRooms", sender: self)
            })
        }
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToRooms"{
            let destinationVC = segue.destination as! RoomTableViewController
            destinationVC.building = buildings[currIndex]
            destinationVC.tableView.reloadData()
            rooms.removeAll()
        }
    }
    
    
    @IBAction func logOut(_ sender: UIBarButtonItem) {
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
