var React = require('react'),
    Minesweeper = require('../game/board'),
    Board = require('board'),
    Display = require('display');

module.exports = React.createClass({
  getInitialState: function () {
    var board = new Minesweeper({ height: 10, width: 10, numBombs: 10 })
    return { board: board, firstTurn: true, time: 0 };
  },

  componentDidMount: function () {
    document.addEventListener('keypress', this._onBoardReset);
  },

  componentWillUnmount: function () {
    document.removeEventListener('keypress', this._onBoardReset);
    clearInterval(this.timer)
  },

  render: function () {
    var board = this.state.board;

    return(
      <div>
        <Board board={ board } updateGame={ this._updateGame } >
          <Display time={ this.state.time } bombCount={ board.bombCount() }/>
        </Board>

        <section className="messages">
          { this._gameOverStatus() }
          <p className="replay">{ this._replayText() }</p>
        </section>

      </div>
    );
  },

  _gameOverStatus: function () {
    var board = this.state.board

    if (board.won()) {
      return (
        <p className="gameover won">
          Congratulations! You won in { this.state.time } seconds
        </p>
      );
    } else if (board.lost()) {
      return <p className="gameover lost">You lost!</p>;
    }
  },

  _replayText: function () {
    var board = this.state.board;

    if (!this.state.firstTurn) {
      if (board.over()) {
        return "Press enter to play again"
      } else {
        return "Press enter to start a new game"
      }
    }
  },

  _onBoardReset: function (e) {
    clearInterval(this.timer)
    if (!this.state.firstTurn && e.keyCode === 13) {
      clearInterval(this.timer)

      var board = new Minesweeper({ height: 10, width: 10, numBombs: 10 })
      this.setState({ board: board, firstTurn: true, time: 0 })
    }
  },

  _updateGame: function (tile, altKey) {
    var board = this.state.board

    if (board.over()) return;

    if (this.state.firstTurn) {
      this.timer = setInterval(function () {
        this.setState({ time: this.state.time + 1 })
      }.bind(this), 1000)

      if (tile.bombed) {
        board.exchange(tile)
      }
    }

    if (altKey) {
      tile.toggleFlag();
    } else {
      tile.explore();
    }

    if (board.over()) {
      clearInterval(this.timer);
    }

    this.setState({ firstTurn: false });
  }

});
