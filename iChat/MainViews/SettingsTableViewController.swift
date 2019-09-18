//
//  SettingsTableViewController.swift
//  iChat
//
//  Created by Imran Rahman on 10/13/18.
//  Copyright © 2018 Imran Rahman. All rights reserved.
//

import UIKit
import ProgressHUD

class SettingsTableViewController: UITableViewController {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    
    @IBOutlet weak var fullNameLabal: UILabel!
    
    @IBOutlet weak var deleteButtonOutlet: UIButton!
    
    @IBOutlet weak var showAvatarStatusSwitch: UISwitch!
    
    @IBOutlet weak var versionLabel: UILabel!
    let userDefaults = UserDefaults.standard
    
    var avatarSwitchStatus = false
    var firstLoad : Bool?
    
    
    
    
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        if FUser.currentUser() != nil{
            setupUI()
            loadUserDefaults()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if section == 1 {
            return 5
        }
        return 2
    }
    
    //MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return ""
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 0 {
            return 0
        }
        return 30
    }
    

    //MARK: IBActions
    
    
    @IBAction func cleanCacheButtonPressed(_ sender: Any) {
        
        do{
            let files = try FileManager.default.contentsOfDirectory(atPath: getDocumentsURL().path)
            
            for file in files{
                
                try FileManager.default.removeItem(atPath: "\(getDocumentsURL().path)/\(file)")
            }
            
            ProgressHUD.showSuccess("Cache cleaned.")
        }catch{
            
            ProgressHUD.showSuccess("Couldn't clean media files.")
        }   
        
    }
    
    @IBAction func showAvatarSwitchValueChanged(_ sender: UISwitch) {

        avatarSwitchStatus = sender.isOn
        
        saveUserDefaults()
        
    }
    
    @IBAction func tellAFriendButtonPressed(_ sender: Any) {
        
        let text = "Hey! let's chat on iChat \(kAPPURL)"
        
        let objectToShare:[Any] = [text]
        
        let actitvityViewController = UIActivityViewController(activityItems: objectToShare, applicationActivities: nil)
        
        actitvityViewController.popoverPresentationController?.sourceView = self.view
        actitvityViewController.setValue("Let's chat on iChat", forKey: "subject")
        self.present(actitvityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func logOutButtonPressed(_ sender: Any) {
        FUser.logOutCurrentUser { (success) in
            if success{
                self.showLogingView()
            }
        }
        
    }

    @IBAction func deleteAccountButtonPressed(_ sender: Any) {
        
        let optionMenu = UIAlertController(title: "Delete Account", message: "Are you sure want to delete your account ?", preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive) { (alert) in
            
           self.deleteUser()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (alert) in
            
        }
        
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    
    func showLogingView(){
        let mainView = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "welcome")
        self.present(mainView, animated: true, completion: nil)
    
    }
    
    //MARK: SetupUI
    
    func setupUI(){
        let currentUser = FUser.currentUser()!
        fullNameLabal.text = currentUser.fullname
        if currentUser.avatar !=  "" {
            imageFromData(pictureData: currentUser.avatar) { (avatarImage) in
                
                if avatarImage  != nil {
                    self.avatarImageView.image = avatarImage!.circleMasked
                }
            }
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String{
            versionLabel.text = version
        }
    }
    
    //MARK: Delete User
    
    func deleteUser(){
        
        //dalete localy
        
        userDefaults.removeObject(forKey: kPUSHID)
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        //delete from firebase
        
        reference(.User).document(FUser.currentId()).delete()
        
        FUser.deleteUser { (error) in
            
            if error != nil{
                
                DispatchQueue.main.async {
                    ProgressHUD.showError("Couldn't delete use")
                }
                return
            }
            self.showLogingView()
        }
        
        
    }
    
    
    
    
    
    
    
    //MARK: UserDefaults
    
    func saveUserDefaults(){
        
        userDefaults.set(avatarSwitchStatus, forKey: kSHOWAVATAR)
        userDefaults.synchronize()
        
        
    }
    
    
    func loadUserDefaults(){
        firstLoad = userDefaults.bool(forKey: kFIRSTRUN)
        
        if !firstLoad!{
            userDefaults.set(true, forKey:kFIRSTRUN)
            userDefaults.set((avatarSwitchStatus), forKey: kSHOWAVATAR)
            userDefaults.synchronize()
        }
        
        avatarSwitchStatus = userDefaults.bool(forKey: kSHOWAVATAR)
        showAvatarStatusSwitch.isOn = avatarSwitchStatus
        
    }
    
    
}
