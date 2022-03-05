# cypress-run.sh

echo "===STARTING PHX SERVER==="
MIX_ENV=dev mix phx.server &
pid=$! # Store server pid
echo "===STARTING CYPRESS==="
npx cypress run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
