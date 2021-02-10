//
//  SettingsTableViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 09.02.2021.
//

import UIKit

let colorArray = ["Any", "Grayscale", "Red", "Cyan", "Colorful"]
let placeArray = ["Any", "Arm", "Body", "Leg"]
let styleArray = ["Any", "Old School", "Oriental", "Portrait", "Blackwork", "Biomech", "Geometric"]
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
        print(rootVC.viewControllers?.count)
        for vc in rootVC.viewControllers! {
//            print(type(of: vc))
            if vc.isKind(of: GeneratorViewController.self) {
                print("\(vc)")
                let generatorVC = vc as! GeneratorViewController
                generatorVC.colorLabel.text = colorArray[selectedCells[0]]
                generatorVC.placeLabel.text = placeArray[selectedCells[1]]
                generatorVC.styleLabel.text = styleArray[selectedCells[2]]
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
