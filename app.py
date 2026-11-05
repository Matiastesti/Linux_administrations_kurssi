import os
import mariadb
from flask import Flask

app = Flask(__name__)

def get_conn():
    return mariadb.connect(
        user="viikko2user",
        password=os.environ["DB_PASSWORD"],
        host="127.0.0.1",
        database="viikko2",
    )

@app.route("/")
def index():
    conn = get_conn()
    cur = conn.cursor()
    cur.execute("UPDATE counter SET visits = visits + 1 WHERE id = 1")
    conn.commit()
    cur.execute("SELECT visits FROM counter WHERE id = 1")
    visits = cur.fetchone()[0]
    conn.close()

    return f"""<!DOCTYPE html>
<html lang="fi">
<head>
<meta charset="utf-8">
<title>Viikko 2</title>
<style>
  body {{ font-family: sans-serif; background: #e8eef5; margin: 0; padding: 40px; }}
  .card {{ max-width: 650px; margin: auto; background: white; padding: 30px; border-radius: 12px; }}
</style>
</head>
<body>
<div class="card">
  <h1>Viikko 2: Python-verkkosovellus</h1>
  <p>Tämä sivu toimii Flaskilla Nginxin takana.</p>
  <p>Sivun latauksia: <b>{visits}</b></p>
  <p>Laskuri tallennetaan MariaDB-tietokantaan. Jokainen sivun lataus kasvattaa arvoa yhdellä.</p>
  <h2>Uudelleenkäynnistystesti</h2>
  <p>Testi ei ole vielä tehty.</p>
  <p><a href="https://github.com/KÄYTTÄJÄNIMI/REPO">Projektin lähdekoodi GitHubissa</a></p>
  <p><a href="http://86.50.20.7/">Viikon 1 etusivulle</a></p>
</div>
</body>
</html>"""
