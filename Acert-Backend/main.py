from datetime import datetime
import logging
import os
import json

from flask import Flask, redirect, render_template, request

from google.cloud import datastore
from google.cloud import storage


CLOUD_STORAGE_BUCKET = os.environ.get('CLOUD_STORAGE_BUCKET')


app = Flask(__name__)


@app.route('/')
def homepage():
    datastore_client = datastore.Client()

    query = datastore_client.query(kind='Days')
    day_entities = list(query.fetch())

    return json.loads('{"Hello": "there"}')


@app.errorhandler(500)
def server_error(e):
    logging.exception('An error occurred during a request.')
    return """
    An internal error occurred: <pre>{}</pre>
    See logs for full stacktrace.
    """.format(e), 500


if __name__ == '__main__':
    app.run(host='127.0.0.1', port=8080, debug=True)
