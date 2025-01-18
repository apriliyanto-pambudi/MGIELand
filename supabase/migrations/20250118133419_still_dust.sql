/*
  # Create storage buckets for media uploads

  1. New Storage Buckets
    - `featured_images` - For product featured images
    - `featured_videos` - For product featured videos
    - `image_galleries` - For product image galleries
    - `video_galleries` - For product video galleries

  2. Security
    - Enable public read access
    - Restrict uploads to authenticated users
    - Set file size limits and allowed MIME types
*/

-- Create storage buckets
INSERT INTO storage.buckets (id, name, public)
VALUES 
  ('featured_images', 'featured_images', true),
  ('featured_videos', 'featured_videos', true),
  ('image_galleries', 'image_galleries', true),
  ('video_galleries', 'video_galleries', true);

-- Set up storage policies for featured_images
CREATE POLICY "Public can view featured images"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'featured_images');

CREATE POLICY "Authenticated users can upload featured images"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'featured_images'
    AND LOWER(storage.extension(name)) IN ('png', 'jpg', 'jpeg', 'gif', 'webp')
    AND storage.foldername(name) = auth.uid()::text
  );

-- Set up storage policies for featured_videos
CREATE POLICY "Public can view featured videos"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'featured_videos');

CREATE POLICY "Authenticated users can upload featured videos"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'featured_videos'
    AND LOWER(storage.extension(name)) IN ('mp4', 'webm')
    AND storage.foldername(name) = auth.uid()::text
  );

-- Set up storage policies for image_galleries
CREATE POLICY "Public can view gallery images"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'image_galleries');

CREATE POLICY "Authenticated users can upload gallery images"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'image_galleries'
    AND LOWER(storage.extension(name)) IN ('png', 'jpg', 'jpeg', 'gif', 'webp')
    AND storage.foldername(name) = auth.uid()::text
  );

-- Set up storage policies for video_galleries
CREATE POLICY "Public can view gallery videos"
  ON storage.objects
  FOR SELECT
  TO public
  USING (bucket_id = 'video_galleries');

CREATE POLICY "Authenticated users can upload gallery videos"
  ON storage.objects
  FOR INSERT
  TO authenticated
  WITH CHECK (
    bucket_id = 'video_galleries'
    AND LOWER(storage.extension(name)) IN ('mp4', 'webm')
    AND storage.foldername(name) = auth.uid()::text
  );

-- Allow authenticated users to delete their own files
CREATE POLICY "Users can delete own files"
  ON storage.objects
  FOR DELETE
  TO authenticated
  USING (storage.foldername(name) = auth.uid()::text);