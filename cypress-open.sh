# cypress-open.sh

echo "===STARTING PHX SERVER==="
MIX_ENV=dev mix phx.server &
pid=$! # Store server pid
echo "===STARTING CYPRESS==="
npx cypress open
result=$?
kill -9 $pid # Kill server
echo "===KILLING PHX SERVER==="
exit $result # Return test result
