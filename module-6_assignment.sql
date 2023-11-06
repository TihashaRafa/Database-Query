-- Customer table create

CREATE TABLE
    `customers` (
        `customer_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `customer_name` VARCHAR NOT NULL,
        `email` VARCHAR NOT NULL,
        `location` VARCHAR NOT NULL,

`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
);

-- Order table Create

CREATE TABLE
    `orders` (
        `order_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `order_num` INT NOT NULL,
        `customer_id` bigint(20) UNSIGNED NOT NULL,
        `order_date` DATE NOT NULL,
        `total_amount` DECIMAL(10, 2) NOT NULL,
        -- Example: 10 digits with 2 decimal places

`created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP(),
`updated_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP() ON UPDATE CURRENT_TIMESTAMP(),
FOREIGN KEY (`customer_id`) REFERENCES `customers`(`id`) ON DELETE RESTRICT ON UPDATE CASCADE
);

-- products table create

CREATE TABLE
    `products` (
        `product_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `product_name` VARCHAR(255) NOT NULL,
        `description` TEXT,
        `price` DECIMAL(10, 2) NOT NULL
    );

-- Categories table create

CREATE TABLE
    `categories` (
        `category_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `category_name` VARCHAR(255) NOT NULL
    );

-- order items Table create

CREATE TABLE
    `order_items` (
        `order_item_id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
        `order_id` bigint(20) UNSIGNED NOT NULL,
        `product_id` bigint(20) UNSIGNED NOT NULL,
        `quantity` INT NOT NULL,
        `unit_price` DECIMAL(10, 2) NOT NULL,
        FOREIGN KEY (`order_id`) REFERENCES `orders`(`order_id`) ON DELETE CASCADE,
        FOREIGN KEY (`product_id`) REFERENCES `products`(`product_id`) ON DELETE RESTRICT
    );

-- Task-1 Query

SELECT
    c.customer_id,
    c.customer_name,
    c.email,
    c.location,
    COUNT(o.order_id) AS total_orders
FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    c.email,
    c.location
ORDER BY total_orders DESC;

-- Task-2 Query

SELECT
    oi.order_id,
    p.product_name,
    oi.quantity, (oi.quantity * oi.unit_price) AS total_amount
FROM order_items oi
    INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY oi.order_id ASC;

-- Task-3 Query

SELECT
    c.category_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM categories c
    LEFT JOIN products p ON c.category_id = p.category_id
    LEFT JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY c.category_name
ORDER BY total_revenue DESC;

-- Task-4 Query

SELECT
    c.customer_name,
    SUM(oi.quantity * oi.unit_price) AS total_purchase_amount
FROM customers c
    LEFT JOIN orders o ON c.customer_id = o.customer_id
    LEFT JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
ORDER BY
    total_purchase_amount DESC
LIMIT 5;