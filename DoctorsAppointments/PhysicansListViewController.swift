//
//  PhysicansListViewController.swift
//  SubclassingDataModelWithSingleRelationship
//
//  Created by Mazharul Huq on 1/22/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class PhysicansListViewController: UITableViewController {

    lazy var coreDataStack = CoreDataStack(modelName: "AppointmentsList")
    var managedContext: NSManagedObjectContext!
    var physicians = [Physician]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.managedContext = self.coreDataStack.managedContext
        self.navigationItem.leftBarButtonItem = self.editButtonItem

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //Whenever the view appears, data is fetched from ths store
        let physicianFetch:NSFetchRequest<Physician> = Physician.fetchRequest()
        //Records are fetched using executeFetchRequest
        do{
            physicians = try managedContext.fetch(physicianFetch)
            self.tableView.reloadData()//Table reloaded
        }
        catch
            let nserror as NSError {
                print("Could not save \(nserror),(nserror.userInfo)")
        }
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return physicians.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let physician = physicians[indexPath.row]
        cell.textLabel?.text =  physician.name
        cell.detailTextLabel?.text = physician.specialty
        return cell
    }
    

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let physician = physicians[indexPath.row]
            if physician.delete(managedContext){
                physicians.remove(at: indexPath.row)
                self.tableView.reloadData()
            }
            else{
                print("Unable to delete")
            }
        }    
    }
    

    
    func savePhysician(_ name: String, specialty:String, practice:String){
        
        let physician = Physician(context: self.managedContext)
        physician.name = name
        physician.specialty = specialty
        physician.practice = practice
        if physician.save(managedContext){
            physicians.append(physician)
            self.tableView.reloadData()
        }
    }
    
    @IBAction func addTapped(_ sender: Any) {
        let alert = UIAlertController(title: "Adding a Physician",
                                      message: "Add a new physician",preferredStyle: .alert)
        
        
        alert.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Name"
        }
        
        alert.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Specialty"
        }
        
        alert.addTextField {
            (textField: UITextField!) -> Void in
            textField.placeholder = "Practice"
        }
        
        let saveAction = UIAlertAction(title: "Save",
             style: .default) {
                [unowned self] action
                            in
                guard let name = alert.textFields?[0].text,
                    let specialty = alert.textFields?[1].text,
                    let practice = alert.textFields?[2].text else{
                        return
                }
            
                self.savePhysician(name, specialty: specialty, practice: practice)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
              style: .default)
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert,animated: true,completion: nil)
        
    }

    
    // MARK: - Navigation

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as!AppointmentsViewController
        vc.managedContext = self.managedContext
        if let indexPath = self.tableView.indexPathForSelectedRow {
            vc.physician = physicians[indexPath.row]
        }
    }
    

}
