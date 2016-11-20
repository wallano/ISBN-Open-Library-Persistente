//
//  BookDetailsViewController.swift
//  Consulta Persistente ISBN
//
//  Created by Walter Llano on 20/11/2016.
//  Copyright © 2016 Walter Llano. All rights reserved.
//

import UIKit

class BookDetailsViewController: UIViewController {

   var book : Book!

   @IBOutlet weak var bookTitle : UILabel!
   @IBOutlet weak var bookISBN : UILabel!
   @IBOutlet weak var bookAuthors : UILabel!
   @IBOutlet weak var bookCover : UIImageView!

   override func viewDidLoad() {

      super.viewDidLoad()
   }

   override func viewWillAppear(_ animated: Bool) {

      bookCover.layer.borderColor = UIColor.black.cgColor
      bookCover.layer.borderWidth = 1.0
      bookTitle.text = self.book.title
      bookISBN.text = "ISBN: " + self.book.isbnCode
      bookAuthors.text = self.createAuthorList(self.book.authors)
      bookCover.image = self.book.cover
   }

   override func didReceiveMemoryWarning() {

      super.didReceiveMemoryWarning()
   }

   func createAuthorList (_ authors: [String]) -> String {

      var prefix = String()
      var authorList = String()

      for author in authors {

         authorList = authorList + prefix + author
         prefix = "\n"
      }

      return authorList
   }
}
