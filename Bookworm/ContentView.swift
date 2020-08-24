//
//  ContentView.swift
//  Bookworm
//
//  Created by Chloe Fermanis on 22/8/20.
//  Copyright © 2020 Chloe Fermanis. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var moc
    
    @FetchRequest(entity: Book.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Book.title, ascending: true), NSSortDescriptor(keyPath: \Book.author, ascending: true)
    ]) var books: FetchedResults<Book>
    
    
    
    @State private var showingAddScreen = false
    
    var body: some View {
        
        NavigationView {
            
            List {
             
                ForEach(books, id: \.self) { book in
                    NavigationLink(destination: DetailView(book: book)) {
                        EmojiRatingView(rating: book.rating)
                            .font(.largeTitle)
                    
                        VStack(alignment: .leading) {
                            Text(book.title ?? "Unknown Title")
                                .foregroundColor(book.rating == 1 ? .red : .black)
                                .font(.headline)
                            Text(book.author ?? "Unknown Author")
                                .foregroundColor(.secondary)
                        }
                    }
                    
                }
            .onDelete(perform: deleteBooks)
            }
            
                .navigationBarTitle("Bookworm", displayMode: .inline)
                .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                    self.showingAddScreen.toggle()
                    
                })
                {
                    Image(systemName: "plus.circle.fill")
                        .font(.system(size: 25))
                        
                    
                })
                .sheet(isPresented: $showingAddScreen) {
                    AddBookView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    func deleteBooks(at offsets: IndexSet) {
        for offset in offsets {
            let book = books[offset]
            moc.delete(book)
        }
        try? moc.save()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
