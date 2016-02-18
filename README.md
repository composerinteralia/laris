#[Minesweeper][minesweeper]

The classic puzzle game built for the browser with React.js

###[Play Now!][minesweeper]

##Details:
* Clicking a tile either explodes it or reveals it and recursively reveals any safe neighbors
* Right clicking (or alt + click) flags tiles as unsafe
* Object Oriented design for board and tile logic
* Performance enhanced by caching tile's neighbors and neighboring bomb count
* Random bomb placement achieved with a monkey-patched array sampling method
* Renders Tile components with classes (for CSS styling) reflecting the tile's state and bomb count
* Renders Tiles components with inline styling for randomized shaking and exploding on winning or losing
* Prevents first-turn loss by moving the bomb to another tile

##Screenshots:

![gameplay]
![gameover]

[minesweeper]: https://composerinteralia.github.io/minesweeper/
[gameplay]: ./app/assets/images/gameplay.png
[gameover]: ./app/assets/images/gameover.png
