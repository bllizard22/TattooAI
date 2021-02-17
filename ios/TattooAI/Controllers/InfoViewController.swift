//
//  InfoViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 15.02.2021.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var hiwButton: UIButton!
    @IBOutlet weak var melInstagram: UILabel!
    
    let contacts = ["@evgenymel": "https://www.instagram.com/evgenymel/",
                    "@name": "name@mail.com",
                    "@bllizard22": "https://t.me/bllizard22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        hiwButton.layer.cornerRadius = 10
        
        let tapMelInst = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.melIGDidPressed(_:)))
        melInstagram.isUserInteractionEnabled = true
        melInstagram.addGestureRecognizer(tapMelInst)
        let attributedString = NSMutableAttributedString(string: "@evgenymel")
////        let attributedString = NSMutableAttributedString(string: "mel", attributes:[NSAttributedString.Key.link: URL(string: "http://www.google.com/")!])
        attributedString.addAttribute(.underlineStyle,
                                      value: NSUnderlineStyle.single.rawValue,
                                      range: NSRange(location: 0, length:   attributedString.length))
        melInstagram.attributedText = attributedString
    }
        
    @IBAction func cancelDidPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func melIGDidPressed(_ sender: UITapGestureRecognizer) {
        print("tap working")
//        UIApplication.shared.open(URL(string: "https://www.instagram.com/evgenymel/")!,
//                                  options: [:],
//                                  completionHandler: nil)
        print(sender.view?.tag)
        UIApplication.shared.open(URL(string: contacts["@evgenymel"]!)!,
                                  options: [:],
                                  completionHandler: nil)
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
