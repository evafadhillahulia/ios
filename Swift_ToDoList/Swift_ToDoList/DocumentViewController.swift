//
//  DocumentViewController.swift
//  Swift_ToDoList
//
//  Created by Eva Fadhillah Ulia on 20/12/24.
//

import UIKit

class DocumentViewController: UIViewController, UITableViewDataSource {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.separatorStyle = .singleLine
        table.separatorColor = .lightGray
        table.backgroundColor = UIColor.systemGray5 // Soft, light background for the table
        return table
    }()
    
    var items = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []
        
        title = "To Do List"
        
        // Set background color for the entire view to a soft color
        view.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.1) // Light soft background color
        
        // Customizing the navigation bar
        navigationController?.navigationBar.barTintColor = UIColor.systemTeal
        navigationController?.navigationBar.tintColor = .blue
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.black,
            .font: UIFont.boldSystemFont(ofSize: 18)
        ]
        
        // Adding table view and setting constraints
        view.addSubview(table)
        table.dataSource = self
        table.frame = view.bounds
        
        // Add right bar button item with custom icon
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(didTapAdd)
        )
    }
    
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter New To Do List Item",
                                       preferredStyle: .alert)
        alert.addTextField { field in
            field.placeholder = "Enter Item"
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .default, handler: { [weak self] _ in
            if let field = alert.textFields?.first, let text = field.text, !text.isEmpty {
                DispatchQueue.main.async {
                    var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                    currentItems.append(text)
                    UserDefaults.standard.setValue(currentItems, forKey: "items")
                    self?.items.append(text)
                    self?.table.reloadData()
                }
            }
        }))
        
        present(alert, animated: true)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        // Customizing the cell appearance
        cell.textLabel?.text = items[indexPath.row]
        cell.textLabel?.font = UIFont.systemFont(ofSize: 16)
        cell.textLabel?.textColor = UIColor.black
        cell.selectionStyle = .none
        cell.contentView.backgroundColor = UIColor.systemGray6.withAlphaComponent(0.7) // Soft, light color for cell
        
        // Adding a custom background color to the cell
        let bgColorView = UIView()
        bgColorView.backgroundColor = UIColor.systemTeal.withAlphaComponent(0.3)
        cell.selectedBackgroundView = bgColorView
        
        return cell
    }
}
