CREATE OR REPLACE PACKAGE customer_manager AS
  FUNCTION get_total_purchase(customer_id NUMBER) RETURN NUMBER;
  PROCEDURE assign_gifts_to_all;
END customer_manager;
/
CREATE OR REPLACE PACKAGE BODY customer_manager AS

  FUNCTION get_total_purchase(customer_id NUMBER) RETURN NUMBER AS
    v_total NUMBER := 0;
  BEGIN
    SELECT NVL(SUM(oi.unit_price * oi.quantity), 0)
    INTO v_total
    FROM orders o
    JOIN order_items oi ON o.order_id = oi.order_id
    WHERE o.customer_id = customer_id
	 AND o.order_status = 'COMPLETE';

    RETURN v_total;
  END get_total_purchase;

  FUNCTION choose_gift_package(p_total_purchase IN NUMBER) RETURN NUMBER IS
    v_gift_id gift_catalog.gift_id%TYPE;
  BEGIN
    SELECT gift_id
    INTO v_gift_id
    FROM gift_catalog
    WHERE min_purchase = (
      SELECT MAX(min_purchase)
      FROM gift_catalog
      WHERE CASE
              WHEN min_purchase <= p_total_purchase THEN 1
              ELSE 0
            END = 1
    );

    RETURN v_gift_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      RETURN NULL;
  END choose_gift_package;

  PROCEDURE assign_gifts_to_all AS
    v_total     NUMBER;
    v_gift_id   NUMBER;
    v_reward_id NUMBER;
  BEGIN
    FOR r IN (SELECT customer_id, email_address FROM customers) LOOP
      v_total := get_total_purchase(r.customer_id);
      v_gift_id := choose_gift_package(v_total);

      IF v_gift_id IS NOT NULL THEN
        SELECT NVL(MAX(reward_id), 0) + 1
        INTO v_reward_id
        FROM customer_rewards;

        INSERT INTO customer_rewards (reward_id, customer_email, gift_id, reward_date)
        VALUES (v_reward_id, r.email_address, v_gift_id, SYSDATE);
      END IF;
    END LOOP;
  END assign_gifts_to_all;

END customer_manager;
/
