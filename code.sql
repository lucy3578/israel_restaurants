-- Removing the order entries that end up being cancelled 
DELETE FROM orders
WHERE total_order = 0;

-- Shows the number of orders vs. average amount spent per order in each restaurant
SELECT
    avg_price.restaurant_name AS restaurant_name,
    avg_price.avg AS average,
    total_orders.count AS num_of_orders
INTO orders_vs_price
FROM (
    SELECT
        restaurants.restaurant_name,
        AVG(orders.total_order) AS avg
    FROM
        orders
    JOIN
        restaurants ON orders.restaurant_id = restaurants.id_restaurants
    GROUP BY
        restaurants.restaurant_name
) AS avg_price
JOIN (
    SELECT
        restaurants.restaurant_name,
        COUNT(orders.total_order) AS count
    FROM
        orders
    JOIN
        restaurants ON orders.restaurant_id = restaurants.id_restaurants
    GROUP BY
        restaurants.restaurant_name
) AS total_orders ON avg_price.restaurant_name = total_orders.restaurant_name;


-- Shows the number of orders for each of the different types of cuisines
SELECT
    restaurant_types.restaurant_type,
	COUNT(orders.id_order) AS order_count
FROM
    orders
JOIN
    restaurants ON orders.restaurant_id = restaurants.id_restaurants
JOIN
    restaurant_types ON restaurants.restaurant_type_id = restaurant_types.id_restaurant_types
GROUP BY
	restaurant_types.restaurant_type;


-- Shows the number of orders for the different types of protein
SELECT
    meal_types.meal_type,
	COUNT(orders.id_order) AS order_count
FROM
    orders
JOIN
    order_details ON orders.id_order = order_details.order_id
JOIN
    meals ON order_details.meal_id = meals.id_meals
JOIN 
	meal_types ON meals.meal_type_id = meal_types.id_meal_types
GROUP BY
	meal_types.meal_type;


-- Shows the number of orders for hot meals/drinks and cold meals/drinks
SELECT
    meals.hot_cold,
	COUNT(orders.id_order) AS order_count
FROM
    orders
JOIN
    order_details ON orders.id_order = order_details.order_id
JOIN
    meals ON order_details.meal_id = meals.id_meals
GROUP BY
	meals.hot_cold;


-- Seasonal data: comparing the number of hot and cold orders during different seasons
-- WINTER ORDERS
SELECT *
FROM orders
WHERE EXTRACT(MONTH FROM date_order) < 6;

-- SUMMER ORDERS
SELECT *
FROM orders
WHERE EXTRACT(MONTH FROM date_order) > 5;

-- SUMMER HOT/COLD ORDERS
SELECT
    meals.hot_cold,
	COUNT(summer_orders.id_order) AS order_count
FROM
    summer_orders
JOIN
    order_details ON summer_orders.id_order = order_details.order_id
JOIN
    meals ON order_details.meal_id = meals.id_meals
GROUP BY
	meals.hot_cold;

-- WINTER HOT/COLD ORDERS
SELECT
    meals.hot_cold,
	COUNT(winter_orders.id_order) AS order_count
FROM
    winter_orders
JOIN
    order_details ON winter_orders.id_order = order_details.order_id
JOIN
    meals ON order_details.meal_id = meals.id_meals
GROUP BY
	meals.hot_cold;


-- Shows the total spending on food orders in each city
SELECT
    cities.city,
	SUM(orders.total_order)
FROM
    orders
JOIN
    restaurants ON orders.restaurant_id = restaurants.id_restaurants
JOIN
    cities ON restaurants.city_id = cities.id_cities
GROUP BY
	cities.city;


