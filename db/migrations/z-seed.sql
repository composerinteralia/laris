INSERT INTO
  houses (id, address)
VALUES
  (1, "26th and Guerrero"), (2, "Dolores and Market");

INSERT INTO
  humans (id, fname, lname, house_id)
VALUES
  (1, "Devon", "Watts", 1),
  (2, "Matt", "Rubens", 1),
  (3, "Ned", "Ruggeri", 2),
  (4, "Catless", "Human", NULL);

INSERT INTO
  cats (id, name, owner_id)
VALUES
  (1, "Breakfast", 1),
  (2, "Earl", 2),
  (3, "Haskell", 3),
  (4, "Markov", 3),
  (5, "Stray Cat", NULL);
