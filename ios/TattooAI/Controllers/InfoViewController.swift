//
//  InfoViewController.swift
//  TattooAI
//
//  Created by Nikolay Kryuchkov on 15.02.2021.
//

import UIKit

class InfoViewController: UIViewController {

    @IBOutlet weak var hiwButton: UIButton!
    @IBOutlet weak var feedbackEmail: UILabel!
    @IBOutlet weak var melInstagram: UILabel!
    @IBOutlet weak var nnTelegram: UILabel!
    @IBOutlet weak var iosTelegram: UILabel!
    @IBOutlet var tapOutlet: UITapGestureRecognizer!
    
    @IBOutlet weak var textStackView: UIStackView!
    
    let contacts = ["email": "mailto:01tattooai@gmail.com",
                    "@evgenymel": "https://www.instagram.com/evgenymel/",
                    "@name": "name@mail.com",
                    "@bllizard22": "https://t.me/bllizard22"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        overrideUserInterfaceStyle = .dark
        hiwButton.layer.cornerRadius = 10
        
        let tapFeedback = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.feedbackDidPressed(_:)))
        feedbackEmail.isUserInteractionEnabled = true
        feedbackEmail.addGestureRecognizer(tapFeedback)
        
        let tapMelInst = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.melIGDidPressed(_:)))
        melInstagram.isUserInteractionEnabled = true
        melInstagram.addGestureRecognizer(tapMelInst)
//        let attributedString = NSMutableAttributedString(string: "@evgenymel")
//        attributedString.addAttribute(.underlineStyle,
//                                      value: NSUnderlineStyle.single.rawValue,
//                                      range: NSRange(location: 0, length:   attributedString.length))
//        melInstagram.attributedText = attributedString
        
        let tapIosTelegram = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.iosDidPressed(_:)))
        iosTelegram.isUserInteractionEnabled = true
        iosTelegram.addGestureRecognizer(tapIosTelegram)
        
        let tapNnTelegram = UITapGestureRecognizer(target: self, action: #selector(InfoViewController.nnDidPressed(_:)))
        nnTelegram.isUserInteractionEnabled = true
        nnTelegram.addGestureRecognizer(tapNnTelegram)
        
        let windowHeight = UIScreen.main.bounds.size.height
        let windowWidth = UIScreen.main.bounds.size.width
        let safeArea = self.view.safeAreaLayoutGuide
//        let textStackTopConstraint = textStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
//                                                                         constant: windowHeight/5)
        let textStackTopConstraint = textStackView.topAnchor.constraint(equalTo: safeArea.topAnchor,
                                                                        constant: windowHeight/10)
        let hiwButtonTopConstraint = hiwButton.topAnchor.constraint(equalTo: textStackView.bottomAnchor,
                                                                    constant: windowHeight/5)
        NSLayoutConstraint.activate([textStackTopConstraint, hiwButtonTopConstraint])
        
        
    }
        
    @IBAction func cancelDidPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func feedbackDidPressed(_ sender: UITapGestureRecognizer) {
        print("email working")
        UIApplication.shared.open(URL(string: contacts["email"]!)!,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    @objc func melIGDidPressed(_ sender: UITapGestureRecognizer) {
        print("mel working")
        UIApplication.shared.open(URL(string: contacts["@evgenymel"]!)!,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    @objc func nnDidPressed(_ sender: UITapGestureRecognizer) {
        print("nn working")
        UIApplication.shared.open(URL(string: contacts["@name"]!)!,
                                  options: [:],
                                  completionHandler: nil)
    }
    
    @objc func iosDidPressed(_ sender: UITapGestureRecognizer) {
        print("ios working")
        UIApplication.shared.open(URL(string: contacts["@bllizard22"]!)!,
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
