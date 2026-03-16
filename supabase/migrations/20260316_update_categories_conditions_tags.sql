-- =============================================================================
-- Migration: Update categories, subcategories, conditions, and tags
-- Date: 2026-03-16
-- Description: Populates marketplace taxonomy per client spreadsheet.
--              Adds category_id to conditions and tags tables.
-- WARNING: This deletes existing categories/subcategories/conditions/tags data.
--          Existing products may lose their category/condition/tag references.
-- =============================================================================

BEGIN;

-- ---------------------------------------------------------------------------
-- 1. Schema changes: add category_id to conditions and tags
-- ---------------------------------------------------------------------------

ALTER TABLE conditions ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES categories(id) ON DELETE SET NULL;
ALTER TABLE tags ADD COLUMN IF NOT EXISTS category_id UUID REFERENCES categories(id) ON DELETE SET NULL;

-- Remove unique constraint on name (conditions now duplicate per category)
ALTER TABLE conditions DROP CONSTRAINT IF EXISTS conditions_name_key;
ALTER TABLE conditions DROP CONSTRAINT IF EXISTS conditions_code_key;
ALTER TABLE tags DROP CONSTRAINT IF EXISTS tags_name_key;
ALTER TABLE tags DROP CONSTRAINT IF EXISTS tags_slug_key;

-- Expand code column to fit longer condition codes
ALTER TABLE conditions ALTER COLUMN code TYPE VARCHAR(50);

-- Add composite unique constraints instead
ALTER TABLE conditions ADD CONSTRAINT conditions_name_category_key UNIQUE (name, category_id);
ALTER TABLE tags ADD CONSTRAINT tags_slug_category_key UNIQUE (slug, category_id);

-- ---------------------------------------------------------------------------
-- 2. Temporarily drop FK constraints, clear data, then restore
-- ---------------------------------------------------------------------------

-- Drop FK constraints from products
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_category_id_fkey;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_subcategory_id_fkey;
ALTER TABLE products DROP CONSTRAINT IF EXISTS products_condition_id_fkey;

-- Temporarily allow NULLs on category_id
ALTER TABLE products ALTER COLUMN category_id DROP NOT NULL;

-- Nullify references
UPDATE products SET condition_id = NULL WHERE condition_id IS NOT NULL;
UPDATE products SET category_id = NULL WHERE category_id IS NOT NULL;
UPDATE products SET subcategory_id = NULL WHERE subcategory_id IS NOT NULL;

-- Clear old data
DELETE FROM tags;
DELETE FROM conditions;
DELETE FROM subcategories;
DELETE FROM categories;

-- ---------------------------------------------------------------------------
-- 3. Insert categories
-- ---------------------------------------------------------------------------

INSERT INTO categories (id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), 'Jewelry', 'jewelry', 1, true),
  (gen_random_uuid(), 'Trading Card Games', 'trading-card-games', 2, true),
  (gen_random_uuid(), 'Sport', 'sport', 3, true),
  (gen_random_uuid(), 'Comics', 'comics', 4, true),
  (gen_random_uuid(), 'Games', 'games', 5, true),
  (gen_random_uuid(), 'Books & Movies', 'books-and-movies', 6, true),
  (gen_random_uuid(), 'Toys and Hobbies', 'toys-and-hobbies', 7, true),
  (gen_random_uuid(), 'Electronics', 'electronics', 8, true),
  (gen_random_uuid(), 'Coins and money', 'coins-and-money', 9, true),
  (gen_random_uuid(), 'Sports memorabilia', 'sports-memorabilia', 10, true),
  (gen_random_uuid(), 'Men''s Fashion', 'mens-fashion', 11, true),
  (gen_random_uuid(), 'Sneakers', 'sneakers', 12, true),
  (gen_random_uuid(), 'Women''s fashion', 'womens-fashion', 13, true),
  (gen_random_uuid(), 'Kids'' Fashion', 'kids-fashion', 14, true),
  (gen_random_uuid(), 'Bags and Accessories', 'bags-and-accessories', 15, true),
  (gen_random_uuid(), 'Beauty and personal care', 'beauty-and-personal-care', 16, true),
  (gen_random_uuid(), 'Music & Audio', 'music-and-audio', 17, true),
  (gen_random_uuid(), 'Video Games', 'video-games', 18, true),
  (gen_random_uuid(), 'Home and Garden', 'home-and-garden', 19, true),
  (gen_random_uuid(), 'Baby and Kids', 'baby-and-kids', 20, true),
  (gen_random_uuid(), 'Handmade & Artisan Goods', 'handmade-and-artisan-goods', 21, true),
  (gen_random_uuid(), 'Manga', 'manga', 22, true),
  (gen_random_uuid(), 'Displays Storage & Preservation', 'displays-storage-and-preservation', 23, true),
  (gen_random_uuid(), 'Food and drink', 'food-and-drink', 24, true),
  (gen_random_uuid(), 'Entertainment cards', 'entertainment-cards', 25, true);

-- ---------------------------------------------------------------------------
-- 4. Insert subcategories
-- ---------------------------------------------------------------------------

-- Jewelry
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Fine and precious metals', 'fine-and-precious-metals', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Vintage and antique jewelry', 'vintage-and-antique-jewelry', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Watches', 'watches', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Men''s jewelry', 'mens-jewelry', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Handcrafted and artisan', 'handcrafted-and-artisan', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Natural Crystal', 'natural-crystal', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='jewelry'), 'Artificial Gemstones', 'artificial-gemstones', 7, true);

-- Trading Card Games
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'One Piece Card Game', 'one-piece-card-game', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Disney Lorcana', 'disney-lorcana', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Gundam Card Game', 'gundam-card-game', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Flesh and Blood', 'flesh-and-blood', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Digimon Card Game', 'digimon-card-game', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Dragon Ball Super Card Game', 'dragon-ball-super-card-game', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Pokémon', 'pokemon', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Magic: The Gathering', 'magic-the-gathering', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Yu-Gi-Oh!', 'yu-gi-oh', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'KeyForge', 'keyforge', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Sorcery: Contested Realm', 'sorcery-contested-realm', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Shadowverse Evolve', 'shadowverse-evolve', 12, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Battle Spirits Saga', 'battle-spirits-saga', 13, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Grand Archive', 'grand-archive', 14, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'MetaZoo', 'metazoo', 15, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Universus', 'universus', 16, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='trading-card-games'), 'Force of Will', 'force-of-will', 17, true);

-- Sport
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Football', 'sport-football', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Basketball', 'sport-basketball', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Baseball', 'sport-baseball', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Soccer', 'sport-soccer', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Motorsport cards', 'sport-motorsport-cards', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Hockey cards', 'sport-hockey-cards', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Golf', 'sport-golf', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sport'), 'Graded', 'sport-graded', 8, true);

-- Comics
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Modern', 'comics-modern', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Vintage', 'comics-vintage', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Graded', 'comics-graded', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Collected Editions/Trades', 'comics-collected-editions', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Underground/Indie', 'comics-underground-indie', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='comics'), 'Comic Supplies', 'comics-supplies', 6, true);

-- Games
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='games'), 'Board Games', 'board-games', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='games'), 'Tabletop RPGs', 'tabletop-rpgs', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='games'), 'Card & Deck Games', 'card-and-deck-games', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='games'), 'Table Top Minis', 'table-top-minis', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='games'), 'Gaming Supplies', 'gaming-supplies', 5, true);

-- Books & Movies
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Fiction', 'fiction', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Fantasy', 'books-fantasy', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Lit-RPG', 'lit-rpg', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Sci-Fi', 'books-sci-fi', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Romance', 'romance', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Drama', 'books-drama', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Comedy', 'books-comedy', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Documentary', 'documentary', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Animation', 'animation', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='books-and-movies'), 'Horror', 'books-horror', 10, true);

-- Toys and Hobbies
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Movies & TV', 'toys-movies-tv', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Anime & Manga Culture', 'anime-manga-culture', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Superheroes', 'superheroes', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Sci-Fi, Fantasy & Horror', 'scifi-fantasy-horror', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Disney & Family Entertainment', 'disney-family-entertainment', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Diecast', 'diecast', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Funko', 'toys-funko', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Sonny angels', 'sonny-angels', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Lego', 'toys-lego', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Action figures', 'action-figures', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Toy Vehicle', 'toy-vehicle', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Statues & Busts', 'statues-and-busts', 12, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'GUNPLA', 'gunpla', 13, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Model kits', 'model-kits', 14, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Classic & Novelty Toys', 'classic-novelty-toys', 15, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Dolls & Stuffed Toys', 'dolls-stuffed-toys', 16, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Games & Puzzles', 'games-and-puzzles', 17, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Educational Toys', 'educational-toys', 18, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='toys-and-hobbies'), 'Electric & Remote Control Toys', 'electric-remote-control-toys', 19, true);

-- Electronics
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Household electronics', 'household-electronics', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Tools', 'electronics-tools', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Cameras & Photography', 'cameras-photography', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Laptops', 'laptops', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Smart and Wearable Electronics', 'smart-wearable-electronics', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Mobile Phone Accessories', 'mobile-phone-accessories', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Audio & Video', 'audio-video', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Universal Accessories', 'universal-accessories', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Tablet & Computer Accessories', 'tablet-computer-accessories', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='electronics'), 'Refurbished Electronics', 'refurbished-electronics', 10, true);

-- Coins and money
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='coins-and-money'), 'Coins and Bullion', 'coins-and-bullion', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='coins-and-money'), 'Paper money and currency', 'paper-money-and-currency', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='coins-and-money'), 'BNTA Dealers', 'bnta-dealers', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='coins-and-money'), 'Exonumia', 'exonumia', 4, true);

-- Sports memorabilia
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Football', 'memorabilia-football', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Basketball', 'memorabilia-basketball', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Baseball', 'memorabilia-baseball', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Soccer', 'memorabilia-soccer', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Motorsport', 'memorabilia-motorsport', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Hockey', 'memorabilia-hockey', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Golf', 'memorabilia-golf', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Racing', 'memorabilia-racing', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sports-memorabilia'), 'Other', 'memorabilia-other', 9, true);

-- Men's Fashion
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s Tops', 'mens-tops', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s Bottoms', 'mens-bottoms', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s Suits and sets', 'mens-suits-and-sets', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s underwear and socks', 'mens-underwear-and-socks', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s Shoes', 'mens-shoes', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s sleepwear and lounge wear', 'mens-sleepwear-lounge', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s Workwear', 'mens-workwear', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s costume/cosplay', 'mens-costume-cosplay', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Men''s vintage', 'mens-vintage', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='mens-fashion'), 'Big and Tall', 'big-and-tall', 10, true);

-- Sneakers
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sneakers'), 'Collector Sneakers', 'collector-sneakers', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='sneakers'), 'Shoe Accessories', 'shoe-accessories', 2, true);

-- Women's fashion
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s underwear', 'womens-underwear', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Shoes', 'womens-shoes', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Suits and sets', 'womens-suits-and-sets', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s activewear', 'womens-activewear', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s vintage clothing', 'womens-vintage-clothing', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Tops', 'womens-tops', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Bottoms', 'womens-bottoms', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s dresses', 'womens-dresses', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Sleepwear and Loungewear', 'womens-sleepwear-loungewear', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Plus size', 'womens-plus-size', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='womens-fashion'), 'Women''s Costume and cosplay', 'womens-costume-cosplay', 11, true);

-- Kids' Fashion
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='kids-fashion'), 'Girls'' Footwear', 'girls-footwear', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='kids-fashion'), 'Boys'' Clothes', 'boys-clothes', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='kids-fashion'), 'Girls'' Clothes', 'girls-clothes', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='kids-fashion'), 'Kids'' Fashion Accessories', 'kids-fashion-accessories', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='kids-fashion'), 'Boys'' Footwear', 'boys-footwear', 5, true);

-- Bags and Accessories
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Luxury bags', 'luxury-bags', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Midrange/fashion Bags', 'midrange-fashion-bags', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Women''s Bags', 'womens-bags', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Men''s Bags', 'mens-bags', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Functional Bags', 'functional-bags', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Luggage & Travel Bags', 'luggage-travel-bags', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Bag Accessories', 'bag-accessories', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Sunglasses', 'sunglasses', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Eyewear', 'eyewear', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Hair Accessories', 'hair-accessories', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Costume Jewelry & Accessories', 'costume-jewelry-accessories', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Hair Extensions & Wigs', 'hair-extensions-wigs', 12, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Clothes Accessories', 'clothes-accessories', 13, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Fashion Watches & Accessories', 'fashion-watches-accessories', 14, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Wedding Accessories', 'wedding-accessories', 15, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='bags-and-accessories'), 'Dressmaking Fabrics', 'dressmaking-fabrics', 16, true);

-- Beauty and personal care
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Hand & Foot Care', 'hand-foot-care', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Eye & Ear Care', 'eye-ear-care', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Personal Care Appliances', 'personal-care-appliances', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Makeup', 'makeup', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Skincare', 'skincare', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Haircare & Styling', 'haircare-styling', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Nasal & Oral Care', 'nasal-oral-care', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Bath & Body Care', 'bath-body-care', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Special Personal Care', 'special-personal-care', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Men''s Care', 'mens-care', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Feminine Care', 'feminine-care', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='beauty-and-personal-care'), 'Organic', 'beauty-organic', 12, true);

-- Music & Audio
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Vinyl', 'vinyl', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Memorabilia', 'music-memorabilia', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Retro', 'retro', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'CDs & cassettes', 'cds-cassettes', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Instruments', 'instruments', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Guides/manuals/cases', 'guides-manuals-cases', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='music-and-audio'), 'Other', 'music-other', 7, true);

-- Video Games
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='video-games'), 'Consoles/accessories', 'consoles-accessories', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='video-games'), 'Memorabilia/display', 'vg-memorabilia-display', 2, true);

-- Home and Garden
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Plants', 'plants', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Holiday decor', 'holiday-decor', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Home appliances', 'home-appliances', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Home decor', 'home-decor', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Candles', 'candles', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Home Care Supplies', 'home-care-supplies', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Bathroom Supplies', 'bathroom-supplies', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Home Organizers', 'home-organizers', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Festive & Party Supplies', 'festive-party-supplies', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Laundry Tools & Accessories', 'laundry-tools-accessories', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Miscellaneous Home', 'miscellaneous-home', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Bedding and Linens', 'bedding-and-linens', 12, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Household Textiles', 'household-textiles', 13, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='home-and-garden'), 'Dining', 'dining', 14, true);

-- Baby and Kids
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Newborn', 'newborn', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby', 'baby', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Care & Health', 'baby-care-health', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Clothing & Shoes', 'baby-clothing-shoes', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Furniture', 'baby-furniture', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Toys', 'baby-toys', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Safety', 'baby-safety', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Travel Gear', 'baby-travel-gear', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Baby Fashion Accessories', 'baby-fashion-accessories', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Nursing & Feeding', 'nursing-feeding', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Toddler', 'toddler', 11, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Young Child', 'young-child', 12, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Child', 'child', 13, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Pre-teen', 'pre-teen', 14, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='baby-and-kids'), 'Young adult', 'young-adult', 15, true);

-- Handmade & Artisan Goods
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Crafts', 'crafts', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Rocks', 'rocks', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Handmade', 'handmade', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Woodworking', 'woodworking', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), '3D Print', '3d-print', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Epoxy', 'epoxy', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Fabrics & Sewing Supplies', 'fabrics-sewing-supplies', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Cosplay Jewelry', 'cosplay-jewelry', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Custom Artwork & Fan Art', 'custom-artwork-fan-art', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Fabricated Goods', 'fabricated-goods', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='handmade-and-artisan-goods'), 'Personalized Gifts & Displays', 'personalized-gifts-displays', 11, true);

-- Manga
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Shonen (Boys)', 'shonen', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Shojo (Girls)', 'shojo', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Seinen (Young Men)', 'seinen', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Josei (Young Women)', 'josei', 4, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Kodomomuke (Children)', 'kodomomuke', 5, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Isekai', 'isekai', 6, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Slice of Life', 'slice-of-life', 7, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Mecha', 'mecha', 8, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Psychological', 'psychological', 9, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Horror', 'manga-horror', 10, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='manga'), 'Fantasy', 'manga-fantasy', 11, true);

-- Displays Storage & Preservation
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='displays-storage-and-preservation'), 'Collectible Displays', 'collectible-displays', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='displays-storage-and-preservation'), 'Framing & Presentation', 'framing-presentation', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='displays-storage-and-preservation'), 'Storage & Protection', 'storage-protection', 3, true);

-- Food and drink
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='food-and-drink'), 'Candy', 'candy', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='food-and-drink'), 'Coffee/tea', 'coffee-tea', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='food-and-drink'), 'Organic', 'food-organic', 3, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='food-and-drink'), 'TV/movie themed', 'tv-movie-themed', 4, true);

-- Entertainment cards
INSERT INTO subcategories (id, category_id, name, slug, sort_order, is_active) VALUES
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='entertainment-cards'), 'Marvel', 'entertainment-marvel', 1, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='entertainment-cards'), 'Disney', 'entertainment-disney', 2, true),
  (gen_random_uuid(), (SELECT id FROM categories WHERE slug='entertainment-cards'), 'Star Wars', 'entertainment-star-wars', 3, true);

-- ---------------------------------------------------------------------------
-- 5. Insert conditions (per category)
-- ---------------------------------------------------------------------------

-- Helper: creates conditions for a given category slug
-- Card-grading scale: Trading Card Games, Sport, Comics, Entertainment cards
DO $$
DECLARE
  cat_slugs TEXT[] := ARRAY['trading-card-games','sport','comics','entertainment-cards'];
  cat_slug TEXT;
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['Gem Mint','gem-mint'],ARRAY['Mint','mint'],ARRAY['Near Mint','near-mint'],
    ARRAY['Excellent','excellent'],ARRAY['Very Good','very-good'],ARRAY['Good','good'],
    ARRAY['Fair','fair'],ARRAY['Poor','poor']
  ];
  i INT;
BEGIN
  FOREACH cat_slug IN ARRAY cat_slugs LOOP
    SELECT id INTO cat_id FROM categories WHERE slug = cat_slug;
    FOR i IN 1..array_length(conds,1) LOOP
      INSERT INTO conditions (id, name, code, category_id, sort_order)
      VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
    END LOOP;
  END LOOP;
END $$;

-- Standard item condition: Games, Toys and Hobbies, Electronics, Video Games, Home and Garden, Baby and Kids, Handmade & Artisan Goods, Displays Storage & Preservation, Jewelry, Books & Movies, Manga
DO $$
DECLARE
  cat_slugs TEXT[] := ARRAY['games','toys-and-hobbies','electronics','video-games','home-and-garden','baby-and-kids','handmade-and-artisan-goods','displays-storage-and-preservation','jewelry','books-and-movies','manga'];
  cat_slug TEXT;
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['New','new'],ARRAY['Like New','like-new'],ARRAY['Excellent','excellent'],
    ARRAY['Very Good','very-good'],ARRAY['Good','good'],ARRAY['Fair','fair'],ARRAY['Poor','poor']
  ];
  i INT;
BEGIN
  FOREACH cat_slug IN ARRAY cat_slugs LOOP
    SELECT id INTO cat_id FROM categories WHERE slug = cat_slug;
    FOR i IN 1..array_length(conds,1) LOOP
      INSERT INTO conditions (id, name, code, category_id, sort_order)
      VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
    END LOOP;
  END LOOP;
END $$;

-- Fashion condition: Men's Fashion, Women's fashion, Kids' Fashion, Bags and Accessories, Sneakers, Sports memorabilia
DO $$
DECLARE
  cat_slugs TEXT[] := ARRAY['mens-fashion','womens-fashion','kids-fashion','bags-and-accessories','sneakers','sports-memorabilia'];
  cat_slug TEXT;
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['New','new'],ARRAY['New With Tags','new-with-tags'],ARRAY['New Without Tags','new-without-tags'],
    ARRAY['New Sealed','new-sealed'],ARRAY['Like New','like-new'],ARRAY['Gently Worn','gently-worn'],
    ARRAY['Excellent','excellent'],ARRAY['Very Good','very-good'],ARRAY['Good','good'],
    ARRAY['Fair','fair'],ARRAY['Poor','poor']
  ];
  i INT;
BEGIN
  FOREACH cat_slug IN ARRAY cat_slugs LOOP
    SELECT id INTO cat_id FROM categories WHERE slug = cat_slug;
    FOR i IN 1..array_length(conds,1) LOOP
      INSERT INTO conditions (id, name, code, category_id, sort_order)
      VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
    END LOOP;
  END LOOP;
END $$;

-- Beauty and personal care, Music & Audio
DO $$
DECLARE
  cat_slugs TEXT[] := ARRAY['beauty-and-personal-care','music-and-audio'];
  cat_slug TEXT;
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['New','new'],ARRAY['New With Tags','new-with-tags'],ARRAY['Like New','like-new'],
    ARRAY['Excellent','excellent'],ARRAY['Very Good','very-good'],ARRAY['Good','good'],
    ARRAY['Fair','fair'],ARRAY['Poor','poor']
  ];
  i INT;
BEGIN
  FOREACH cat_slug IN ARRAY cat_slugs LOOP
    SELECT id INTO cat_id FROM categories WHERE slug = cat_slug;
    FOR i IN 1..array_length(conds,1) LOOP
      INSERT INTO conditions (id, name, code, category_id, sort_order)
      VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
    END LOOP;
  END LOOP;
END $$;

-- Coins and money (numismatic grading)
DO $$
DECLARE
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['Mint State','mint-state'],ARRAY['Proof','proof'],ARRAY['Brilliant Uncirculated','brilliant-uncirculated'],
    ARRAY['Uncirculated','uncirculated'],ARRAY['Near Mint','near-mint'],ARRAY['About Uncirculated','about-uncirculated'],
    ARRAY['Extremely Fine','extremely-fine'],ARRAY['Very Fine','very-fine'],ARRAY['Fine','fine'],
    ARRAY['Very Good','very-good'],ARRAY['Good','good'],ARRAY['Circulated','circulated']
  ];
  i INT;
BEGIN
  SELECT id INTO cat_id FROM categories WHERE slug = 'coins-and-money';
  FOR i IN 1..array_length(conds,1) LOOP
    INSERT INTO conditions (id, name, code, category_id, sort_order)
    VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
  END LOOP;
END $$;

-- Food and drink
DO $$
DECLARE
  cat_id UUID;
  conds TEXT[][] := ARRAY[
    ARRAY['New','new'],ARRAY['Sealed','sealed'],ARRAY['Unopened','unopened'],
    ARRAY['Opened','opened'],ARRAY['Perishable','perishable'],ARRAY['Expired','expired'],
    ARRAY['Near Expiry','near-expiry']
  ];
  i INT;
BEGIN
  SELECT id INTO cat_id FROM categories WHERE slug = 'food-and-drink';
  FOR i IN 1..array_length(conds,1) LOOP
    INSERT INTO conditions (id, name, code, category_id, sort_order)
    VALUES (gen_random_uuid(), conds[i][1], conds[i][2], cat_id, i);
  END LOOP;
END $$;

-- ---------------------------------------------------------------------------
-- 6. Insert tags (per category)
-- ---------------------------------------------------------------------------

-- Helper function to insert tags for a category
CREATE OR REPLACE FUNCTION _insert_tags(p_cat_slug TEXT, p_tags TEXT[][]) RETURNS void AS $$
DECLARE
  cat_id UUID;
  i INT;
BEGIN
  SELECT id INTO cat_id FROM categories WHERE slug = p_cat_slug;
  FOR i IN 1..array_length(p_tags,1) LOOP
    INSERT INTO tags (id, name, slug, category_id, usage_count)
    VALUES (gen_random_uuid(), p_tags[i][1], p_tags[i][2], cat_id, 0);
  END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Jewelry tags
SELECT _insert_tags('jewelry', ARRAY[
  ARRAY['Platinum','platinum'],ARRAY['Silver','silver'],ARRAY['Gold','gold'],
  ARRAY['Diamond','diamond'],ARRAY['Ruby','ruby'],ARRAY['Sapphire','sapphire'],
  ARRAY['Emerald','emerald'],ARRAY['Pearl','pearl'],ARRAY['Jade','jade'],
  ARRAY['Amber','amber'],ARRAY['Mellite','mellite']
]);

-- Trading Card Games tags
SELECT _insert_tags('trading-card-games', ARRAY[
  ARRAY['Topps','topps'],ARRAY['Panini','panini'],ARRAY['Donruss','donruss'],
  ARRAY['Upper Deck','upper-deck'],ARRAY['Score','score'],ARRAY['Mosaic','mosaic'],
  ARRAY['Fleer','fleer'],ARRAY['SkyBox','skybox'],ARRAY['Pinnacle','pinnacle'],
  ARRAY['Pacific','pacific']
]);

-- Sport tags
SELECT _insert_tags('sport', ARRAY[
  ARRAY['Surface Wear','surface-wear'],ARRAY['Scratches','scratches'],ARRAY['Scuffs','scuffs'],
  ARRAY['Patina Present','patina-present'],ARRAY['Fading','fading'],ARRAY['Discoloration','discoloration'],
  ARRAY['Tarnished','tarnished'],ARRAY['Color Loss','color-loss'],ARRAY['Creasing','creasing'],
  ARRAY['Stains','stains'],ARRAY['Smoke Free','smoke-free']
]);

-- Electronics tags
SELECT _insert_tags('electronics', ARRAY[
  ARRAY['Apple','apple'],ARRAY['Samsung','samsung'],ARRAY['Google','google'],
  ARRAY['Huawei','huawei'],ARRAY['Xiaomi','xiaomi'],ARRAY['OnePlus','oneplus'],
  ARRAY['Sony','sony-electronics'],ARRAY['Lenovo','lenovo'],ARRAY['Dell','dell'],
  ARRAY['ASUS','asus'],ARRAY['Acer','acer'],ARRAY['Microsoft','microsoft'],
  ARRAY['MSI','msi'],ARRAY['Razer','razer'],ARRAY['Bose','bose'],
  ARRAY['JBL','jbl'],ARRAY['Sennheiser','sennheiser-electronics'],ARRAY['LG Electronics','lg-electronics'],
  ARRAY['Panasonic','panasonic'],ARRAY['Canon','canon'],ARRAY['Nikon','nikon'],
  ARRAY['Fujifilm','fujifilm'],ARRAY['GoPro','gopro'],ARRAY['Anker','anker'],
  ARRAY['Belkin','belkin'],ARRAY['Logitech','logitech'],ARRAY['Corsair','corsair'],
  ARRAY['Dyson','dyson'],ARRAY['Bosch','bosch'],ARRAY['Makita','makita'],
  ARRAY['DeWalt','dewalt'],ARRAY['Philips','philips']
]);

-- Coins and money tags
SELECT _insert_tags('coins-and-money', ARRAY[
  ARRAY['United States Mint','united-states-mint'],ARRAY['Royal Canadian Mint','royal-canadian-mint'],
  ARRAY['Royal Mint','royal-mint'],ARRAY['Perth Mint','perth-mint'],
  ARRAY['APMEX','apmex'],ARRAY['JM Bullion','jm-bullion'],
  ARRAY['SD Bullion','sd-bullion'],ARRAY['Kitco','kitco'],
  ARRAY['Littleton Coin Company','littleton-coin-company']
]);

-- Men's Fashion tags
SELECT _insert_tags('mens-fashion', ARRAY[
  ARRAY['Nike','nike-mens'],ARRAY['Jordan','jordan-mens'],ARRAY['Adidas','adidas-mens'],
  ARRAY['Yeezy','yeezy-mens'],ARRAY['New Balance','new-balance-mens'],ARRAY['Puma','puma-mens'],
  ARRAY['ASICS','asics-mens'],ARRAY['Vans','vans-mens'],ARRAY['Converse','converse-mens'],
  ARRAY['Reebok','reebok-mens'],ARRAY['Ralph Lauren','ralph-lauren'],ARRAY['Levi''s','levis-mens'],
  ARRAY['Uniqlo','uniqlo-mens'],ARRAY['Tommy Hilfiger','tommy-hilfiger'],
  ARRAY['The North Face','the-north-face'],ARRAY['Carhartt','carhartt'],
  ARRAY['Calvin Klein','calvin-klein-mens'],ARRAY['Hugo Boss','hugo-boss'],
  ARRAY['Supreme','supreme'],ARRAY['Off-White','off-white'],
  ARRAY['Fear of God','fear-of-god'],ARRAY['Stone Island','stone-island'],
  ARRAY['Bape','bape'],ARRAY['Palace','palace'],
  ARRAY['Columbia','columbia'],ARRAY['Patagonia','patagonia'],
  ARRAY['Under Armour','under-armour'],ARRAY['Lululemon','lululemon-mens']
]);

-- Sneakers tags
SELECT _insert_tags('sneakers', ARRAY[
  ARRAY['Nike','nike-sneakers'],ARRAY['Jordan','jordan-sneakers'],ARRAY['Adidas','adidas-sneakers'],
  ARRAY['Yeezy','yeezy-sneakers'],ARRAY['New Balance','new-balance-sneakers'],
  ARRAY['Puma','puma-sneakers'],ARRAY['ASICS','asics-sneakers'],
  ARRAY['Vans','vans-sneakers'],ARRAY['Converse','converse-sneakers'],
  ARRAY['Reebok','reebok-sneakers']
]);

-- Women's fashion tags
SELECT _insert_tags('womens-fashion', ARRAY[
  ARRAY['Chanel','chanel'],ARRAY['Dior','dior'],ARRAY['Gucci','gucci-womens'],
  ARRAY['Hermès','hermes'],ARRAY['Prada','prada-womens'],ARRAY['Saint Laurent','saint-laurent'],
  ARRAY['Valentino','valentino'],ARRAY['Balenciaga','balenciaga'],ARRAY['Celine','celine'],
  ARRAY['Zara','zara'],ARRAY['H&M','h-and-m'],ARRAY['Uniqlo','uniqlo-womens'],
  ARRAY['Mango','mango'],ARRAY['ASOS','asos'],ARRAY['Free People','free-people'],
  ARRAY['Lululemon','lululemon-womens'],ARRAY['Nike','nike-womens'],
  ARRAY['Adidas','adidas-womens'],ARRAY['Levi''s','levis-womens'],
  ARRAY['Calvin Klein','calvin-klein-womens'],ARRAY['Skims','skims'],
  ARRAY['Victoria''s Secret','victorias-secret']
]);

-- Kids' Fashion tags
SELECT _insert_tags('kids-fashion', ARRAY[
  ARRAY['Nike Kids','nike-kids'],ARRAY['Adidas Kids','adidas-kids'],
  ARRAY['Jordan Kids','jordan-kids'],ARRAY['Vans Kids','vans-kids'],
  ARRAY['Carter''s','carters'],ARRAY['Gap Kids','gap-kids'],
  ARRAY['Old Navy Kids','old-navy-kids'],ARRAY['H&M Kids','h-and-m-kids'],
  ARRAY['Zara Kids','zara-kids'],ARRAY['Disney','disney-kids'],
  ARRAY['Marvel','marvel-kids']
]);

-- Bags and Accessories tags
SELECT _insert_tags('bags-and-accessories', ARRAY[
  ARRAY['Chanel','chanel-bags'],ARRAY['Louis Vuitton','louis-vuitton'],
  ARRAY['Gucci','gucci-bags'],ARRAY['Hermès','hermes-bags'],
  ARRAY['Prada','prada-bags'],ARRAY['Coach','coach'],
  ARRAY['Michael Kors','michael-kors'],ARRAY['Kate Spade','kate-spade'],
  ARRAY['Tory Burch','tory-burch'],ARRAY['Longchamp','longchamp']
]);

-- Music & Audio tags
SELECT _insert_tags('music-and-audio', ARRAY[
  ARRAY['Mobile Fidelity','mobile-fidelity'],ARRAY['Analogue Productions','analogue-productions'],
  ARRAY['Blue Note','blue-note'],ARRAY['Capitol Records','capitol-records'],
  ARRAY['Columbia Records','columbia-records'],ARRAY['Fender','fender'],
  ARRAY['Gibson','gibson'],ARRAY['Martin','martin'],
  ARRAY['Shure','shure'],ARRAY['Sennheiser','sennheiser-audio'],
  ARRAY['Roland','roland'],ARRAY['Korg','korg'],
  ARRAY['Audio-Technica','audio-technica']
]);

-- Video Games tags
SELECT _insert_tags('video-games', ARRAY[
  ARRAY['Cartridge','cartridge'],ARRAY['Disc','disc'],ARRAY['Digital Download','digital-download'],
  ARRAY['Console','console'],ARRAY['Accessory','vg-accessory'],ARRAY['Controller','controller'],
  ARRAY['Action','action'],ARRAY['Adventure','adventure'],ARRAY['RPG','rpg'],
  ARRAY['Strategy','strategy'],ARRAY['Simulation','simulation'],ARRAY['Sports','vg-sports'],
  ARRAY['Racing','vg-racing'],ARRAY['Shooter','shooter'],ARRAY['Puzzle','puzzle'],
  ARRAY['Platformer','platformer'],ARRAY['PlayStation','playstation'],ARRAY['Xbox','xbox'],
  ARRAY['Nintendo','nintendo'],ARRAY['PC','pc'],ARRAY['Retro Consoles','retro-consoles']
]);

-- Games tags
SELECT _insert_tags('games', ARRAY[
  ARRAY['Monopoly','monopoly'],ARRAY['Chess','chess'],ARRAY['Scrabble','scrabble'],
  ARRAY['Catan','catan'],ARRAY['Ticket to Ride','ticket-to-ride'],
  ARRAY['Pandemic','pandemic'],ARRAY['Dungeons & Dragons','dungeons-and-dragons'],
  ARRAY['Pathfinder','pathfinder'],ARRAY['Pokemon','pokemon-games'],
  ARRAY['Uno','uno'],ARRAY['Cards Against Humanity','cards-against-humanity'],
  ARRAY['Bicycle Playing Cards','bicycle-playing-cards']
]);

-- Manga tags
SELECT _insert_tags('manga', ARRAY[
  ARRAY['One Piece','one-piece'],ARRAY['Naruto','naruto'],
  ARRAY['Attack on Titan','attack-on-titan'],ARRAY['Demon Slayer','demon-slayer'],
  ARRAY['My Hero Academia','my-hero-academia'],ARRAY['Jujutsu Kaisen','jujutsu-kaisen'],
  ARRAY['Dragon Ball Z','dragon-ball-z'],ARRAY['Sailor Moon','sailor-moon'],
  ARRAY['Chainsaw Man','chainsaw-man'],ARRAY['Solo Leveling','solo-leveling']
]);

-- Beauty and personal care tags
SELECT _insert_tags('beauty-and-personal-care', ARRAY[
  ARRAY['Authentic','authentic'],ARRAY['Original Pressing','original-pressing'],
  ARRAY['Limited Edition','limited-edition'],ARRAY['Exclusive','exclusive'],
  ARRAY['Factory Sealed','factory-sealed']
]);

-- Food and drink tags
SELECT _insert_tags('food-and-drink', ARRAY[
  ARRAY['Certified Organic','certified-organic'],ARRAY['Fair Trade','fair-trade'],
  ARRAY['Non-GMO','non-gmo'],ARRAY['Gluten Free','gluten-free'],
  ARRAY['Dairy Free','dairy-free'],ARRAY['Vegan','vegan'],
  ARRAY['Sugar Free','sugar-free'],ARRAY['Single Origin','single-origin'],
  ARRAY['Coffee','coffee'],ARRAY['Tea','tea'],
  ARRAY['Gummies','gummies'],ARRAY['Hard Candy','hard-candy'],
  ARRAY['Baked Goods','baked-goods'],ARRAY['Snacks','snacks']
]);

-- Displays Storage & Preservation tags
SELECT _insert_tags('displays-storage-and-preservation', ARRAY[
  ARRAY['Archival Safe','archival-safe'],ARRAY['Acid Free','acid-free'],
  ARRAY['UV Protection','uv-protection'],ARRAY['Dust Resistant','dust-resistant'],
  ARRAY['Tempered Glass','tempered-glass'],ARRAY['Acrylic','acrylic'],
  ARRAY['Wall Mounted','wall-mounted'],ARRAY['Freestanding','freestanding'],
  ARRAY['Tabletop','tabletop'],ARRAY['Museum Grade','museum-grade']
]);

-- Baby and Kids tags
SELECT _insert_tags('baby-and-kids', ARRAY[
  ARRAY['Newborn','tag-newborn'],ARRAY['Baby','tag-baby'],
  ARRAY['Toddler','tag-toddler'],ARRAY['Educational','educational'],
  ARRAY['Sensory','sensory'],ARRAY['Developmental','developmental'],
  ARRAY['Interactive','interactive'],ARRAY['Battery Free','battery-free'],
  ARRAY['Convertible','convertible'],ARRAY['Adjustable Height','adjustable-height']
]);

-- Handmade & Artisan Goods tags
SELECT _insert_tags('handmade-and-artisan-goods', ARRAY[
  ARRAY['Cottagecore','cottagecore'],ARRAY['Witchcore','witchcore'],
  ARRAY['Celestial','celestial'],ARRAY['Norse/Viking','norse-viking'],
  ARRAY['Cyberpunk','cyberpunk'],ARRAY['Steampunk','steampunk'],
  ARRAY['Gaming Inspired','gaming-inspired'],ARRAY['D&D/Tabletop','dnd-tabletop'],
  ARRAY['Movie Replicas','movie-replicas'],ARRAY['Comic Inspired','comic-inspired'],
  ARRAY['Studio Ghibli Inspired','studio-ghibli-inspired'],ARRAY['Anime Inspired','anime-inspired']
]);

-- Entertainment cards tags
SELECT _insert_tags('entertainment-cards', ARRAY[
  ARRAY['Marvel','marvel-cards'],ARRAY['Disney','disney-cards'],ARRAY['Star Wars','star-wars-cards']
]);

-- Books & Movies tags
SELECT _insert_tags('books-and-movies', ARRAY[
  ARRAY['Humanities','humanities'],ARRAY['Social Sciences','social-sciences'],
  ARRAY['Literature','literature'],ARRAY['Art','art'],
  ARRAY['Economics','economics'],ARRAY['Science','science'],
  ARRAY['Technology','technology'],ARRAY['Fiction','tag-fiction'],
  ARRAY['Fantasy','tag-fantasy'],ARRAY['Sci-Fi','tag-sci-fi'],
  ARRAY['Romance','tag-romance'],ARRAY['Drama','tag-drama']
]);

-- Toys and Hobbies tags
SELECT _insert_tags('toys-and-hobbies', ARRAY[
  ARRAY['Funko','funko'],ARRAY['Lego','lego'],ARRAY['Hot Wheels','hot-wheels'],
  ARRAY['Barbie','barbie'],ARRAY['Star Wars','star-wars-toys'],
  ARRAY['Marvel','marvel-toys'],ARRAY['Disney','disney-toys'],
  ARRAY['Transformers','transformers'],ARRAY['Pokemon','pokemon-toys'],
  ARRAY['GUNPLA','gunpla-tag']
]);

-- Sports memorabilia tags
SELECT _insert_tags('sports-memorabilia', ARRAY[
  ARRAY['Autographed Jerseys','autographed-jerseys'],ARRAY['Game-Used Jerseys','game-used-jerseys'],
  ARRAY['Autographed Helmets','autographed-helmets'],ARRAY['Autographed Balls','autographed-balls'],
  ARRAY['Championship Rings','championship-rings'],ARRAY['Autographed Photos','autographed-photos'],
  ARRAY['Ticket Stubs','ticket-stubs']
]);

-- Clean up helper function
DROP FUNCTION _insert_tags(TEXT, TEXT[][]);

-- ---------------------------------------------------------------------------
-- 7. Create indexes for category_id filtering
-- ---------------------------------------------------------------------------

CREATE INDEX IF NOT EXISTS idx_conditions_category_id ON conditions(category_id);
CREATE INDEX IF NOT EXISTS idx_tags_category_id ON tags(category_id);

-- ---------------------------------------------------------------------------
-- 8. Restore FK constraints on products
-- ---------------------------------------------------------------------------

ALTER TABLE products ADD CONSTRAINT products_category_id_fkey
  FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL;
ALTER TABLE products ADD CONSTRAINT products_subcategory_id_fkey
  FOREIGN KEY (subcategory_id) REFERENCES subcategories(id) ON DELETE SET NULL;
ALTER TABLE products ADD CONSTRAINT products_condition_id_fkey
  FOREIGN KEY (condition_id) REFERENCES conditions(id) ON DELETE SET NULL;

COMMIT;
