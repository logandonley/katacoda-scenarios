while ! [ -x "$(command -v git)" ]
do
  echo 'Waiting' >&2
  sleep 5
done
