echo deb http://binaries.erlang-solutions.com/debian precise contrib | sudo tee -a /etc/apt/sources.list
wget -nv -O - http://binaries.erlang-solutions.com/debian/erlang_solutions.asc | sudo apt-key add -

sudo apt-get update -q -y

sudo apt-get install vim make git esl-erlang -q -y
