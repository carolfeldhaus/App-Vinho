//
//  UvaTableViewController.swift
//  MeuVinho
//
//  Created by Caroline Feldhaus de Souza on 25/10/21.
//

import UIKit

class UvaTableViewController: UITableViewController {
    
    var grapes: [Uva] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.reloadTableViewGrape()
    }
    
    func reloadTableViewGrape() {
        do {
            self.grapes = try DataBaseController.persistentContainer.viewContext.fetch(Uva.fetchRequest())
        } catch {
            print("Nao consegui trazer as informaçoes do banco de dados")
        }
        self.tableView.reloadData()
    }
    
    @IBAction func createGrape(_ sender: Any) {
        
        //Criando o primeiro alerta
        let firstAlert = UIAlertController(title: "Adicionar uva", message: "Nome da uva", preferredStyle: .alert)
        //Botao de cancelar o primeiro alerta
        let firstAlertCancelButton = UIAlertAction(title: "Cancelar", style: .default)
        //Botao de ir para o proximo campo do primeiro alerta
        let firstAlertNextButton = UIAlertAction(title: "Próximo", style: .default) { [unowned self] action in
            
            //Criando o segundo alerta
            let secondAlert = UIAlertController(title: "Nova uva",
                                                message: "Tipo da uva",
                                                preferredStyle: .alert)
            //Bora de cancelar do segundo alerta
            let secondAlertCancelButton = UIAlertAction(title: "Cancelar",
                                                        style: .default)
            
            //Botao de terminar do segundo alerta
            let secondAlertFinishButton = UIAlertAction(title: "Terminar", style: .default) { [unowned self] action in
                
                if let grapeName = firstAlert.textFields?.first?.text {
                    if let grapeType = secondAlert.textFields?.first?.text {
                        
                        let context = DataBaseController.persistentContainer.viewContext
                        let grape = Uva(context: context)
                        grape.nome = grapeName
                        grape.tipo = grapeType
                        DataBaseController.saveContext()
                        self.reloadTableViewGrape()
                    }
                }
                
            }
            
            secondAlert.addAction(secondAlertCancelButton)
            secondAlert.addAction(secondAlertFinishButton)
            secondAlert.addTextField()
            
            self.present(secondAlert, animated: true)
            
        }
        
        firstAlert.addTextField()
        firstAlert.addAction(firstAlertCancelButton)
        firstAlert.addAction(firstAlertNextButton)
        
        self.present(firstAlert, animated: true)
        
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return grapes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "uvaTableViewCell", for: indexPath)

        let grape = grapes[indexPath.row]
        
        cell.textLabel?.text = grape.nome
        cell.detailTextLabel?.text = grape.tipo

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // O sender é o cara que disparou a ação
        if let celulaSelecionada = sender as? UITableViewCell {
            //Se a gente tem a celula que disparou a ação, a gente consegue descobrir qual o index dela
            if let indexPath = self.tableView.indexPath(for: celulaSelecionada) {
                
                //Estamos validando se a tela de destino é de fato uma VinhoTableViewController
                if let vinhoTableView = segue.destination as? VinhoTableViewController {
                    
                    //Estamos atribuindo a variavel Grape da tela de vinho o valor da uva que foi celecionada
                    vinhoTableView.grape = grapes[indexPath.row]
                }
            }
        }
    }

}

