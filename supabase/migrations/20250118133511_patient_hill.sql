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
    - Set file type restrictions
*/

-- Create storage buckets if they don't exist
DO $$
BEGIN
    INSERT INTO storage.buckets (id, name, public)
    VALUES 
        ('featured_images', 'featured_images', true),
        ('featured_videos', 'featured_videos', true),
        ('image_galleries', 'image_galleries', true),
        ('video_galleries', 'video_galleries', true)
    ON CONFLICT (id) DO NOTHING;
END $$;

-- Featured Images Policies
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public can view featured images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload featured images" ON storage.objects;
    
    CREATE POLICY "Public can view featured images"
        ON storage.objects FOR SELECT
        TO public
        USING (bucket_id = 'featured_images');
    
    CREATE POLICY "Authenticated users can upload featured images"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (
            bucket_id = 'featured_images' AND
            (storage.extension(name) = 'png' OR
             storage.extension(name) = 'jpg' OR
             storage.extension(name) = 'jpeg' OR
             storage.extension(name) = 'gif' OR
             storage.extension(name) = 'webp')
        );
END $$;

-- Featured Videos Policies
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public can view featured videos" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload featured videos" ON storage.objects;
    
    CREATE POLICY "Public can view featured videos"
        ON storage.objects FOR SELECT
        TO public
        USING (bucket_id = 'featured_videos');
    
    CREATE POLICY "Authenticated users can upload featured videos"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (
            bucket_id = 'featured_videos' AND
            (storage.extension(name) = 'mp4' OR
             storage.extension(name) = 'webm')
        );
END $$;

-- Image Galleries Policies
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public can view gallery images" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload gallery images" ON storage.objects;
    
    CREATE POLICY "Public can view gallery images"
        ON storage.objects FOR SELECT
        TO public
        USING (bucket_id = 'image_galleries');
    
    CREATE POLICY "Authenticated users can upload gallery images"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (
            bucket_id = 'image_galleries' AND
            (storage.extension(name) = 'png' OR
             storage.extension(name) = 'jpg' OR
             storage.extension(name) = 'jpeg' OR
             storage.extension(name) = 'gif' OR
             storage.extension(name) = 'webp')
        );
END $$;

-- Video Galleries Policies
DO $$
BEGIN
    DROP POLICY IF EXISTS "Public can view gallery videos" ON storage.objects;
    DROP POLICY IF EXISTS "Authenticated users can upload gallery videos" ON storage.objects;
    
    CREATE POLICY "Public can view gallery videos"
        ON storage.objects FOR SELECT
        TO public
        USING (bucket_id = 'video_galleries');
    
    CREATE POLICY "Authenticated users can upload gallery videos"
        ON storage.objects FOR INSERT
        TO authenticated
        WITH CHECK (
            bucket_id = 'video_galleries' AND
            (storage.extension(name) = 'mp4' OR
             storage.extension(name) = 'webm')
        );
END $$;

-- Delete Policy
DO $$
BEGIN
    DROP POLICY IF EXISTS "Users can delete own files" ON storage.objects;
    
    CREATE POLICY "Users can delete own files"
        ON storage.objects FOR DELETE
        TO authenticated
        USING (auth.uid()::text = storage.foldername(name));
END $$;