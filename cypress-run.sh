# cypress-run.sh

echo "===STARTING PHX SERVER==="
MIX_ENV=dev mix phx.server &
pid=$! # Store server pid
echo "===STARTING CYPRESS==="
npx -y cypress@latest run
result=$?
kill -9 $pid # kill server
echo "===KILLING PHX SERVER==="
exit $result
