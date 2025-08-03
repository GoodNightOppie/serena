#!/bin/bash

# Setup script for PM2 startup configuration
# Run this once to configure PM2 to start Serena MCP server at boot

echo "Setting up PM2 for Serena MCP server startup..."

# Change to the Serena directory
cd /home/dev/workspace/serena

# Ensure UV is available in PATH
export PATH="/home/dev/.local/bin:$PATH"

# Start the application with PM2
echo "Starting Serena MCP server with PM2..."
npx pm2 start ecosystem.config.js

# Save the PM2 process list
echo "Saving PM2 process list..."
npx pm2 save

# Generate startup script
echo "Generating PM2 startup script..."
npx pm2 startup systemd -u dev --hp /home/dev

echo ""
echo "=== IMPORTANT: Manual steps required ==="
echo ""
echo "1. Copy the systemd service file to the system directory:"
echo "   sudo cp /home/dev/workspace/serena/serena-pm2.service /etc/systemd/system/"
echo ""
echo "2. Reload systemd and enable the service:"
echo "   sudo systemctl daemon-reload"
echo "   sudo systemctl enable serena-pm2.service"
echo "   sudo systemctl start serena-pm2.service"
echo ""
echo "3. Check the service status:"
echo "   sudo systemctl status serena-pm2.service"
echo ""
echo "=== Alternative: Use PM2's built-in startup ==="
echo ""
echo "Run the following command that PM2 generated:"
npx pm2 startup systemd -u dev --hp /home/dev | grep sudo

echo ""
echo "After running the sudo command above, the Serena MCP server will start automatically on boot."
echo ""
echo "Useful PM2 commands:"
echo "  npx pm2 status         - Check status"
echo "  npx pm2 logs           - View logs"
echo "  npx pm2 restart all    - Restart all processes"
echo "  npx pm2 stop all       - Stop all processes"