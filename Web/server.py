from tinydb import TinyDB, Query
from flask import Flask

import csv

app = Flask(__name__)
db = TinyDB("db.json")

@app.route('/get_book/<book_id>')
def get_book_info(book_id):
    return db.search(where('bookID')==book_id)

def read_from_csv():
    with open("books.csv") as f:
        reader = csv.reader(f)
        for row in reader:
            print(row)
            db.insert(row)

if __name__ == '__main__':
    app.run()
