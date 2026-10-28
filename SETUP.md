# Dharamshala Split — setup (about 10 minutes)

## 1. Create the tables in Supabase
1. Open one of your Supabase projects (or make a new one).
2. Go to **SQL Editor → New query**, paste everything from `supabase-setup.sql`, and click **Run**.
   It only creates two new tables, `ds_expenses` and `ds_settings`, so your other tables are untouched.

## 2. Connect the app
1. In Supabase, go to **Project Settings → API**.
2. Copy the **Project URL** and the **anon / publishable** key. Never use the `service_role` key.
3. Open `index.html`, find these two lines near the bottom, and paste them in:
   ```js
   const SUPABASE_URL = 'PASTE_PROJECT_URL_HERE';
   const SUPABASE_ANON_KEY = 'PASTE_ANON_PUBLIC_KEY_HERE';
   ```
   (Or send them to Claude and it will paste them in for you. The anon key is designed to sit in web pages.)

## 3. Put it online
Easiest: go to **https://app.netlify.com/drop** and drag this whole `dharamshala-split` folder onto the page.
Netlify gives you a link like `https://something.netlify.app`. Rename it under **Site settings** if you like.
Vercel or GitHub Pages work the same way. It is one static file, with no build step.

## 4. Share
Send the link to the group. On a phone, use **Share → Add to Home Screen** so it opens like an app.

## Good to know
- Anyone with the link can add or delete expenses and change the names and budget. Only share it with the group.
- When the badge under the title says **"Synced with the group"**, you're connected. If it says
  **"Saved on this phone only"**, the URL or key in step 2 is missing or wrong.
