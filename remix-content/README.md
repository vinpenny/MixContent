# RemixContent

RemixContent is a web application designed to assist TikTok Creator affiliates and Sellers by providing a daily leaderboard of top-performing videos for remixing. This enables creators to optimize their content by emulating successful trends, while allowing sellers to efficiently manage and assign video content tasks to creators.

## Features

- **Leaderboards**: Daily top videos based on performance metrics, updated every 24 hours
- **My Boards**: Custom boards for organizing and collecting TikTok videos
- **Content Repo**: Remixable templates with performance data and branching capability
- **Search and History**: Find content and view historical leaderboards
- **Mobile-Friendly**: Optimized for mobile devices with intuitive UI

## Tech Stack

- **Frontend**: Next.js, React, TypeScript, Tailwind CSS, Shadcn UI
- **Authentication**: Clerk
- **Database**: Supabase (PostgreSQL)
- **Data Scraping**: Apify

## Getting Started

### Prerequisites

- Node.js 18+ and npm
- Supabase account
- Clerk account
- Apify account

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/remix-content.git
   cd remix-content
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Set up environment variables:
   Create a `.env.local` file in the root directory with the following variables:
   ```
   # Clerk Authentication
   NEXT_PUBLIC_CLERK_PUBLISHABLE_KEY=your_clerk_publishable_key
   CLERK_SECRET_KEY=your_clerk_secret_key
   NEXT_PUBLIC_CLERK_SIGN_IN_URL=/sign-in
   NEXT_PUBLIC_CLERK_SIGN_UP_URL=/sign-up
   NEXT_PUBLIC_CLERK_AFTER_SIGN_IN_URL=/dashboard
   NEXT_PUBLIC_CLERK_AFTER_SIGN_UP_URL=/dashboard

   # Supabase Configuration
   NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key

   # Apify Configuration
   APIFY_API_KEY=your_apify_api_key
   APIFY_TIKTOK_TASK_ID=vinpenny/tiktok-data-extractor-task
   ```

4. Set up the Supabase database:
   - Create a new Supabase project
   - Run the SQL script in `supabase-schema.sql` in the Supabase SQL Editor

5. Start the development server:
   ```bash
   npm run dev
   ```

6. Open [http://localhost:3000](http://localhost:3000) in your browser.