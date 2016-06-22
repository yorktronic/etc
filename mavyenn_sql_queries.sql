# Create a copy of orders
CREATE TABLE orders_copy LIKE orders; INSERT orders_copy SELECT * FROM orders;

# Creating a loop for this since I don't know any other way to do it at the moment
DROP PROCEDURE IF EXISTS GET_AVERAGES()
DELIMITER ;;
CREATE PROCEDURE GET_AVERAGES()
BEGIN
DECLARE n INT DEFAULT 0;
SELECT COUNT(*) FROM orders_copy INTO n;
WHILE n > 0 DO

    # Creates a table called user_orders which will contain entries for one users' orders
    DROP TABLE IF EXISTS user_orders; 
    CREATE TABLE user_orders (
    user_id INT, order_id INT, order_date TEXT
    );

    # Inserts the data for one users' orders into user_orders
    INSERT INTO user_orders (user_id, order_id, order_date)
    SELECT user_id, order_id, order_date
    FROM orders_copy
    WHERE orders_copy.user_id = (SELECT MIN(user_id) FROM orders_copy)

    # Calculates the average difference between the order dates in user_orders and inserts it in to the user table
    # TODO, fix the issue where the code below won't input the user_id in to the table
    INSERT INTO users (user_id, avg_time_between_orders)
    SELECT AVG(difference) as 'avg_time_between_orders'
        FROM ( 
        SELECT A.order_id, A.order_date, DATEDIFF(IFNULL(B.order_date, 0), A.order_date) as difference
            FROM user_orders A CROSS JOIN user_orders B
                WHERE B.order_id IN (SELECT MIN(C.order_id) FROM user_orders C WHERE C.order_id > A.order_id) 
                    ORDER BY A.order_id ASC ) as A
        WHERE (A.order_id > (SELECT min(order_id) from user_orders)) AND (A.order_id < (SELECT max(order_id) from user_orders))
    
    # Delete all rows pertaining to the user_id we just dealt with
    # Eventually the row count for the temporary copy of the orders table will equal zero after this loop is done dropping rows
    DELETE FROM orders_copy
        WHERE user_id = (SELECT MIN(user_id) FROM orders)
    
END WHILE;
End;
;;
DELIMITER ;