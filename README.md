# MusicTime
Use Last.fm scrobbles to compare your favorite artists by play count and total play time

# Set Up

1. Clone the repo

```
git clone git@github.com:tmr08c/MusicTime.git
```

2. Bundle 

```
cd MusicTime
bundle
```

3. Create `.env` file

```
cp .env.example .env
```

edit using your favorite editor to include your [Last.fm API](http://www.last.fm/api) Client ID and Client Secret

4. Start the server

```
bundle exec rackup -I . -p 4567
```

5. Visit the page in your browser

```
http://localhost:4567/
```

