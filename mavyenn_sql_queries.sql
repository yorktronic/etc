SELECT AVG(difference)
    FROM ( 
        SELECT A.order_id, A.order_date, DATEDIFF(IFNULL(B.order_date, 0), A.order_date) as difference
            FROM user_orders A CROSS JOIN user_orders B
                WHERE B.order_id IN (SELECT MIN(C.order_id) FROM user_orders C WHERE C.order_id > A.order_id) 
                    ORDER BY A.order_id ASC ) as A
    WHERE (A.order_id > (SELECT min(order_id) from user_orders)) AND (A.order_id < (SELECT max(order_id) from user_orders))