from tinydb import TinyDB, Query
from flask import Flask
from google.cloud import firestore
from objects import Books, Images
import objects
import csv

app = Flask(__name__)

@app.route('/get_book/<book_id>')
def get_book_info(book_id):
    return db.search(where('bookID')==book_id)

def get_books():
    """
        Precondition: `export GOOGLE_APPLICATION_CREDENTIALS='<PATH TO JSON'`
    """
    db = firestore.Client()
    books_ref = db.collection(u"books")
    docs = books_ref.get()
    for d in docs:
        print(d.to_dict())

def process_image_form(db, bookID, imageID, description, height, width, textbookImageURL, ARImageURLs, links, title, videoURLs):
    books_ref = db.collection(u"books").document(bookID).collection("images").document(imageID) 
    image = Image(imageID, description, height, width, textbookImageURL, ARImageURLs, links, title, videoURLs) 
    return books_ref.set(image.to_dict()) 

def process_books_form(db, bookID, chatID, name, author): 
    books_ref = db.collection(u"books").document(bookID)
    book = Book(bookID, chatID, expertID, name, author:
    return books_ref.set(book.to_dict()) 
    
if __name__ == '__main__':
    app.run()
