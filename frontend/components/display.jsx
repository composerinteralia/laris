var React = require('react');

var nums = {
  0: "zero",
  1: "one",
  2: "two",
  3: "three",
  4: "four",
  5: "five",
  6: "six",
  7: "seven",
  8: "eight",
  9: "nine"
};

module.exports = React.createClass({
  render: function () {
    var bombCountDigits = this._digits(this.props.bombCount)
    var timeDigits = this._digits(this.props.time)

    return (
      <div className="display group">
        <ul className="nums bomb-count group">
            <li className={"num " + bombCountDigits[0]}></li>
            <li className={"num " + bombCountDigits[1]}></li>
            <li className={"num " + bombCountDigits[2]}></li>
        </ul>

        <ul className="nums timer group">
            <li className={"num " + timeDigits[0]}></li>
            <li className={"num " + timeDigits[1]}></li>
            <li className={"num " + timeDigits[2]}></li>
        </ul>
      </div>
    )
  },

  _digits: function (num) {
    var ones = nums[num % 10]
    var tens = nums[Math.floor(num / 10) % 10]
    var hundreds = nums[Math.floor(num / 100) % 10]

    return [hundreds, tens, ones]
  }
});
