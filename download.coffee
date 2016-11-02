#!/usr/bin/env coffee

request = require "request"
cheerio = require "cheerio"
{createWriteStream} = require "fs"

RSS_URL = "http://musicforprogramming.net/rss.php"
SELECTOR = "enclosure"

request RSS_URL, (err, res, rss) ->
  console.log err if err?
  console.log "GET all mp3 link, prepare to download..."
  download link for link in process_rss rss

process_rss = (rss) ->
  $ = cheerio.load rss, xmlMode: yes
  url for {attribs: {url}} in $(SELECTOR).toArray() when url.match /^http:.+\.mp3$/

download = (link) ->
  filename = link[42..]
  request(link)
    .pipe createWriteStream "./#{filename}"
    .once "finish", -> console.log "SAVED #{link} to ./#{filename}"