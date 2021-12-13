//
//  AddNoteVC.swift
//  Note App
//
//  Created by Tristan Bui on 12/7/21.
//

import UIKit
import CoreData
class AddNoteVC: UIViewController,UITextViewDelegate {
    
    var note = ""
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context = NSManagedObjectContext()
    @IBOutlet weak var viewForText: UIView!
    @IBOutlet weak var txtNote: UITextView!
    @IBOutlet weak var btnSave: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        txtNote.text = "Enter text here..."
        if note != ""{
            navigationItem.title = "Update note"
            txtNote.text = note
            btnSave.setTitle("Update", for: .normal)
        }else{
            navigationItem.title = "Add note"
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        viewForText.layer.cornerRadius = 18
        viewForText.clipsToBounds = true
        viewForText.layer.borderWidth = 1
        viewForText.layer.borderColor = UIColor(red:105/255, green:105/255, blue:105/255, alpha: 1).cgColor
        btnSave.layer.cornerRadius = 18
        navigationController?.navigationItem.hidesBackButton = true
        let backbtn = UIButton(type: .custom)
        backbtn.setImage(UIImage(named: "Back"), for: .normal)
        backbtn.setTitleColor(backbtn.tintColor, for: .normal)
        backbtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backbtn)
        
    }
    @objc func backAction(){
        navigationController?.popViewController(animated: true)
    }
    @IBAction func click_onSaveBtn(_ sender: Any) {
        if txtNote.text == "Enter text here..." || txtNote.text == ""{
            let alert = UIAlertController(title: "Add Note", message: "Add a note first.", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            if note == ""{
                context = appDelegate.persistentContainer.viewContext
                
                let entity = NSEntityDescription.entity(forEntityName: "Notes", in: context)
                let note = NSManagedObject(entity: entity!, insertInto: context)
                note.setValue(txtNote.text, forKey: "note")
                
                
                do{
                    try context.save()
                    navigationController?.popViewController(animated: true)
                }catch{
                    debugPrint("Can't save")
                }
            }
            else{
                updateData(newName: note)
            }
        }
    }
    func updateData(newName: String)
    {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "Notes")
        fetchRequest.predicate = NSPredicate(format: "note = %@", note)
        do
        {
            let test = try managedContext.fetch(fetchRequest)
   
                let objectUpdate = test[0] as! NSManagedObject
            objectUpdate.setValue(txtNote.text, forKey: "note")
                do{
                    try managedContext.save()
                    navigationController?.popViewController(animated: true)
                }
                catch
                {
                    print(error)
                }
            }
        catch
        {
            print(error)
        }
    }
    func textViewDidBeginEditing(_ textView: UITextView) {
        if note == ""{
            txtNote.text = ""
        }
    }
}

