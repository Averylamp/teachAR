import firebase_admin
from firebase_admin import credentials
from firebase_admin import db
import os
import glob

# grab the json file
dir_path = os.path.dirname(os.path.realpath(__file__))
json_key = glob.glob(os.path.join(dir_path, "*.json"))[0]
print(json_key)
cred = credentials.Certificate(json_key)
default_app = firebase_admin.initialize_app(cred)

print(default_app)

# Initialize the app with a service account, granting admin privileges
# firebase_admin.initialize_app(cred, {
#     'databaseURL': 'https://my-project-1489090681288.firebaseio.com'
# })

# As an admin, the app has access to read and write all data, regradless of Security Rules
ref = db.reference('/books')
print(ref.get())
