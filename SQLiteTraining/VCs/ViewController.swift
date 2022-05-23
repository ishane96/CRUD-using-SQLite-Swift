//
//  ViewController.swift
//  SQLiteTraining
//
//  Created by Achintha Kahawalage on 2022-05-18.
//

import UIKit
import SQLite3

class ViewController: UIViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var doorsTF: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var dateTF: UITextField!
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DBHelper.shared.openDB()
        DBHelper.shared.createTable()
        _ = DBHelper.shared.readData()
        
        showDatePicker()
        print("Success")
    }
    
    @IBAction func saveBtnActn(_ sender: Any) {
        
        let name = nameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let doors = doorsTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
  
        
        
        DBHelper.shared.saveData(name: name!, doors: doors!, date: datePicker.date)
        DBHelper.shared.mainList.removeAll()
        _ = DBHelper.shared.readData()
        tableView.reloadData()
    }
    
    func showDatePicker(){
        //Formate Date
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        //ToolBar
        let toolbar = UIToolbar();
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(donedatePicker));
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelDatePicker));
        
        toolbar.setItems([doneButton,spaceButton,cancelButton], animated: false)
        
        dateTF.inputAccessoryView = toolbar
        dateTF.inputView = datePicker
        
    }
    
    @objc func donedatePicker(){
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        dateTF.text = formatter.string(from: datePicker.date)
        
        self.view.endEditing(true)
    }
    
    @objc func cancelDatePicker(){
        self.view.endEditing(true)
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DBHelper.shared.mainList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TVC") as! TVC
        
        cell.lbl.text = "Model: \(DBHelper.shared.mainList[indexPath.row].name)"
        cell.textLabel?.text = "Doors: \(DBHelper.shared.mainList[indexPath.row].doors)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let dateStr = formatter.string(from: DBHelper.shared.mainList[indexPath.row].date)
        
        cell.dateLbl.text = dateStr
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        var car = DBHelper.shared.mainList[indexPath.row]
        
        let alert = UIAlertController(title: "Edit Car", message: "Car", preferredStyle: .alert)
        alert.addTextField()
        alert.addTextField()
        
        var nameTxtFld = alert.textFields![0]
        var doorsTxtFld = alert.textFields![1]
        nameTxtFld.text = car.name
        doorsTxtFld.text = car.doors
        
        let saveBtn = UIAlertAction(title: "Save", style: .default) { (action) in
            nameTxtFld = alert.textFields![0]
            car.name = nameTxtFld.text!
            
            doorsTxtFld = alert.textFields![1]
            car.doors = doorsTxtFld.text!
            
            DBHelper.shared.update(id: car.id, name: car.name, doors: car.doors)
            DBHelper.shared.mainList.removeAll()
            _ = DBHelper.shared.readData()
            self.tableView.reloadData()
        }
        let cancelBtn = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(saveBtn)
        alert.addAction(cancelBtn)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            
            DBHelper.shared.delete(id: DBHelper.shared.mainList.remove(at: indexPath.row).id)
            tableView.reloadData()
        }
        
        return UISwipeActionsConfiguration(actions: [action])
    }
    
}
