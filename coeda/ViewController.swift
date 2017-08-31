//
//  ViewController.swift
//  coeda
//
//  Created by kytiken on 2017/08/22.
//  Copyright © 2017年 kytiken. All rights reserved.
//

import UIKit
import Moya
import RealmSwift
import SwiftyJSON
import RxSwift
import RxCocoa
import RxRealm


class ViewController: UIViewController {
    let provider = RxMoyaProvider<ConohaIdentityService>()
    let realm = try! Realm()
    var identities: Observable<Results<ConohaIdentity>>?
    let bag = DisposeBag()
    
    @IBOutlet weak var identityTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        identities = Observable.collection(from: realm.objects(ConohaIdentity.self))
        let _ = self.identities?
            .bind(to: identityTableView.rx.items) {tv, ip, element in
                let cell = tv.dequeueReusableCell(withIdentifier: "Cell")!
                cell.textLabel?.text = element.user?.name
                return cell
        }.addDisposableTo(bag)
        let _ = identityTableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let cell = self.identityTableView.cellForRow(at: indexPath) as! UITableViewCell
            

            let serversViewController = ServersViewController()
            self.navigationController?.pushViewController(serversViewController, animated: true)
        }).addDisposableTo(bag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "NewIdentitySegue" {
            let loginViewController = segue.destination as! LoginViewController
            loginViewController.identities = self.identities
            loginViewController.realm = self.realm
        }
    }

}

