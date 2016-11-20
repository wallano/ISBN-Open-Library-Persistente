//
//  BookSearchViewController.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit
import CoreData

class BookSearchViewController: UIViewController {

   @IBOutlet weak var isbnTextField : UITextField!

   private let baseurl = "https://openlibrary.org/api/books?jscmd=data&format=json&bibkeys=ISBN:"

   var book : Book!
   var bookList : BookListTableViewController!
   var context: NSManagedObjectContext!

   override func viewDidLoad() {

      super.viewDidLoad()

      context = (UIApplication.shared.delegate as! AppDelegate).managedObjectContext
   }

   override func didReceiveMemoryWarning() {

      super.didReceiveMemoryWarning()
   }

   override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {

      isbnTextField.text = nil
      (segue.destination as! BookDetailsViewController).book = self.book
   }

   func searchBook (_ isbn: String, completionHandler: (book: Book) -> Void) {

      URLSession.shared.dataTask(with: URL(string: baseurl + isbn)!, completionHandler: {(data, response, error) in

         if error != nil {

            DispatchQueue.main.async(execute: {

               ProgressView.sharedInstance.hideProgressView()
            })

            self.showAlertDialog("Error", message: error!.localizedDescription)

         } else {

            var book = Book(isbnCode: isbn, title: "Título No Definido", authors: [ "Autor No Definido" ], cover: UIImage())

            do {

               if let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : AnyObject] {

                  if let bookJson = json["ISBN:" + isbn] as? [String : AnyObject] {

                     if let authors = bookJson["authors"] as? [AnyObject] {

                        book.authors.removeAll()

                        for author in authors {

                           book.authors.append(author["name"] as! String)
                        }
                     }

                     if let title = bookJson["title"] as? String {

                        book.title = title
                     }

                     if let cover = bookJson["cover"]?["large"] as? String {

                        if let coverImg = UIImage(data: try! Data(contentsOf: URL(string: cover)!)) {

                           book.cover = coverImg
                        }
                     }

                     completionHandler(book: book)

                  } else {

                     DispatchQueue.main.async(execute: {

                        self.isbnTextField.text = nil
                        ProgressView.sharedInstance.hideProgressView()
                     })

                     self.showAlertDialog("Error", message: "El Libro con ISBN \(isbn) no Existe!")
                  }
               }

            } catch _ {

               DispatchQueue.main.async(execute: {

                  ProgressView.sharedInstance.hideProgressView()
               })

               self.showAlertDialog("Error", message: "Respuesta invalida del servidor openlibrary.org")
            }
         }

      }).resume()
   }

   func showAlertDialog (_ title: String, message: String) {

      let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

      DispatchQueue.main.async(execute: {

         self.present(alert, animated: true, completion: nil)
      })
   }

   func findBookInTable (_ isbn: String) -> Book! {

      var bookFound : Book!

      for book in bookList.books {

         if isbn == book.isbnCode {

            bookFound = book
            break
         }
      }

      return bookFound
   }

   @IBAction func search (_ sender: UITextField) {

      sender.resignFirstResponder()

      if let isbn = sender.text where !isbn.isEmpty {

         if let book = findBookInTable(isbn) {

            self.book = book
            performSegue(withIdentifier: "bookSegue", sender: sender)

         } else {

            ProgressView.sharedInstance.showProgressView(view)

            searchBook(isbn) { bookFound in

               self.book = bookFound
               self.bookList.books.append(bookFound)

               let bookEntity = NSEntityDescription.insertNewObject(forEntityName: "Book", into: self.context!)

               bookEntity.setValue(bookFound.isbnCode, forKey: "isbn")
               bookEntity.setValue(bookFound.title, forKey: "title")
               bookEntity.setValue(bookFound.authors, forKey: "author")
               bookEntity.setValue(UIImageJPEGRepresentation(bookFound.cover, 1.0), forKey: "cover")

               do {

                  try self.context.save()
                  
               } catch {

                  print("\(#function): Unable to save context!")
               }

               DispatchQueue.main.async(execute: {

                  ProgressView.sharedInstance.hideProgressView()
                  self.performSegue(withIdentifier: "bookSegue", sender: sender)
               })
            }
         }
      }
   }
}
