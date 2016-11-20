//
//  BookListTableViewController.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit
import CoreData

class BookListTableViewController: UITableViewController {

   var books = [Book]()
   var context: NSManagedObjectContext!

   override func viewDidLoad() {

      super.viewDidLoad()

      context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
      fetchBooksFromStorage()
   }

   override func didReceiveMemoryWarning() {

      super.didReceiveMemoryWarning()
   }

   override func viewWillAppear(_ animated: Bool) {

      tableView.reloadData()
   }

   override func numberOfSections(in tableView: UITableView) -> Int {

      return 1
   }

   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

      return books.count
   }

   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

      let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)

      cell.textLabel?.text = books[(indexPath as NSIndexPath).row].title

      return cell
   }

   override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {

      if (sender is UITableViewCell) {

         (segue.destination as! BookDetailsViewController).book = books[(tableView.indexPathForSelectedRow! as NSIndexPath).row]
      }

      if (sender is UIBarButtonItem) {

         (segue.destination as! BookSearchViewController).bookList = self
      }
   }

   func fetchBooksFromStorage () {

      let bookEntity = NSEntityDescription.entity(forEntityName: "Book", in: context!)

      let fetchAllBooks = bookEntity?.managedObjectModel.fetchRequestTemplate(forName: "AllBooks")

      do {

         let fetchedBooks = try context.fetch(fetchAllBooks!)

         for fetchedBook in fetchedBooks {

            let isbn = fetchedBook.value(forKey: "isbn") as! String
            let title = fetchedBook.value(forKey: "title") as! String
            let author = fetchedBook.value(forKey: "author") as! [String]
            let cover = fetchedBook.value(forKey: "cover")

            var book = Book(isbnCode: isbn, title: title, authors: author, cover: UIImage())

            if cover != nil {

               book.cover = UIImage(data: cover as! Data)!
            }

            books.append(book)
         }

      } catch {

         print("\(#function): Unable to execute fetch request!")
      }
   }
}
