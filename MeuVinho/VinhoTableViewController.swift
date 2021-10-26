//
//  VinhoTableViewController.swift
//  MeuVinho
//
//  Created by Caroline Feldhaus de Souza on 25/10/21.
//

import UIKit

class VinhoTableViewController: UITableViewController {
    
    let context = DataBaseController.persistentContainer.viewContext
    var grape: Uva?
    var vinhos: [Vinho] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.addWine))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadWineData()
    }
    
    func reloadWineData() {
        if let vinhos = grape?.vinhos {
            self.vinhos.removeAll()
            self.vinhos = vinhos.map({ $0 as! Vinho })
        }
        self.tableView.reloadData()
    }
    
    @objc func addWine() {
        
        let firstAlert = UIAlertController(title: "Adicionar vinho",
                                           message: "Nome do vinho",
                                           preferredStyle: .alert)
        
        let firstAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                   style: .default)
        
        let firstAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
            
            let secondAlert = UIAlertController(title: "Adicionar vinho",
                                                message: "País de origem",
                                                preferredStyle: .alert)
            
            let secondAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                        style: .default)
            
            let secondAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
                
                let thirdAlert = UIAlertController(title: "Adicionar vinho",
                                                   message: "Vinícola",
                                                   preferredStyle: .alert)
                
                let thirdAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                           style: .default)
                
                let thirdAlertFinishButton = UIAlertAction(title: "Terminar", style: .default) { [unowned self] action in
                    
                    if let wineName = firstAlert.textFields?.first?.text {
                        if let wineCountry = secondAlert.textFields?.first?.text {
                            if let winery = thirdAlert.textFields?.first?.text {
                                
                                    let wine = Vinho(context: context)
                                    wine.nome = wineName
                                    wine.pais = wineCountry
                                    wine.vinicola = winery
                                    self.grape?.addToVinhos(wine)
                                    DataBaseController.saveContext()
                                    self.reloadWineData()
                            }
                        }
                    }
                    
                }
                thirdAlert.addAction(thirdAlertCancelButton)
                thirdAlert.addAction(thirdAlertFinishButton)
                thirdAlert.addTextField()
                
                self.present(thirdAlert, animated: true)
            }
            
            secondAlert.addAction(secondAlertCancelButton)
            secondAlert.addAction(secondAlertNextButton)
            secondAlert.addTextField()
            
            self.present(secondAlert, animated: true)
        }
        
        firstAlert.addTextField()
        firstAlert.addAction(firstAlertCancelButton)
        firstAlert.addAction(firstAlertNextButton)
        
        self.present(firstAlert, animated: true)
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vinhos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vinhoTableViewCell", for: indexPath)
        let wine = vinhos[indexPath.row]
        
        cell.textLabel?.text = wine.nome
        cell.detailTextLabel?.text = wine.pais
        
        return cell
    }
   

}
