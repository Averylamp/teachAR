"""
The main Flask webapp with_categories will be run as the server.
"""

from flask import Flask, render_template, flash, request, redirect, url_for
from google.cloud import firestore
from endpoints.endpoint_handler import EndpointHandler
import os

# create the flask app
app = Flask(__name__)
# optionally load a config
app.config.from_object(__name__)
# define the secret key
app.config['SECRET_KEY'] = '7d441f27d441f27567d441f2b6176a'
# create one db client that gets passed into other functions
db = firestore.Client()
# endpoing handler takes in the database
EndpointHandler(database=db,
                root_path=os.path.dirname(os.path.abspath(__file__))
                ).add_endpoints(app)

if __name__ == '__main__':
    app.run(host="0.0.0.0",
            port=5000,
            debug=True)
