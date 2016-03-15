--LOGIN
SELECT * FROM Customer;
SELECT login('one@hotmail.com','123');
SELECT login('ondsae@hotmail.com','234');

--UPDATE PASSWORD
SELECT * FROM Customer;
SELECT update_password('one@hotmail.com','123','456');
SELECT * FROM Customer;
SELECT update_password('one@hotmail.com','123','456');

--SET PREFERRED SHIPPING ADDRESS
select create_customeraddress('0',2,1);
SELECT * FROM Addresses;
SELECT * FROM Customer_Addresses;
SELECT set_preferred_shipping_address(1,1);
SELECT * FROM Customer_Addresses;
SELECT set_preferred_shipping_address(1,3);
SELECT * FROM Customer_Addresses;

--SET PREFERRED PAYMENT METHOD
SELECT * FROM Credit_Cards;
SELECT set_preferred_payment_method(1, 1);
SELECT * FROM Credit_Cards;
SELECT set_preferred_payment_method(1, 2);
SELECT * FROM Credit_Cards;
SELECT set_preferred_payment_method(1, 5);

--GET AVAILABILITY
SELECT * FROM Product_Supplier;
SELECT get_availability(1);
SELECT * FROM Product_Supplier;
select * from item_list;

--ADD TO CART
SELECT * FROM Cart_Items;
SELECT add_to_cart(1,25,1);
SELECT add_to_cart(2,25,1);
SELECT * FROM Cart_Items;

--REMOVE FROM CART
SELECT * FROM Cart_Items;
SELECT remove_from_cart(1,1);
SELECT * FROM Cart_Items;

--PLACE ORDER
--orders everything in shopping cart
select * from orders;
select * from item_list;
select place_order(1);
select * from orders;
select * from item_list;

--CHARGE CUSTOMER
select * from charges;
select charge_customer(1,1,1);
select charge_customer(1,1,1);
select * from charges;

--SHIP ITEM
select * from shipments;
select * from charges;
select ship_item(2,4);
select * from shipments;
select * from charges;

--SHIP ORDER
SELECT * FROM SHIPMENTS;
select * from charges;
select ship_order(3);
SELECT * FROM SHIPMENTS;
select * from charges;

--UPDATE INVENTORY
select * from product_supplier;
select update_inventory(1,1,-20);
select * from product_supplier;

--TOP UP STORE CREDIT
select * from CUSTOMER;
select top_up_store_credit(2);

--GET PRODUCTS BY CATEGORY
select * from category;
select * from products;
select get_products_by_category(2);

--TRIGGER
select update_inventory(1,1,-999999);
select * from restock;
