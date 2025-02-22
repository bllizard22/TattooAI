//
//  SettingsTableViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 09.02.2021.
//

import UIKit

let colorArray = [0: "Any", 1: "Grayscale", 2: "Red", 3: "Cyan", 4: "Colorful"]
let placeArray = [0: "Any", 1: "Arm", 2: "Body", 3: "Leg"]
let styleArray = [0: "Any", 1: "Old School", 2: "Oriental", 3: "Portrait", 4: "Blackwork", 5: "Biomech", 6: "Geometric"]
let commonArray = [colorArray, placeArray, styleArray]

let tableHeaders = ["Color", "Place", "Style"]

class SettingsTableViewController: UITableViewController {

    var selectedCells = [0, 0, 0]
        
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let rootVC = presentingViewController as! UITabBarController
//        print(rootVC.viewControllers?.count)
        for vc in rootVC.viewControllers! {
//            print(type(of: vc))
            if vc.isKind(of: GeneratorViewController.self) {
                print("\(vc)")
                let generatorVC = vc as! GeneratorViewController
                generatorVC.colorLabel.text = colorArray[selectedCells[0]]
                generatorVC.placeLabel.text = placeArray[selectedCells[1]]
                generatorVC.styleLabel.text = styleArray[selectedCells[2]]
                generatorVC.getFilteredItems()
            }
//            let generatorVC = rootVC.viewControllers![0]
    //        generatorVC.colorLabel.text = "new"
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return commonArray.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commonArray[section].count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        cell.textLabel?.text = commonArray[indexPath.section][indexPath.row]
//        cell.textLabel?.textColor = UIColor(red: MainColor.red,
//                                            green: MainColor.green,
//                                            blue: MainColor.blue,
//                                            alpha: 1)
        if selectedCells[indexPath.section] == indexPath.row {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
//        if cell.textLabel?.text == "Red" {
        if indexPath.section > 0 {
            cell.isUserInteractionEnabled = false
            cell.textLabel?.isEnabled = false
            cell.textLabel?.text = "Soon:   \(cell.textLabel?.text ?? "New feature")"
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tableHeaders[section]
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCells[indexPath.section] = indexPath.row
        
        tableView.reloadData()
        
        print(selectedCells)
    }
    
    @IBAction func doneDidPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
