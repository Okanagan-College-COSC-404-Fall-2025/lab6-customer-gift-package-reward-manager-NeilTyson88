CREATE PROCEDURE show_customer_rewards AS
BEGIN
  FOR r IN (
    SELECT customer_email, gift_id, min_purchase
    FROM customer_rewards cr
    JOIN gift_catalog gc ON cr.gift_id = gc.gift_id
    WHERE ROWNUM <= 5
  ) LOOP
    DBMS_OUTPUT.PUT_LINE(
      r.customer_email || ' | gift_id: ' || r.gift_id || ' | min_purchase: ' || r.min_purchase
    );
  END LOOP;
END show_customer_rewards;
/
