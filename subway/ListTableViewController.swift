//
//  ListTableViewController.swift
//  subway
//
//  Created by Jim Chuang on 2018/11/12.
//  Copyright © 2018 nhr. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {


    @IBOutlet var mySwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("view did load")
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }

    //MARK: - Button Click
    @IBAction func addBtnClick(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "", message: "Add", preferredStyle: .alert)
        alert.addTextField { (name) in
            name.placeholder = "name"
        }
        alert.addTextField { (url) in
            url.placeholder = "url"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            if let nameStr = alert.textFields?[0].text,let urlStr = alert.textFields?[1].text{
                MyHttp.share.addUrl(name: nameStr, url: urlStr)
            }
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action) in

        }
        alert.addAction(okAction)
        alert.addAction(cancelAction)

        self.present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MyHttp.share.getUrlListKey().count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "urlCell", for: indexPath)
        cell.textLabel?.text = MyHttp.share.getUrlListKey()[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        MyHttp.share.urlSelectStr = MyHttp.share.getUrlListKey()[indexPath.row]
        print("MyHttp.share.urlSelectStr = ",MyHttp.share.urlSelectStr)
        print("url = ",MyHttp.share.getURL())
        if mySwitch.isOn{
            self.performSegue(withIdentifier: "seque_list_to_videos", sender: nil)
        }else{
            self.performSegue(withIdentifier: "seque_list_to_show", sender: nil)
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        if editingStyle == .delete {

            MyHttp.share.delDicKey(key: MyHttp.share.getUrlListKey()[indexPath.row])
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {

        }    
    }


    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
