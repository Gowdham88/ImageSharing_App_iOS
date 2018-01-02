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
        return location.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! Locationtableviewcell
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
