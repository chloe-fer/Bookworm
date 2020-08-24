//
//  DetailView.swift
//  Bookworm
//
//  Created by Chloe Fermanis on 23/8/20.
//  Copyright © 2020 Chloe Fermanis. All rights reserved.
//

import SwiftUI
import CoreData

struct DetailView: View {
    
    let book: Book
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State private var showingDeleteAlert = false
    
    var dateFomatter: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter.string(from: book.date!)
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            VStack {
                ZStack(alignment: .bottomTrailing) {
                    Image(self.book.genre ?? "Fantasy")
                        .frame(maxWidth: geometry.size.width)
                    
                    Text(self.book.genre?.uppercased() ?? "FANTASY")
                        .font(.caption)
                        .fontWeight(.black)
                        .padding(8)
                        .foregroundColor(.white)
                        .background(Color.black.opacity(0.75))
                        .clipShape(Capsule())
                        .offset(x: -5, y: -5)
                }
                
                Text(self.book.author ?? "Unknown Author")
                    .font(.title)
                    .foregroundColor(.secondary)
                RatingView(rating: .constant(Int(self.book.rating)))
                    .font(.largeTitle)
                Text(self.book.review ?? "No review")
                    .padding()
                Spacer()
                
                Text(self.dateFomatter)
                
                Spacer()
            }
        }
        .navigationBarTitle(Text(book.title ?? "Unknown Book"), displayMode: .inline)
        .navigationBarItems(trailing: Button(action: {
            self.showingDeleteAlert = true
        }) {
            Image(systemName: "trash")
        })
        .alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Book"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deleteBook()
                }, secondaryButton: .cancel()
            )
        }
    }
   
    func deleteBook() {
        moc.delete(book)
        try? self.moc.save()
        presentationMode.wrappedValue.dismiss()
    }
}

struct DetailView_Previews: PreviewProvider {
    
    static let moc = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
    
    static var previews: some View {
        
        let book = Book(context: moc)
        book.title = "Test Book"
        book.author = "Test Author"
        book.genre = "Fantasy"
        book.rating = 4
        book.review = "This book was ok."
        
        return NavigationView {
            DetailView(book: book)
        }
    }
}
