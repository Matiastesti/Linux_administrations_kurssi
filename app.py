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
  body {{ 
      font-family: sans-serif; 
      background: #121212; 
      margin: 0; 
      padding: 40px; 
  }}
  .card {{ 
      max-width: 650px; 
      margin: auto; 
      background: #1e1e1e; 
      padding: 30px; 
      border-radius: 12px; 
      border: 1px solid #2a2a2a;
  }}
  h1, h2, p, b, a {{
      color: #89cff0; 
      -webkit-text-stroke: 0.3px rgba(255, 255, 255, 0.7); 
  }}
  a {{
      color: #64b5f6;
  }}
</style>
</head>
<body>
<div class="card">
  <h1>Viikko 2: Python-verkkosovellus</h1>
  <p>Tämä sivu toimii Flaskilla Nginxin takana.</p>
  <p>Sivun latauksia: <b>{visits}</b></p>
  <p>Laskuri tallennetaan MariaDB-tietokantaan. Jokainen sivun lataus kasvattaa arvoa yhdellä.</p>
  <h2>Uudelleenkäynnistystesti</h2>
  <p><a href="https://github.com/Matiastesti/Linux_administrations_kurssi">Projektin lähdekoodi GitHubissa</a></p>
  <p><a href="http://86.50.20.7/">Viikon 1 etusivulle</a></p>
  <div style="text-align: center; margin-top: 20px;">
    <div class="tenor-gif-embed" data-postid="7291537236500870110" data-share-method="host" data-aspect-ratio="0.694779" data-width="100%"><a href="https://tenor.com/view/coding-expectation-gif-7291537236500870110">Coding Expectation GIF</a>from <a href="https://tenor.com/search/coding+expectation-gifs">Coding Expectation GIFs</a></div> <script type="text/javascript" async src="https://tenor.com/embed.js"></script>
  </div>
</div>
</body>
</html>"""
