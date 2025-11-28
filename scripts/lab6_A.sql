CREATE TYPE gift_list AS TABLE OF VARCHAR2(100);
/
CREATE TABLE gift_catalog (
  gift_id      NUMBER PRIMARY KEY,
  min_purchase NUMBER,
  gifts        gift_list
)
NESTED TABLE gifts STORE AS gift_list_store;
/
INSERT INTO gift_catalog VALUES (
  1,
  100,
  gift_list('Stickers','Pen Set')
);

INSERT INTO gift_catalog VALUES (
  2,
  1000,
  gift_list('Teddy Bear','Mug','Perfume Sample')
);

INSERT INTO gift_catalog VALUES (
  3,
  10000,
  gift_list('Backpack','Thermos Bottle','Chocolate Collection')
);
/

