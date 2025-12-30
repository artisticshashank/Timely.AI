# Timely.AI Backend Deployment Guide

## Deploy to Render

### Step 1: Push your code to GitHub
1. Create a GitHub repository
2. Initialize git and push:
```bash
cd C:\Users\SHASHANK\OneDrive\Desktop\Timely.AI-main\Timely.AI-main
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/timely-ai.git
git push -u origin main
```

### Step 2: Deploy Backend on Render
1. Go to https://render.com and sign up/login
2. Click "New +" → "Web Service"
3. Connect your GitHub account and select your repository
4. Configure:
   - **Name**: timely-ai-backend
   - **Region**: Choose closest to you
   - **Branch**: main
   - **Root Directory**: server
   - **Runtime**: Python 3
   - **Build Command**: `pip install -r requirements.txt`
   - **Start Command**: `gunicorn app:app` ⚠️ **NOT** `gunicorn app:app.py`
5. Add Environment Variables:
   - **FLASK_ENV**: production
   - **ALLOWED_ORIGINS**: * (for now, update later with your Netlify URL)
6. Click "Create Web Service"
7. Wait 5-10 minutes for deployment
8. Copy your backend URL (e.g., https://timely-ai-backend.onrender.com)

### Step 3: Update Flutter Config
After backend is deployed, update `front-end/timely_ai/lib/config/app_config.dart`:
```dart
static const String serverUrl = String.fromEnvironment(
  'SERVER_URL',
  defaultValue: 'https://timely-ai-backend.onrender.com',
);
```

### Step 4: Deploy Frontend on Netlify
1. Go to https://netlify.com and sign up/login
2. Click "Add new site" → "Import an existing project"
3. Connect to GitHub and select your repository
4. Configure:
   - **Base directory**: front-end/timely_ai
   - **Build command**: `flutter build web --release`
   - **Publish directory**: front-end/timely_ai/build/web
5. Click "Deploy site"
6. Copy your Netlify URL

### Step 5: Update CORS on Render
1. Go back to Render dashboard
2. Click on your web service
3. Go to "Environment" tab
4. Update **ALLOWED_ORIGINS** to your Netlify URL: https://your-app.netlify.app
5. Save changes (will auto-redeploy)

## Testing
1. Open your Netlify URL
2. Try generating a timetable
3. Check if backend connection works

## Notes
- Render free tier may sleep after 15 minutes of inactivity
- First request after sleep takes ~30 seconds to wake up
- For always-on service, upgrade to paid plan ($7/month)
