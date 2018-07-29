from flask import Flask
from flask import render_template
from google.cloud import firestore
from objects import Book, Image
import objects
import csv
import os
import glob

app = Flask(__name__)

@app.route('/get_book/<book_id>')
def get_book_info(book_id):
    return db.search(where('bookID')==book_id)

def get_books():
    """
        Precondition: `export GOOGLE_APPLICATION_CREDENTIALS='<PATH TO JSON'`
    """
    dir_path = os.path.dirname(os.path.realpath(__file__))
    json_key = glob.glob(os.path.join(dir_path, "*.json"))[0]
    export_command = "export GOOGLE_APPLICATION_CREDENTIALS='{}'".format(json_key)
    print(export_command)
    # TODO(ethan): this doesn't seem to work
    os.system(export_command)

    db = firestore.Client()
    books_ref = db.collection(u"books")
    docs = books_ref.get()
    # for d in docs:
    #     print(d.to_dict())
    # print(docs)
    for d in docs:
        print(d.id)
        print(d.to_dict)

def process_image_form(db, bookID, imageID, description, height, width, textbookImageURL, ARImageURLs, links, title, videoURLs):
    books_ref = db.collection(u"books").document(bookID).collection("images").document(imageID)
    image = Image(imageID, description, height, width, textbookImageURL, ARImageURLs, links, title, videoURLs)
    return books_ref.set(image.to_dict())

def process_books_form(db, bookID, coverURL, chatID, expertID, name, author):
    books_ref = db.collection(u"books").document(bookID)
    book = Book(bookID, coverURL, chatID, expertID, name, author)
    return books_ref.set(book.to_dict()) 
    
@app.route("/<bookid>/view_images")
def homepage(bookid):
    db = firestore.Client()
    images = db.collection(u"books").document(bookid).collection("images").get()
    all_images = [i.to_dict() for i in images]
    return render_template("index.html", images=all_images)

if __name__ == '__main__':
    app.run()
