#!/usr/bin/env bash

# The easiest way to start the project:
#  initializes the datastore
#  npm install and run the backend
#  npm install and run the frontend

echo "==== Initializing the datastore"
cd datastore
./initialize.sh
cd ..

echo "==== Starting the backend"
cd backend
npm install
nohup npm start &
BACKEND_PID=$!
echo "==== Started backend on port 3000 as PID $BACKEND_PID"
cd ..

echo "==== Starting the frontend"
cd frontend
npm install
nohup npm start &
FRONTEND_PID=$!
echo "==== Started frontend on port 4200 as PID $FRONTEND_PID"
cd ..

echo "==== EmberLoopSql is avaliable at http://localhost:4200"
echo "==== Select Contacts -> All to see data"
echo "==== backend and frontend output is redirected to their nohup.out files"
echo
read  -n 1 -p "==== Press ENTER to stop frontend and backend:" ignored

kill -15 $BACKEND_PID
kill -15 $FRONTEND_PID
