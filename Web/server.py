from tinydb import TinyDB, Query
from flask import Flask
from google.cloud import firestore
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

if __name__ == '__main__':
    get_books()
    app.run()
