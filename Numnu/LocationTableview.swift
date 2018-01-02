//
//  LocationTableview.swift
//  Numnu
//
//  Created by Suraj B on 12/29/17.
//  Copyright © 2017 czsm. All rights reserved.
//

import UIKit

class LocationTableview: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var location = ""
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! BookmarkTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        methodToCallApi()
    }
    
    func methodToCallApi (){
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
