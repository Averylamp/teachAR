from flask import Flask
from google.cloud import firestore
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

if __name__ == '__main__':
    get_books()
    app.run()
