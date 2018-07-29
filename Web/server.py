from flask import Flask, render_template, flash, request
from wtforms import Form, TextField, TextAreaField, validators, StringField, SubmitField
from google.cloud import firestore
from objects import Book, Image
from content_loader import content_loader_page
import objects
import csv
import os
import glob

# TODO(ethan): reove debug
DEBUG=True
app = Flask(__name__)
app.config.from_object(__name__)
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'

@app.route('/get_book/<book_id>')
def get_book_info(book_id):
    return db.search(where('bookID')==book_id)

@app.route("/content_loader", methods=['GET', 'POST'])
def content_loader_3():
    db = firestore.Client()
    books = db.collection(u"books").get()
    all_books = [i.to_dict() for i in books]
    return content_loader_page(db, all_books)

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
    books = db.collection(u"books").get()
    all_books = [i.to_dict() for i in books]
    print(all_images)
    return render_template("index.html", images=all_images, books=all_books)

if __name__ == '__main__':
    app.run(host="0.0.0.0")
