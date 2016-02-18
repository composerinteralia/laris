var Tile = require('./tile');

Array.prototype.sample = function (size) {
  var els = this.slice(),
      result = [],
      index;

  while (result.length < size) {
    index = Math.floor(Math.random() * els.length);
    result.push(els[index]);
    els.splice(index, 1);
  }

  return result
};

var Board = function (options) {
  this.height = options.height;
  this.width = options.width;
  this.numBombs = options.numBombs;
  this.grid = [];
  this.generateGrid();
  this.plantBombs();
};

Board.prototype.bombCount = function () {
  if (this.over()) return 0;

  count = this.numBombs;

  this.forEachTile(function (tile) {
    if (tile.flagged) {
      count--;
    }
  });

  return count < 0 ? 0 : count;
};

Board.prototype.exchange = function (tile) {
  tile.removeBomb();
  this.unbombedTiles().sample(1)[0].plantBomb()
};

Board.prototype.forEachTile = function (fn) {
  this.grid.forEach(function (row) {
    row.forEach(fn)
  })
};

Board.prototype.generateGrid = function () {
  for (var i = 0; i < this.height; i++) {

    var row = []

    for (var j = 0; j < this.width; j++) {
      var tile = new Tile(this, [i, j]);
      row.push(tile);
    }

    this.grid.push(row);
  }
};

Board.prototype.plantBombs = function () {
  this.unluckyTiles().forEach(function (tile) {
    tile.plantBomb();
  })
};

Board.prototype.lost = function () {
  var lost = false;

  this.forEachTile(function(tile) {
    if (tile.bombed && tile.explored) {
      lost = true;
    }
  });

  return lost;
};

Board.prototype.onBoard = function (pos) {
  return (
    pos[0] >= 0 && pos[0] < this.height &&
      pos[1] >= 0 && pos[1] < this.width
  );
};

Board.prototype.over = function () {
  return this.won() || this.lost();
};

Board.prototype.unbombedTiles = function () {
  var unbombedTiles = [];

  this.forEachTile(function (tile) {
    if (!tile.bombed) {
      unbombedTiles.push(tile);
    }
  })

  return unbombedTiles;
}

Board.prototype.unluckyTiles = function () {
  var allTiles = [];

  this.forEachTile(function (tile) {
      allTiles.push(tile);
  })

  return allTiles.sample(this.numBombs);
};

Board.prototype.won = function () {
  var won = true;

  this.forEachTile(function(tile) {
    if (!tile.explored && !tile.bombed) {
      won = false;
    }
  });

  return won;
};

module.exports = Board;
