mongod: mongod
server: node ./node_modules/forever/bin/forever -c coffee -f -m 3 --watch --watchDirectory="server" server/index.coffee
dev-server: node ./node_modules/forever/bin/forever -c coffee -f -m 3 --watch --watchDirectory="lib" lib/devServer.coffee
tests: java -jar ./lib/selenium-server-standalone-2.48.2.jar
