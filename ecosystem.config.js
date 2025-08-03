module.exports = {
  apps: [{
    name: 'serena-mcp-server',
    script: './start-serena-mcp.sh',
    cwd: '/home/dev/workspace/serena',
    env: {
      NODE_ENV: 'production'
    },
    // Auto restart on crash
    autorestart: true,
    // Max restarts in a given time window
    max_restarts: 10,
    min_uptime: '10s',
    // Delay between restarts
    restart_delay: 4000,
    // Log configuration
    error_file: '/home/dev/workspace/serena/logs/serena-mcp-error.log',
    out_file: '/home/dev/workspace/serena/logs/serena-mcp-out.log',
    log_file: '/home/dev/workspace/serena/logs/serena-mcp-combined.log',
    time: true,
    // Watch for file changes (optional, usually disabled for production)
    watch: false,
    // Memory limit
    max_memory_restart: '1G'
  }]
};