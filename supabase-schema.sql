-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- Users Table
CREATE TABLE IF NOT EXISTS users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    username TEXT UNIQUE,
    email TEXT UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Boards Table (for both Leaderboards and My Boards)
CREATE TABLE IF NOT EXISTS boards (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('leaderboard', 'my_board')),
    leaderboard_date DATE, -- NULL for My Boards
    created_by UUID REFERENCES users(id),
    visibility TEXT DEFAULT 'public' CHECK (visibility IN ('public', 'private')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Videos Table
CREATE TABLE IF NOT EXISTS videos (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    tiktok_id TEXT UNIQUE,
    url TEXT UNIQUE NOT NULL,
    title TEXT,
    thumbnail_url TEXT,
    performance_metrics JSONB,
    parent_id UUID REFERENCES videos(id),
    created_by UUID REFERENCES users(id),
    posted_at TIMESTAMP WITH TIME ZONE,
    height INTEGER,
    width INTEGER,
    duration INTEGER,
    is_ad BOOLEAN DEFAULT FALSE,
    author_tiktok_id TEXT,
    author_name TEXT,
    music_name TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for the videos table
CREATE UNIQUE INDEX IF NOT EXISTS idx_videos_tiktok_id ON videos(tiktok_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_videos_url ON videos(url);
CREATE INDEX IF NOT EXISTS idx_videos_posted_at ON videos(posted_at);
CREATE INDEX IF NOT EXISTS idx_videos_author_tiktok_id ON videos(author_tiktok_id);
CREATE INDEX IF NOT EXISTS idx_videos_is_ad ON videos(is_ad);

-- Board_Videos Junction Table
CREATE TABLE IF NOT EXISTS board_videos (
    board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
    video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
    added_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    PRIMARY KEY (board_id, video_id)
);

-- Watchlist Accounts Table
CREATE TABLE IF NOT EXISTS watchlist_accounts (
    board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
    account_url TEXT NOT NULL,
    PRIMARY KEY (board_id, account_url)
);

-- Product Categories Table
CREATE TABLE IF NOT EXISTS product_categories (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT NOT NULL,
    parent_id UUID REFERENCES product_categories(id)
);

-- Video Categories Junction Table
CREATE TABLE IF NOT EXISTS video_categories (
    video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
    category_id UUID REFERENCES product_categories(id) ON DELETE CASCADE,
    PRIMARY KEY (video_id, category_id)
);

-- Format Tags Table
CREATE TABLE IF NOT EXISTS format_tags (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name TEXT UNIQUE NOT NULL
);

-- Video Tags Junction Table
CREATE TABLE IF NOT EXISTS video_tags (
    video_id UUID REFERENCES videos(id) ON DELETE CASCADE,
    tag_id UUID REFERENCES format_tags(id) ON DELETE CASCADE,
    PRIMARY KEY (video_id, tag_id)
);

-- Board Followers Junction Table
CREATE TABLE IF NOT EXISTS board_followers (
    user_id UUID REFERENCES users(id) ON DELETE CASCADE,
    board_id UUID REFERENCES boards(id) ON DELETE CASCADE,
    PRIMARY KEY (user_id, board_id)
);

-- Add trigger to automatically update updated_at columns
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_users_updated_at
    BEFORE UPDATE ON users
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_boards_updated_at
    BEFORE UPDATE ON boards
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_videos_updated_at
    BEFORE UPDATE ON videos
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();