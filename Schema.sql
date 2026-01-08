/*
=====================================================
 Pizza Sales Analysis Project – Database Schema
=====================================================

NOTE:
- Tables were imported directly from CSV files.
- This file documents the structure of each table.
- No CREATE TABLE statements were written manually.

Database: pizza_sales
Tool Used: MySQL / MySQL Workbench
=====================================================
*/

-- ===============================
-- Table: orders
-- ===============================
-- Stores order-level information

-- order_id     : INT         → Unique ID for each order
-- order_date   : DATE        → Date when order was placed
-- order_time   : TIME        → Time when order was placed


-- ===============================
-- Table: order_details
-- ===============================
-- Stores item-level details for each order

-- order_details_id : INT          → Unique row identifier
-- order_id         : INT          → References orders.order_id
-- pizza_id         : VARCHAR(50)  → References pizzas.pizza_id
-- quantity         : INT          → Number of pizzas ordered


-- ===============================
-- Table: pizzas
-- ===============================
-- Stores pizza size and price information

-- pizza_id        : VARCHAR(50)   → Unique pizza identifier
-- pizza_type_id   : VARCHAR(50)   → References pizza_types.pizza_type_id
-- size            : CHAR(1)       → Pizza size (S, M, L, XL)
-- price           : DECIMAL(5,2)  → Price of the pizza


-- ===============================
-- Table: pizza_types
-- ===============================
-- Stores pizza category and name

-- pizza_type_id : VARCHAR(50)   → Unique pizza type identifier
-- name          : VARCHAR(100)  → Name of the pizza
-- category      : VARCHAR(50)   → Category (Classic, Veggie, Chicken, Supreme)
