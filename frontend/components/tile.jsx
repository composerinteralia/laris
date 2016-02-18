var React = require('react');

module.exports = React.createClass({
  handleClick: function (e) {
    e.preventDefault();

    var altKey = e.altKey || (e.button === 2)

    this.props.updateGame(this.props.tile, altKey);
  },

  render: function () {
    var tile = this.props.tile

    var face = "",
        htmlClasses = ["tile"];

    if (tile.explored) {
      htmlClasses.push("explored");

      if (tile.bombed) {
        htmlClasses.push("bombed");
        face = <span className="bomb" >💣</span>;

      } else {
        var count = tile.adjacentBombCount();
        htmlClasses.push("bomb-count-" + count)
        face = count || "";
      }

    } else if (tile.flagged) {
      htmlClasses.push("flagged")
      face = "⚑";
    }

    if (tile.board.over()) {
      htmlClasses.push("inactive")
    }

    return(
      <div style={ this._inlineStyling() }
        className={ htmlClasses.join(" ") }
        onMouseUp={ this.handleClick }
        onContextMenu={ function (e) { e.preventDefault() } }>
        { face }
      </div>
    );
  },

  _inlineStyling: function () {
    var board = this.props.tile.board

    if (board.lost()) {
      var x = Math.round((Math.random() - 0.5) * (window.innerWidth - 300));
      var y = Math.round((Math.random() - 0.55) * (window.innerHeight - 200));
      var degrees = Math.round((Math.random() - 0.5) * 1860);
      var seconds = Math.random();

      return {
        transform: "translate(" + x + "px, " + y + "px) rotate(" + degrees + "deg)",
        transition: "transform " + seconds + "s"
      }
    } else if (board.won()) {
      return {
        WebkitAnimationName: "shake",
        WebkitAnimationDuration: Math.random() + "s",
        WebkitAnimationIterationCount: "2"
      }
    } else {
      return {}
    }
  }
});
