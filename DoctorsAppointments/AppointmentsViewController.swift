//
//  AppointmentsViewController.swift
//  SubclassingDataModelWithSingleRelationship
//
//  Created by Mazharul Huq on 1/22/18.
//  Copyright © 2018 Mazharul Huq. All rights reserved.
//

import UIKit
import CoreData

class AppointmentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var physicianLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var addButton: UIButton!
    @IBOutlet var dateField: UITextField!
    
    var managedContext: NSManagedObjectContext!
    var physician:Physician?
    
    var myDatePicker:UIDatePicker!
    var dateFormatter:DateFormatter!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateFormatter = DateFormatter()
        self.dateFormatter.dateStyle = .short
        self.dateFormatter.timeStyle = .short
        
        self.myDatePicker = UIDatePicker()
        self.myDatePicker.frame = CGRect(x: 0, y: 0, width: 270, height: 200)
        self.myDatePicker.addTarget(self, action: #selector(AppointmentsViewController.dateChanged), for: .valueChanged)
        
        self.dateField.placeholder = "Tap to enter date and time"
        self.dateField.inputView = self.myDatePicker
        self.addButton.isEnabled = false

        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        let b = UIBarButtonItem(barButtonSystemItem: .edit, target: self, action: #selector(AppointmentsViewController.doEdit(_:)))
        self.navigationItem.rightBarButtonItem = b
        self.tableView.delegate = self
        self.tableView.dataSource = self

        guard let physician = self.physician else{
            return
        }
        if let name = physician.name {
            self.physicianLabel.text = "Appointments for:  \(name)"
        }
        
    }
    
    @objc func dateChanged(){
        let date = myDatePicker.date
        
        self.dateField.text = dateFormatter.string(from: date)
        self.addButton.isEnabled = true
    }

    @objc func doEdit(_ sender:AnyObject?) {
        var which : UIBarButtonSystemItem
        if !self.tableView.isEditing {
            self.tableView.setEditing(true, animated:true)
            which = .done
        } else {
            self.tableView.setEditing(false, animated:true)
            which = .edit
        }
        let b = UIBarButtonItem(barButtonSystemItem: which, target: self, action: #selector(AppointmentsViewController.doEdit(_:)))
        self.navigationItem.rightBarButtonItem = b
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        return  (self.physician?.appointments!.count)!
    }
    
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        
        let appointment = self.physician?.appointments?[indexPath.row] as? Appointment
        guard let date = appointment?.date else{
            return cell
        }
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date as Date)
        let formatter2 = DateFormatter()
        formatter2.timeStyle = .short
        let timeString = formatter2.string(from: date as Date)
        cell.textLabel?.text = "\(dateString) at \(timeString)"
        return cell
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    // Override to support editing the table view.
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            guard let appointment = physician?.appointments![indexPath.row] as? Appointment else{
                return
            }
            if appointment.delete(managedContext){
                self.tableView.reloadData()
            }
            else{
                print("Unable to delete")
            }
        }
    }
    
    
    @IBAction func saveTapped(_ sender: Any) {
        
        let date = dateFormatter.date(from: self.dateField.text!)
        let appointment = Appointment(context: self.managedContext)
        appointment.date = date as NSDate?
        self.physician?.addToAppointments(appointment)
        
        if appointment.save(self.managedContext){
            self.tableView.reloadData()
            self.addButton.isEnabled = false
        }
        self.dateField.endEditing(true)
    }
    
}
