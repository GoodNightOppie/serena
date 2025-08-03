#!/bin/bash

# Script to start Serena MCP server with PM2
# This script ensures the environment is properly set up before starting

# Change to the Serena directory
cd /home/dev/workspace/serena

# Ensure UV is available in PATH
export PATH="/home/dev/.local/bin:$PATH"

# Start the Serena MCP server using PM2
npx pm2 start ecosystem.config.js

# Show the PM2 status
npx pm2 status

# Save the PM2 process list
npx pm2 save

echo "Serena MCP server started with PM2"
echo "Use 'npx pm2 logs serena-mcp-server' to view logs"
echo "Use 'npx pm2 stop serena-mcp-server' to stop the server"
echo "Use 'npx pm2 restart serena-mcp-server' to restart the server"