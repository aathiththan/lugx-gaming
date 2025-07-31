const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Sequelize, DataTypes } = require('sequelize');
require('dotenv').config();

const app = express();
app.use(bodyParser.json());
app.use(cors());

const sequelize = new Sequelize(process.env.DB_NAME, process.env.DB_USER, process.env.DB_PASS, {
  host: process.env.DB_HOST,
  dialect: 'mysql'
});

const Game = sequelize.define('Game', {
  name: { type: DataTypes.STRING, allowNull: false },
  category: { type: DataTypes.STRING, allowNull: false },
  releaseDate: { type: DataTypes.DATE },
  price: { type: DataTypes.FLOAT }
});

sequelize.sync();

app.get('/games', async (req, res) => res.json(await Game.findAll()));
app.post('/games', async (req, res) => res.json(await Game.create(req.body)));
app.get('/games/:id', async (req, res) => res.json(await Game.findByPk(req.params.id)));
app.put('/games/:id', async (req, res) => {
  const game = await Game.findByPk(req.params.id);
  await game.update(req.body);
  res.json(game);
});
app.delete('/games/:id', async (req, res) => {
  const game = await Game.findByPk(req.params.id);
  await game.destroy();
  res.sendStatus(204);
});

app.listen(3001, () => console.log('Game Service running on port 3001'));
