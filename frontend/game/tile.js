var Tile = function (board, pos) {
  this.board = board;
  this.pos = pos;
  this.bombed = false;
  this.explored = false;
  this.flagged = false;
};

Tile.DELTAS = [[-1, -1], [-1,  0], [-1,  1], [ 0, -1],
               [ 0,  1], [ 1, -1], [ 1,  0], [ 1,  1]];

Tile.prototype.adjacentBombCount = function() {
  if (typeof this.bombCount !== "undefined") {
    return this.bombCount;
  }

  var bombCount = 0;
  this.neighbors().forEach(function(neighbor) {
    if (neighbor.bombed) {
      bombCount++;
    }
  });

  // cache bombCount
  this.bombCount = bombCount;
  return bombCount;
};


Tile.prototype.adjacentFlagCount = function() {
  var flagCount = 0;

  this.neighbors().forEach(function(neighbor) {
    if (neighbor.flagged) {
      flagCount++;
    }
  });

  return flagCount;
}

Tile.prototype.explorable = function () {
  return (
    !this.bombed &&
    (this.adjacentBombCount() === 0 ||
    this.adjacentBombCount() === this.adjacentFlagCount())
  );
}

Tile.prototype.explore = function () {
  if (this.flagged) return this;

  this.explored = true;

  if (this.explorable()) {
    this.neighbors().forEach(function(tile) {
      if (!tile.explored) {
        tile.explore();
      }
    });
  }
};

Tile.prototype.neighbors = function() {
  if (typeof this.neighboringTiles !== "undefined") {
    return this.neighboringTiles;
  }

  var adjacentCoords = [],
      that = this;

  Tile.DELTAS.forEach(function (delta) {
    var newPos = [delta[0] + that.pos[0], delta[1] + that.pos[1]];
    if (that.board.onBoard(newPos)) {
      adjacentCoords.push(newPos);
    }
  });

  var neighboringTiles = adjacentCoords.map(function (coord) {
    return that.board.grid[coord[0]][coord[1]];
  });

  // cache neighbors
  this.neighboringTiles = neighboringTiles;
  return neighboringTiles;
};

Tile.prototype.plantBomb = function () {
  this.bombed = true;
};

Tile.prototype.removeBomb = function () {
  this.bombed = false;
}

Tile.prototype.toggleFlag = function () {
  if (!this.explored) {
    this.flagged = !this.flagged;
    return true;
  }

  return false;
};

module.exports = Tile;
