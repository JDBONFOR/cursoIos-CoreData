//
//  ViewController.swift
//  TableViews
//
//  Created by Brais Moure.
//  Copyright © 2020 MoureDev. All rights reserved.
//

import UIKit
import CoreData // Import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    // Managed Object Context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    // Change myCountries to Pais array
    private var myCountries:[Paises]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
        
        // Retrive Data
        retriveData()
        
    }
    
    func retriveData() {
        do {
            self.myCountries = try context.fetch(Paises.fetchRequest())
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        } catch {
            print("Error when data was retrived.")
        }
    }

    @IBAction func add(_ sender: Any) {
        
        // View Alert
        let alert = UIAlertController(title: "Agregar Pais", message: "Añade un pais nuevo", preferredStyle: .alert)
        alert.addTextField()
        let buttonAlertAction = UIAlertAction(title: "Añadir", style: .default) { ( action ) in
            let textField = alert.textFields![0] // Read textield data
            let newCountry = Paises(context: self.context) // Create new object of our CoreData
            newCountry.nombre = textField.text // Asign nombre to our Object
            
            do {
                _ = try self.context.save()
                DispatchQueue.main.async {
                    self.retriveData() // Reload information from CoreData to our TableView
                }
            } catch {
                print("Error when data was retrived.")
            }
        }
        alert.addAction(buttonAlertAction)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}




// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myCountries!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "mycell")
        if cell == nil {
           
            cell = UITableViewCell(style: .default, reuseIdentifier: "mycell")
            cell?.textLabel?.font = UIFont.systemFont(ofSize: 20)
            
        }
        cell!.textLabel?.text = myCountries![indexPath.row].nombre
        return cell!
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let removeAction = UIContextualAction(style: .destructive, title: "Eliminar") { (action, view, completationHandler) in
            
            let countryToRemove = self.myCountries![indexPath.row]
            self.context.delete(countryToRemove)
            do {
                _ = try self.context.save()
            } catch {
                print("Error")
            }
            
            self.retriveData()
        }
        return UISwipeActionsConfiguration(actions: [removeAction])
        
    }
    
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let editCountry = self.myCountries![indexPath.row]
        
        let alert = UIAlertController(title: "Editar Pais", message: "Edita el nombre", preferredStyle: .alert)
        alert.addTextField()
        
        // Retrive Row data and add to textField
        let textField = alert.textFields![0]
        textField.text = editCountry.nombre
        
        let alertButton = UIAlertAction(title: "Editar", style: .default) { (action) in
            let textField = alert.textFields![0]
            editCountry.nombre = textField.text
            
            do {
                try self.context.save()
            } catch {
                print("Error")
            }
            
            self.retriveData()
        }
        
        alert.addAction(alertButton)
        self.present(alert, animated: true, completion: nil)
        
        
    }
    
}

