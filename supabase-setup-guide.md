# Supabase Setup Guide for RemixContent

This guide explains how to set up the database schema in Supabase for the RemixContent application.

## Step 1: Access the SQL Editor

1. Log in to your Supabase dashboard
2. Select your project
3. Click on "SQL Editor" in the left sidebar
4. Create a "New Query"

## Step 2: Run the Schema Setup Script

Copy the entire contents of the `supabase-schema.sql` file and paste it into the SQL Editor. Then click "Run" to execute it.

This script will:
- Create all necessary tables
- Set up foreign key relationships
- Create indexes for efficient queries
- Implement row-level security policies
- Add utility functions for processing TikTok data
- Insert some initial category and tag data

## Step 3: Configure Auth Settings

For authentication with Clerk, you'll need to set up Supabase to work alongside it:

1. Go to "Authentication" → "Providers" in your Supabase dashboard
2. Disable "Email" provider since Clerk will handle this
3. In "JWT Templates", configure a custom JWT template that's compatible with Clerk

## Step 4: Connect Your App to Supabase

In your Next.js app, you'll need to configure the Supabase client. Make sure to add these environment variables:

```
NEXT_PUBLIC_SUPABASE_URL=your-supabase-url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your-supabase-anon-key
```

## Step 5: Test the Setup

You can test if your Supabase setup is working by running these queries in the SQL Editor:

### Create a test leaderboard:
```sql
SELECT create_daily_leaderboard('Test Leaderboard', CURRENT_DATE, '00000000-0000-0000-0000-000000000000'::uuid);
```

### List all boards:
```sql
SELECT * FROM boards;
```

## Using the Database Functions

The database includes several helper functions to simplify common operations:

### Process a TikTok video:
```sql
SELECT process_tiktok_video('{"id":"12345", "webVideoUrl":"https://www.tiktok.com/video", "text":"Test video"}'::jsonb);
```

### Add a TikTok account to a leaderboard's watchlist:
```sql
SELECT add_account_to_watchlist('board-uuid-here', 'https://www.tiktok.com/@username');
```

### Branch (fork) a video:
```sql
SELECT branch_content_repo('original-video-uuid', 'user-uuid');
```

### View a branched content tree:
```sql
SELECT * FROM get_content_branches('video-uuid-here');
```

## Apify Integration

The database is designed to work with the Apify TikTok data extractor task. When you receive data from Apify, you can process it with the `process_tiktok_video` function.

Example code for processing Apify data in your app:

```typescript
const processApifyData = async (data: any[], boardId: string) => {
  // Use Supabase function to process each video
  for (const video of data) {
    await supabase.rpc('process_tiktok_video', {
      video_data: video,
      board_id: boardId,
      user_id: currentUser.id
    });
  }
};
```

## Database Schema Reference

The database consists of these main tables:

1. `users` - Stores user information
2. `boards` - Stores leaderboards and personal boards
3. `videos` - Stores TikTok video data
4. `board_videos` - Links videos to boards
5. `watchlist_accounts` - Stores TikTok accounts for monitoring
6. `product_categories` - Hierarchical product categories
7. `video_categories` - Links videos to product categories
8. `format_tags` - Stores format tags (e.g., hashtags)
9. `video_tags` - Links videos to format tags
10. `board_followers` - Tracks which users follow which boards

Each table has appropriate indexes and security policies configured.