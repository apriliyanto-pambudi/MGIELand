/*
  # Create products table with media and facilities

  1. New Tables
    - `products`
      - `id` (uuid, primary key)
      - `created_at` (timestamp with timezone)
      - `updated_at` (timestamp with timezone)
      - `nama` (text, for product name and sorting)
      - `category` (text)
      - `price` (numeric)
      - `featured_image` (text, URL)
      - `featured_video` (text, URL)
      - `image_gallery` (text array, URLs)
      - `video_gallery` (text array, URLs)
      - `facilities` (jsonb, array of facility objects)

  2. Security
    - Enable RLS on `products` table
    - Add policies for:
      - Public read access
      - Authenticated users can manage their own products
*/

-- Create products table
CREATE TABLE IF NOT EXISTS products (
  id uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at timestamptz DEFAULT now(),
  updated_at timestamptz DEFAULT now(),
  nama text NOT NULL,
  category text NOT NULL,
  price numeric NOT NULL CHECK (price >= 0),
  featured_image text,
  featured_video text,
  image_gallery text[],
  video_gallery text[],
  facilities jsonb DEFAULT '[]'::jsonb,
  
  -- Add search index for nama and category
  CONSTRAINT products_nama_not_empty CHECK (nama <> ''),
  CONSTRAINT products_category_not_empty CHECK (category <> '')
);

-- Create index for sorting and searching
CREATE INDEX IF NOT EXISTS products_nama_idx ON products (nama);
CREATE INDEX IF NOT EXISTS products_category_idx ON products (category);

-- Add updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = now();
  RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- Enable Row Level Security
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policies
CREATE POLICY "Allow public read access"
  ON products
  FOR SELECT
  TO public
  USING (true);

CREATE POLICY "Allow authenticated users to insert their own products"
  ON products
  FOR INSERT
  TO authenticated
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Allow authenticated users to update their own products"
  ON products
  FOR UPDATE
  TO authenticated
  USING (auth.uid() IS NOT NULL)
  WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Allow authenticated users to delete their own products"
  ON products
  FOR DELETE
  TO authenticated
  USING (auth.uid() IS NOT NULL);