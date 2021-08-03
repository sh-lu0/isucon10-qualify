DROP DATABASE IF EXISTS isuumo;
CREATE DATABASE isuumo;

DROP TABLE IF EXISTS isuumo.estate;
DROP TABLE IF EXISTS isuumo.chair;

CREATE TABLE isuumo.estate
(
    id          INTEGER             NOT NULL PRIMARY KEY,
    name        VARCHAR(64)         NOT NULL,
    description VARCHAR(4096)       NOT NULL,
    thumbnail   VARCHAR(128)        NOT NULL,
    address     VARCHAR(128)        NOT NULL,
    latitude    DOUBLE PRECISION    NOT NULL,
    longitude   DOUBLE PRECISION    NOT NULL,
    rent        INTEGER             NOT NULL,
    door_height INTEGER             NOT NULL,
    door_width  INTEGER             NOT NULL,
    features    VARCHAR(64)         NOT NULL,
    popularity  INTEGER             NOT NULL,
    door_height_type INTEGER
        AS ((CASE WHEN (door_height < 80) THEN 1
        WHEN (door_height < 110) THEN 2
        WHEN (door_height < 150) THEN 3
        ELSE 4 END)) NOT NULL,
    door_width_type INTEGER
        AS ((CASE WHEN (door_width < 80) THEN 1
        WHEN (door_width < 110) THEN 2
        WHEN (door_width < 150) THEN 3
        ELSE 4 END)) NOT NULL,
    popularity_desc INTEGER AS (-popularity) NOT NULL,
    -- location_point POINT AS (POINT(latitude, longitude)) STORED NOT NULL,
    location_point GEOMETRY AS (ST_GeometryFromText(CONCAT('POINT(', latitude, ' ', longitude, ')'))) STORED NOT NULL,
    SPATIAL INDEX (location_point),
    INDEX idx_id(id),
    INDEX idx_rent(rent),
    INDEX idx_popularity_desc_id(popularity_desc, id),
    INDEX idx_door_height_door_width(door_height, door_width),
    INDEX idx_rent_door_width(rent, door_width),
    INDEX idx_rent_door_height(rent, door_height),
    SPATIAL KEY idx_location_point (location_point),
    INDEX idx_latitude_longitude(latitude,longitude)
);

CREATE TABLE isuumo.chair
(
    id          INTEGER         NOT NULL PRIMARY KEY,
    name        VARCHAR(64)     NOT NULL,
    description VARCHAR(4096)   NOT NULL,
    thumbnail   VARCHAR(128)    NOT NULL,
    price       INTEGER         NOT NULL,
    height      INTEGER         NOT NULL,
    width       INTEGER         NOT NULL,
    depth       INTEGER         NOT NULL,
    color       VARCHAR(64)     NOT NULL,
    features    VARCHAR(64)     NOT NULL,
    kind        VARCHAR(64)     NOT NULL,
    popularity  INTEGER         NOT NULL,
    stock       INTEGER         NOT NULL,
    popularity_desc INTEGER AS (-popularity) NOT NULL,
    INDEX idx_id(id),
    INDEX idx_price_stock(price, stock),
    INDEX idx_kind_stock(kind, stock),
    INDEX idx_height_stock(height, stock),
    INDEX idx_popularity_desc_id(popularity_desc, id),
    INDEX idx_price_id(price, id)
);
