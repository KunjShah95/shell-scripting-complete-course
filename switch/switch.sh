#!/bin/bash

# Simple program using case statement

echo "Enter a command (start, stop, status, restart, quit):"
read command

case "$command" in
    start)
        echo "Starting the service..."
        ;;
    stop)
        echo "Stopping the service..."
        ;;
    status)
        echo "Checking service status..."
        ;;
    restart)
        echo "Restarting the service..."
        ;;
    quit)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo "Unknown command: $command"
        echo "Usage: start|stop|status|restart|quit"
        ;;
esac