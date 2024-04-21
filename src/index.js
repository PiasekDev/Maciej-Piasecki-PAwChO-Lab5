import express from 'express';
import { hostname } from 'os';

const app = express();

app.get('/', (req, res) => {
	res.send(`Adres IP serwera: ${req.socket.localAddress}<br>Nazwa serwera (hostname): ${hostname()}<br>Wersja aplikacji ($VERSION): ${process.env.npm_package_version}`);
});

app.listen(8080, () => {
	console.log('Listening on port 8080');
});
