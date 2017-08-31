//
//  LoginViewController.swift
//  coeda
//
//  Created by kytiken on 2017/08/26.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import UIKit
import Moya
import RealmSwift
import SwiftyJSON
import RxRealm
import RxCocoa
import RxSwift

class LoginViewController: UIViewController {
    var realm: Realm? = nil
    var identities: Observable<Results<ConohaIdentity>>?
    var identity: ConohaIdentity?
    let bag = DisposeBag()
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var tenantId: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let identity = ConohaIdentity()
        identity.user = User()
        identity.tenant = Tenant()
        identity.user?.name = username.text
        identity.tenant?.id = tenantId.text
        self.identity = identity
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onCancelButtonTouched(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onLoginButtonTouched(_ sender: Any) {
        let provider = RxMoyaProvider<ConohaIdentityService>()
        let _ = self.identity?.setId()
        let request = provider.request(.tokens(username: (self.identity?.user?.name)!, password: self.password.text!, tenantId: (self.identity?.tenant?.id)!)).mapJSON()
        let _ = request.bind(onNext: { event in
            self.dismiss(animated: true, completion: nil)
        })
        let _ = request.bind(onNext: { response in
            let json = JSON(response)
            let tokenId = json["access"]["token"]["id"]
            if (tokenId.string != nil) {
                let token = Token()
                token.id = tokenId.string!
                self.identity?.token = token
                try! self.realm?.write {
                    self.realm?.add(self.identity!, update: true)
                }
                let realmBag = DisposeBag()
                let realmDisposable = self.identities?.subscribe(self.realm!.rx.add())
                realmDisposable?.addDisposableTo(realmBag)
                
            } else {
                print(json["access"]["token"]["id"].error!)
            }
        })
        let _ = request.subscribe()

    }
}
