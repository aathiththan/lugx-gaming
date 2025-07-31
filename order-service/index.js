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

const Order = sequelize.define('Order', {
  customerName: { type: DataTypes.STRING, allowNull: false },
  totalPrice: { type: DataTypes.FLOAT, allowNull: false }
});

const OrderItem = sequelize.define('OrderItem', {
  gameId: { type: DataTypes.INTEGER, allowNull: false },
  quantity: { type: DataTypes.INTEGER, allowNull: false }
});

Order.hasMany(OrderItem, { as: 'items' });
OrderItem.belongsTo(Order);

sequelize.sync();

app.post('/orders', async (req, res) => {
  const order = await Order.create(req.body, { include: 'items' });
  res.json(order);
});
app.get('/orders', async (req, res) => res.json(await Order.findAll({ include: 'items' })));

app.listen(3002, () => console.log('Order Service running on port 3002'));
