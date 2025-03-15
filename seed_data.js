// Node.js script to seed leaderboard data in Supabase

const { createClient } = require('@supabase/supabase-js');

// Supabase configuration
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_KEY';

// Create Supabase client
const supabase = createClient(supabaseUrl, supabaseKey);

async function seedData() {
  try {
    console.log('Starting data seeding...');

    // 1. Create a sample user
    const { data: user, error: userError } = await supabase
      .from('users')
      .upsert({
        id: '00000000-0000-0000-0000-000000000000',
        username: 'sample_user',
        email: 'sample@example.com',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
      .single();

    if (userError) {
      throw new Error(`Error creating user: ${userError.message}`);
    }
    console.log('User created:', user);

    // 2. Create a leaderboard for today
    const today = new Date().toISOString().split('T')[0];
    const { data: board, error: boardError } = await supabase
      .from('boards')
      .upsert({
        id: '11111111-1111-1111-1111-111111111111',
        name: `Daily Leaderboard ${today}`,
        type: 'leaderboard',
        leaderboard_date: today,
        visibility: 'public',
        created_by: '00000000-0000-0000-0000-000000000000',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      })
      .select()
      .single();

    if (boardError) {
      throw new Error(`Error creating board: ${boardError.message}`);
    }
    console.log('Leaderboard created:', board);

    // 3. Create sample videos
    const videos = [
      {
        id: '22222222-2222-2222-2222-222222222222',
        tiktok_id: '7341234567890123456',
        url: 'https://www.tiktok.com/@tiktok/video/7341234567890123456',
        title: 'This is a sample TikTok video #trending',
        thumbnail_url: 'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/sample1.jpg',
        performance_metrics: { likes: 15000, comments: 500, shares: 2000, views: 100000 },
        posted_at: new Date(Date.now() - 86400000).toISOString(), // 1 day ago
        height: 1920,
        width: 1080,
        duration: 30,
        is_ad: false,
        author_tiktok_id: 'user123456',
        author_name: 'TikTok Creator 1',
        music_name: 'Original Sound - TikTok Creator 1',
        created_by: '00000000-0000-0000-0000-000000000000',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '33333333-3333-3333-3333-333333333333',
        tiktok_id: '7342345678901234567',
        url: 'https://www.tiktok.com/@tiktok/video/7342345678901234567',
        title: 'Check out this amazing product! #affiliate #ad',
        thumbnail_url: 'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/sample2.jpg',
        performance_metrics: { likes: 25000, comments: 800, shares: 3000, views: 200000 },
        posted_at: new Date(Date.now() - 172800000).toISOString(), // 2 days ago
        height: 1920,
        width: 1080,
        duration: 45,
        is_ad: true,
        author_tiktok_id: 'user234567',
        author_name: 'TikTok Creator 2',
        music_name: 'Original Sound - TikTok Creator 2',
        created_by: '00000000-0000-0000-0000-000000000000',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      },
      {
        id: '44444444-4444-4444-4444-444444444444',
        tiktok_id: '7343456789012345678',
        url: 'https://www.tiktok.com/@tiktok/video/7343456789012345678',
        title: 'How I made $5000 with this affiliate product #money #affiliate',
        thumbnail_url: 'https://p16-sign-va.tiktokcdn.com/obj/tos-maliva-p-0068/sample3.jpg',
        performance_metrics: { likes: 35000, comments: 1200, shares: 5000, views: 300000 },
        posted_at: new Date(Date.now() - 259200000).toISOString(), // 3 days ago
        height: 1920,
        width: 1080,
        duration: 60,
        is_ad: false,
        author_tiktok_id: 'user345678',
        author_name: 'TikTok Creator 3',
        music_name: 'Original Sound - TikTok Creator 3',
        created_by: '00000000-0000-0000-0000-000000000000',
        created_at: new Date().toISOString(),
        updated_at: new Date().toISOString()
      }
    ];

    const { data: createdVideos, error: videosError } = await supabase
      .from('videos')
      .upsert(videos)
      .select();

    if (videosError) {
      throw new Error(`Error creating videos: ${videosError.message}`);
    }
    console.log('Videos created:', createdVideos.length);

    // 4. Add videos to the leaderboard
    const boardVideos = videos.map(video => ({
      board_id: '11111111-1111-1111-1111-111111111111',
      video_id: video.id,
      added_at: new Date().toISOString()
    }));

    const { data: createdBoardVideos, error: boardVideosError } = await supabase
      .from('board_videos')
      .upsert(boardVideos)
      .select();

    if (boardVideosError) {
      throw new Error(`Error adding videos to leaderboard: ${boardVideosError.message}`);
    }
    console.log('Videos added to leaderboard:', createdBoardVideos.length);

    console.log('Data seeding completed successfully!');
  } catch (error) {
    console.error('Error seeding data:', error.message);
  }
}

// Run the seed function
seedData();