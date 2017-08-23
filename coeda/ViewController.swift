//
//  ViewController.swift
//  coeda
//
//  Created by kytiken on 2017/08/22.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import UIKit
import Moya


class ViewController: UIViewController {
    let provider = RxMoyaProvider<ConohaIdentityService>()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tenantId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLoginButtonTouched(_ sender: Any) {
        let _ = provider.request(.tokens(username: username.text!, password: password.text!, tenantId: tenantId.text!)).subscribe { event in
            switch event {
            case let .next(response):
                let json = try! response.mapJSON(failsOnEmptyData: true)
                print(json)
            case let .error(error):
                print(error)
            default:
                break
            }
        }


    }

}

