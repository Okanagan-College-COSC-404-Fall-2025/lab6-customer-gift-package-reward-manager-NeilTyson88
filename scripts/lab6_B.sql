CREATE TABLE customer_rewards (
  reward_id      NUMBER PRIMARY KEY,
  customer_email VARCHAR2(255),
  gift_id        NUMBER,
  reward_date    DATE DEFAULT SYSDATE,
  FOREIGN KEY (gift_id) REFERENCES gift_catalog(gift_id)
);
/
