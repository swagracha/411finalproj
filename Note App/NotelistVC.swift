//
//  NotelistVC.swift
//  Note App
//
//  Created by Tristan Bui on 12/7/21.
//

import UIKit
import CoreData
class NotelistVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var context: NSManagedObjectContext? = nil
    @IBOutlet weak var lblNotFound: UILabel!
    @IBOutlet weak var tbl_Notes: UITableView!
    @IBOutlet weak var btnAdd: UIBarButtonItem!
   
    var notes = [String]()
    var assNotes = [String]()
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tbl_Notes.delegate = self
        tbl_Notes.dataSource = self
        tbl_Notes.tableFooterView = UIView()
    }
    override func viewWillAppear(_ animated: Bool) {
        tbl_Notes.estimatedRowHeight = 44.0
        tbl_Notes.rowHeight = UITableView.automaticDimension
        fetchData()
        if notes.count == 0{
            lblNotFound.isHidden = false
            tbl_Notes.isHidden = true
        }else{
            lblNotFound.isHidden = true
            tbl_Notes.isHidden = false
        }
        tbl_Notes.reloadData()
        
    }
    func fetchData(){
        notes.removeAll()
        assNotes.removeAll()
        context = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes");
        request.returnsObjectsAsFaults = false
        do {
            let result = try context!.fetch(request)
            print("Trying to fetch")
            for data in result as! [NSManagedObject] {
                notes.append(data.value(forKey: "note") as! String)
                print(data.value(forKey: "note") as! String)
            }
        } catch {
            print("Failed")
        }
        
        var count = notes.count
        print("sss",count)
        while count>0{
            assNotes.append(notes[count - 1])
            count = count - 1
        }
        print(assNotes)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return assNotes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tbl_Notes.dequeueReusableCell(withIdentifier: "NoteTableViewCell", for: indexPath) as! NoteTableViewCell
        cell.lblNote.text = assNotes[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
         
            let taken = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completion) in
                let refreshAlert = UIAlertController(title: "Delete Alert", message: "Are you sure ?", preferredStyle: UIAlertController.Style.alert)
                
                refreshAlert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { [self] (action: UIAlertAction!) in
                    
                    guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
                    let managedContext = appDelegate.persistentContainer.viewContext
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Notes")
                    fetchRequest.predicate = NSPredicate(format: "note = %@", assNotes[indexPath.row])
                    do
                    {
                        let test = try managedContext.fetch(fetchRequest)
                        
                        let objectToDelete = test[0] as! NSManagedObject
                        managedContext.delete(objectToDelete)
                        
                        do{
                            try managedContext.save()
                            notes.remove(at: indexPath.row)
                            assNotes.remove(at: indexPath.row)
                            fetchData()
                            if notes.count == 0{
                                lblNotFound.isHidden = false
                                tbl_Notes.isHidden = true
                            }else{
                                lblNotFound.isHidden = true
                                tbl_Notes.isHidden = false
                            }
                            tbl_Notes.reloadData()
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
                    
                }))
                
                refreshAlert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                
                self.present(refreshAlert, animated: true, completion: nil)
                completion(true)
            }
        taken.backgroundColor =  UIColor.red
         
        let added = UIContextualAction(style: .normal, title: "Edit") { [self] (action, view, completion) in
                let vc = storyboard?.instantiateViewController(identifier: "AddNoteVC") as! AddNoteVC
                vc.note = assNotes[indexPath.row]
                navigationController?.pushViewController(vc, animated: true)
                completion(false)
            }
        added.backgroundColor = UIColor.systemGreen
            added.backgroundColor =  UIColor(red: 0.2436070212, green: 0.5393256153, blue: 0.1766586084, alpha: 1)
         
            let config = UISwipeActionsConfiguration(actions: [taken, added])
            config.performsFirstActionWithFullSwipe = false
         
            return config
        }
}
