const express = require('express');
const bcrypt = require('bcrypt');  // pentru criptarea parolelor
const session = require('express-session');
const mysql = require('mysql2');
const bodyParser = require('body-parser');
const path = require('path');
const https = require('https');
const http = require('http');
const fs = require('fs');
const helmet = require('helmet');

const app = express();
const portHttps = 443;  // Portul pe care va rula serverul HTTPS
const portHttp = 80;    // Portul pentru redirecționare HTTP -> HTTPS

// Încarcă certificatul SSL pentru HTTPS
let optiuni = {};
try {
    optiuni = {
        key: fs.readFileSync('/etc/letsencrypt/live/competitie.duckdns.org/privkey.pem'),
        cert: fs.readFileSync('/etc/letsencrypt/live/competitie.duckdns.org/fullchain.pem'),
    };
} catch (err) {
    console.error("⚠️ Eroare la încărcarea certificatelor SSL:", err);
    process.exit(1);
}

// Configurare sesiune
app.use(session({
    secret: 'cheie-secreta-pentru-sesiuni',
    resave: false,
    saveUninitialized: true,
    cookie: { secure: true }  // Setează `true` deoarece folosim HTTPS
}));

// Middleware pentru procesarea datelor din formular
app.use(bodyParser.urlencoded({ extended: false }));

// Conectarea la MySQL
const db = mysql.createConnection({
    host: 'localhost',
    user: 'root',            // utilizator MySQL
    password: 'winner123',   // introdu parola ta pentru root
    database: 'competitie_db'  // baza de date pe care o folosești
});

db.connect((err) => {
    if (err) {
        console.error('Eroare la conectare:', err);
        return;
    }
    console.log('Conectat la baza de date');
});

// Setăm ejs ca motor de vizualizare
app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'cris_public')));
app.set('views', path.join(__dirname, 'cris_views'));

// Rutele pentru fiecare pagină
app.get("/", (req, res) => {
    res.render("index");
});

app.get("/despre", (req, res) => {
    res.render("despre");
});

app.get("/servicii", (req, res) => {
    res.render("servicii");
});

app.get("/marturii", (req, res) => {
    res.render("marturii");
});

app.get("/echipa", (req, res) => {
    res.render("echipa");
});

app.get("/FAQ", (req, res) => {
    res.render("FAQ");
});

app.get("/contact", (req, res) => {
    res.render("contact");
});
app.get("/testlogare", (req, res) => {
    res.render("testlogare");
});


// Ruta pentru pagina de logare (formular)
app.get('/logare', (req, res) => {
    res.render('logare', { errorMessage: null });  // fișierul .ejs cu formularul de login
});

// Ruta POST pentru procesarea login-ului
app.post('/logare', (req, res) => {
    const { username, password } = req.body;  // preia datele trimise de formular

    // Verificăm dacă utilizatorul există în baza de date
    db.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
        if (err) {
            console.error('Eroare la interogare:', err);
            return res.status(500).send('Eroare server');
        }

        if (results.length === 0) {
            // Dacă nu există utilizator cu acest username
            return res.render('logare', { errorMessage: 'Username sau parolă greșite' });
        }

        const user = results[0];  // presupunem că există un singur utilizator cu acest username

        // Verificăm dacă parola este corectă
        bcrypt.compare(password, user.password, (err, isMatch) => {
            if (err) {
                console.error('Eroare la compararea parolelor:', err);
                return res.status(500).send('Eroare server');
            }

            if (!isMatch) {
                // Dacă parola nu se potrivește
                return res.render('logare', { errorMessage: 'Username sau parolă greșite' });
            }

            // Inițiem sesiunea utilizatorului
            req.session.user = user;  // salvăm informațiile utilizatorului în sesiune

            // Verificăm dacă utilizatorul este organizator
            if (user.organizer === 1) {
                return res.redirect('/testlogare');  // Pagina pentru organizatori
            } else {
                return res.redirect('/testlogare');  // Pagina pentru utilizatori normali
            }
        });
    });
});

// Ruta pentru pagina de inregistrare (formular)
app.get('/inregistrare', (req, res) => {
    res.render('inregistrare');  // fișierul .ejs cu formularul de inregistrare
});

// Ruta POST pentru procesarea înregistrării
app.post('/inregistrare', (req, res) => {
    const { username, email, password, organizer } = req.body;  // preia datele trimise de formular

    // Verificăm dacă utilizatorul există deja în baza de date
    db.query('SELECT * FROM users WHERE username = ?', [username], (err, results) => {
        if (err) {
            console.error('Eroare la interogare:', err);
            return res.status(500).send('Eroare server');
        }

        if (results.length > 0) {
            return res.status(400).send('Acest username este deja luat!');
        }

        // Criptăm parola
        bcrypt.hash(password, 10, (err, hashedPassword) => {
            if (err) {
                console.error('Eroare la criptarea parolei:', err);
                return res.status(500).send('Eroare server');
            }

            // Inserăm utilizatorul în baza de date, cu rolul de organizator dacă este selectat
            const query = 'INSERT INTO users (username, email, password, organizer) VALUES (?, ?, ?, ?)';
            db.query(query, [username, email, hashedPassword, organizer ? 1 : 0], (err, result) => {
                if (err) {
                    console.error('Eroare la inserare:', err);
                    return res.status(500).send('Eroare server');
                }

                // Redirecționăm utilizatorul la pagina de logare după înregistrare
                res.redirect('/logare');
            });
        });
    });
});

// Ruta pentru dashboard-ul organizatorului
app.get('/dashboard-organizator', (req, res) => {
    if (!req.session.user || req.session.user.organizer !== 1) {
        return res.redirect('/logare');  // Dacă nu este organizator, redirecționăm la logare
    }
    res.render('dashboard-organizator');  // Pagina dedicată organizatorilor
});

// Ruta pentru dashboard-ul utilizatorilor
app.get('/dashboard', (req, res) => {
    if (!req.session.user) {
        return res.redirect('/logare');  // Dacă nu este autentificat, redirecționăm la logare
    }
    res.render('dashboard');  // Pagina standard pentru utilizatori
});

// Pornirea serverului HTTPS
https.createServer(optiuni, app).listen(portHttps, '0.0.0.0', () => {
    console.log(`✅ Serverul rulează securizat la https://competitie.duckdns.org`);
});

// Redirecționare HTTP -> HTTPS
http.createServer((req, res) => {
    const host = req.headers['host'] ? req.headers['host'].split(':')[0] : 'competitie.duckdns.org';
    res.writeHead(301, { "Location": `https://${host}${req.url}` });
    res.end();
}).listen(portHttp, '0.0.0.0', () => {
    console.log('🔄 Redirecționare HTTP către HTTPS');
});
