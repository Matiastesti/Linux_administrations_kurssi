import os
import mariadb
from flask import Flask

app = Flask(__name__)

def get_visits():
    conn = mariadb.connect(
        user="viikko4reader",
        password=os.environ["DB_PASSWORD"],
        host="127.0.0.1",
        database="viikko2",
    )
    cur = conn.cursor()
    cur.execute("SELECT visits FROM counter WHERE id=1")
    row = cur.fetchone()
    conn.close()
    return row[0]

@app.route("/")
def index():
    visits = get_visits()
    return f"""<!DOCTYPE html>
<html lang="en"><head><meta charset="utf-8"><title>Week 4 Server</title></head>
<body style="font-family:sans-serif;max-width:650px;margin:auto;padding:2em">
<h1>Week 4 Server</h1>
<p>Replicated database: <b>{visits}</b></p>
<p><a href="http://86.50.170.206/viikko2/">Week 2 link back</a></p>
</body></html>"""
