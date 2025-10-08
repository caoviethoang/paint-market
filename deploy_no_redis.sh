#!/bin/bash

# Deploy script without Redis - memory optimized
echo "🚀 Deploying with memory optimizations (no Redis)..."

# Set environment variables for memory optimization
export FORCE_GC=true
export RAILS_LOG_LEVEL=warn
export MALLOC_ARENA_MAX=2

# Set Heroku config vars for memory optimization
echo "⚙️ Setting memory optimization config vars..."
heroku config:set FORCE_GC=true -a havyart-afb1626d34a2
heroku config:set RAILS_LOG_LEVEL=warn -a havyart-afb1626d34a2
heroku config:set MALLOC_ARENA_MAX=2 -a havyart-afb1626d34a2

# Deploy to Heroku
echo "🚀 Deploying to Heroku..."
git add .
git commit -m "Optimize memory usage without Redis"
git push heroku deploy:main

# Scale dyno to Basic plan for more memory (if needed)
echo "📈 Checking dyno status..."
heroku ps:scale web=1 -a havyart-afb1626d34a2

# Restart dyno to apply changes
echo "🔄 Restarting dyno..."
heroku restart -a havyart-afb1626d34a2

echo "✅ Deployment complete! Check logs with: heroku logs --tail -a havyart-afb1626d34a2"
echo "💡 Memory optimizations applied:"
echo "   - Limited cache store to 16MB"
echo "   - Optimized image processing"
echo "   - Forced garbage collection"
echo "   - Reduced MALLOC_ARENA_MAX"
